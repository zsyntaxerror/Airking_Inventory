import React, { useState, useEffect, useCallback, useMemo, useRef } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import AdminLayout from '../components/AdminLayout';
import Modal from '../components/Modal';
import {
  branchesAPI,
  itemsAPI,
  inventoryAPI,
  batchAPI,
  suppliersAPI,
  locationsAPI,
  purchaseOrdersAPI,
  statusAPI,
} from '../services/api';
import {
  addApprovalQueueRestockRequest,
  addApprovalQueuePurchaseOrder,
  addSystemNotification,
} from '../utils/approvalNotifications';
import '../styles/dashboard_air.css';
import '../styles/po_recommendation.css';

const DraftPOCreator = () => {
  const navigate = useNavigate();
  const location = useLocation();

  const [poDate, setPoDate]                         = useState(() => new Date().toISOString().slice(0, 10));
  const [expectedDeliveryDate, setExpectedDeliveryDate] = useState(() => {
    const d = new Date();
    d.setDate(d.getDate() + 3);
    return d.toISOString().slice(0, 10);
  });
  const [selectedSupplierId, setSelectedSupplierId] = useState('');
  const [paymentTerms, setPaymentTerms]             = useState('Net 30');
  const [suppliers, setSuppliers]                   = useState([]);
  const [loadingSuppliers, setLoadingSuppliers]     = useState(true);
  const [branches, setBranches]                     = useState([]);
  const [loadingBranches, setLoadingBranches]       = useState(true);
  const [selectedBranch, setSelectedBranch]         = useState('');
  const [categories, setCategories]                 = useState([]);
  const [brands, setBrands]                         = useState([]);
  const [loadingBatch, setLoadingBatch]             = useState(true);
  const [itemMasterOptions, setItemMasterOptions]   = useState([]);
  const [loadingItemMaster, setLoadingItemMaster]   = useState(true);
  const [lineItems, setLineItems]                   = useState([]);
  const [submitting, setSubmitting]                 = useState(false);
  const [submitError, setSubmitError]               = useState('');
  const [submitSuccess, setSubmitSuccess]           = useState(false);

  const [showManualItemModal, setShowManualItemModal] = useState(false);
  const [manualItemType, setManualItemType]           = useState('unit');
  const [manualItemForm, setManualItemForm]           = useState({
    targetBranch: '',
    category: '',
    brand: '',
    modelItemId: '',
    model: '',
    variant: '',
    measurement: '',
    currentStock: 0,
    orderQty: 1,
    unitCost: 0,
  });
  const [addItemError, setAddItemError] = useState('');
  const [addingItem, setAddingItem]     = useState(false);

  const referenceNo = useRef((() => {
    const d   = new Date();
    const ymd = `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}${String(d.getDate()).padStart(2, '0')}`;
    const seq = String(Math.floor(Math.random() * 999) + 1).padStart(3, '0');
    return `PO-${ymd}-${seq}`;
  })()).current;

  useEffect(() => {
    let mounted = true;
    const load = async () => {
      try {
        const first = await branchesAPI.getAll({ status: 'Active', per_page: 100, page: 1 });
        const list  = Array.isArray(first?.data) ? [...first.data] : [];
        const total = first?.pagination?.last_page ?? 1;
        for (let p = 2; p <= total; p++) {
          const more = await branchesAPI.getAll({ status: 'Active', per_page: 100, page: p });
          list.push(...(Array.isArray(more?.data) ? more.data : []));
        }
        if (mounted) {
          setBranches(list);
          if (list.length) setSelectedBranch(String(list[0].id));
        }
      } catch (err) {
        console.error('Branches fetch failed:', err);
      } finally {
        if (mounted) setLoadingBranches(false);
      }
    };
    load();
    return () => { mounted = false; };
  }, []);

  useEffect(() => {
    let mounted = true;
    Promise.allSettled([
      batchAPI.get({ include: ['categories', 'brands'] }),
      suppliersAPI.getAll({ per_page: 200 }),
      itemsAPI.getAll({ per_page: 1000 }),
      inventoryAPI.getAll({ per_page: 1000 }),
    ]).then(([batchResult, suppResult, itemsResult, inventoryResult]) => {
      if (!mounted) return;
      if (batchResult.status === 'fulfilled') {
        const d = batchResult.value?.data || {};
        setCategories(Array.isArray(d.categories?.data) ? d.categories.data : []);
        setBrands(Array.isArray(d.brands?.data) ? d.brands.data : []);
      }
      if (suppResult.status === 'fulfilled') {
        const list = Array.isArray(suppResult.value?.data) ? suppResult.value.data : [];
        setSuppliers(list);
        if (list.length) setSelectedSupplierId(String(list[0].supplier_id ?? list[0].id ?? ''));
      }
      const inventoryRows = inventoryResult?.status === 'fulfilled' && Array.isArray(inventoryResult.value?.data)
        ? inventoryResult.value.data
        : [];
      const stockByProductId = new Map();
      inventoryRows.forEach((inv) => {
        const pid = String(inv.product_id ?? inv.product?.product_id ?? '');
        if (!pid) return;
        const q = Number(inv.quantity_on_hand ?? inv.quantity ?? 0);
        stockByProductId.set(pid, (stockByProductId.get(pid) || 0) + q);
      });
      if (itemsResult?.status === 'fulfilled') {
        const rows = Array.isArray(itemsResult.value?.data) ? itemsResult.value.data : [];
        const normalized = rows.map((item) => {
          const id = item.product_id ?? item.id ?? null;
          const pid = String(id ?? '');
          return {
            id: pid,
            name: item.product_name || item.name || 'Unknown Item',
            brand: item.brand?.brand_name || item.brand_name || item.brand || '',
            brandId: String(item.brand_id ?? item.brand?.brand_id ?? ''),
            category: item.category?.category_name || item.category_name || item.category || '',
            categoryId: String(item.category_id ?? item.category?.category_id ?? ''),
            unitCost: Number(item.cost_price ?? item.unit_price ?? item.price ?? 0),
            stock: stockByProductId.get(pid) ?? 0,
          };
        });
        setItemMasterOptions(normalized);
      }

      // If we navigated here from PO Recommendation with selected items, prefill line items.
      const recommended = Array.isArray(location?.state?.recommendedItems)
        ? location.state.recommendedItems
        : [];
      if (recommended.length) {
        setLineItems((prev) => {
          // avoid duplicates across multiple navigations
          const existingProductIds = new Set(prev.map((p) => String(p.productId ?? '')));
          const next = [...prev];
          recommended.forEach((r) => {
            const pid = String(r.product_id ?? '');
            if (!pid || existingProductIds.has(pid)) return;
            const qty = Math.max(1, parseInt(r.suggested_qty, 10) || 1);
            const unitCost = Number(r.unit_cost ?? 0);
            next.push({
              id:        `reco-${pid}-${Date.now()}-${Math.random().toString(36).slice(2, 6)}`,
              productId: Number(pid),
              product:   r.product_name || r.product_code || `Product ${pid}`,
              brand:     r.brand || '—',
              category:  r.category || '—',
              type:      (r.product_type || '').toLowerCase() === 'consumable' ? 'PART' : 'APPLIANCES',
              qty,
              unitCost,
              total:     qty * unitCost,
              location:  r.location_name || 'Recommended',
            });
            existingProductIds.add(pid);
          });
          return next;
        });
      }

      setLoadingBatch(false);
      setLoadingSuppliers(false);
      setLoadingItemMaster(false);
    });
    return () => { mounted = false; };
  }, [location?.state]);

  const updateLineItemQty = useCallback((id, qty) => {
    const newQty = Math.max(1, parseInt(qty) || 1);
    setLineItems((prev) =>
      prev.map((item) =>
        item.id === id ? { ...item, qty: newQty, total: newQty * item.unitCost } : item
      )
    );
  }, []);

  const removeLineItem = useCallback((id) => {
    setLineItems((prev) => prev.filter((item) => item.id !== id));
  }, []);

  const itemsSubtotal = useMemo(
    () => lineItems.reduce((s, i) => s + i.total, 0),
    [lineItems]
  );
  const appliedVat         = Math.round(itemsSubtotal * 0.12);
  const totalEstimatedValue = itemsSubtotal + appliedVat;

  const openManualItemModal = useCallback(() => {
    setAddItemError('');
    setManualItemType('unit');
    setManualItemForm({
      targetBranch: selectedBranch || (branches[0] ? String(branches[0].id) : ''),
      category: '',
      brand: '',
      modelItemId: '',
      model: '',
      variant: '',
      measurement: '',
      currentStock: 0,
      orderQty: 1,
      unitCost: 0,
    });
    setShowManualItemModal(true);
  }, [selectedBranch, branches]);

  const handleManualItemFormChange = useCallback((field, value) => {
    setManualItemForm((prev) => ({ ...prev, [field]: value }));
  }, []);

  const filteredModelOptions = useMemo(() => {
    if (manualItemType !== 'unit') return [];
    return itemMasterOptions.filter((item) => {
      if (manualItemForm.category && item.category !== manualItemForm.category) return false;
      if (manualItemForm.brand && item.brand !== manualItemForm.brand) return false;
      return true;
    });
  }, [itemMasterOptions, manualItemType, manualItemForm.category, manualItemForm.brand]);

  const handleModelSelect = useCallback((itemId) => {
    const selected = itemMasterOptions.find((it) => String(it.id) === String(itemId));
    setManualItemForm((prev) => ({
      ...prev,
      modelItemId: String(itemId || ''),
      model: selected?.name || '',
      currentStock: selected?.stock ?? 0,
      unitCost: selected ? selected.unitCost : prev.unitCost,
      category: selected?.category || prev.category,
      brand: selected?.brand || prev.brand,
    }));
  }, [itemMasterOptions]);

  useEffect(() => {
    if (manualItemType !== 'unit') return;
    if (!manualItemForm.modelItemId) return;
    const stillValid = filteredModelOptions.some(
      (it) => String(it.id) === String(manualItemForm.modelItemId)
    );
    if (!stillValid) {
      setManualItemForm((prev) => ({
        ...prev,
        modelItemId: '',
        model: '',
        currentStock: 0,
      }));
    }
  }, [manualItemType, manualItemForm.modelItemId, filteredModelOptions]);

  const handleConfirmAndAdd = useCallback(async () => {
    setAddItemError('');
    const { category, brand, modelItemId, model, variant, measurement, currentStock, orderQty, unitCost } =
      manualItemForm;
    const name = (manualItemType === 'unit' ? model || brand : variant)?.trim() || 'Custom Item';
    if (!category?.trim()) { setAddItemError('Category is required.'); return; }
    const unitPrice = parseFloat(unitCost) || 0;
    if (unitPrice < 0) { setAddItemError('Unit cost must be 0 or greater.'); return; }

    setAddingItem(true);
    try {
      if (manualItemType === 'unit') {
        if (!modelItemId) { setAddItemError('Model / Name is required.'); return; }
        const selectedModel = itemMasterOptions.find((it) => String(it.id) === String(modelItemId));
        if (!selectedModel) { setAddItemError('Selected model was not found in Item Master.'); return; }
        const qty = Math.max(1, parseInt(orderQty, 10) || 1);
        setLineItems((prev) => [
          ...prev,
          {
            id:        `existing-${selectedModel.id}-${Date.now()}`,
            productId: Number(selectedModel.id),
            product:   selectedModel.name,
            brand:     selectedModel.brand || '—',
            category:  selectedModel.category || category.trim(),
            type:      'APPLIANCES',
            qty,
            unitCost:  Number(unitPrice || selectedModel.unitCost || 0),
            total:     qty * Number(unitPrice || selectedModel.unitCost || 0),
            location:  branches.find((b) => String(b.id) === String(manualItemForm.targetBranch))?.location_name || 'Manual Entry',
          },
        ]);
        setShowManualItemModal(false);
        return;
      }

      const code = `CUST-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
      const res  = await itemsAPI.create({
        name:         name.substring(0, 255),
        code,
        category:     category.trim(),
        brand:        brand?.trim() || null,
        description:  manualItemType === 'part' ? (variant || null) : null,
        unit_price:   unitPrice,
        unit:         measurement?.trim() || 'Unit',
        reorder_level: parseInt(currentStock, 10) || 0,
        status:       'Active',
      });
      const created = res?.data;
      const qty     = Math.max(1, parseInt(orderQty, 10) || 1);
      setLineItems((prev) => [
        ...prev,
        {
          id:        `manual-${Date.now()}`,
          productId: created?.id ?? null,
          product:   created?.name ?? name,
          brand:     brand || '—',
          category:  category.trim(),
          type:      manualItemType === 'unit' ? 'APPLIANCES' : 'PART',
          qty,
          unitCost:  unitPrice,
          total:     qty * unitPrice,
          location:  'Manual Entry',
        },
      ]);
      setShowManualItemModal(false);
    } catch (err) {
      const msg = err?.errors
        ? Object.values(err.errors).flat().join(' ')
        : err?.message || 'Failed to create item.';
      setAddItemError(msg);
    } finally {
      setAddingItem(false);
    }
  }, [manualItemForm, manualItemType, itemMasterOptions, branches]);

  const selectedSupplierName = useMemo(() => {
    const id = String(selectedSupplierId || '');
    const s = suppliers.find(
      (x) => String(x.supplier_id ?? x.id ?? '') === id
    );
    return (s?.supplier_name ?? s?.name ?? '').trim() || '—';
  }, [suppliers, selectedSupplierId]);

  const handleFinalSubmission = useCallback(async () => {
    setSubmitError('');
    if (lineItems.length === 0) { setSubmitError('Add at least one item to the purchase order.'); return; }
    if (!selectedSupplierId)    { setSubmitError('Please select a supplier.'); return; }
    if (!poDate)                { setSubmitError('Please select a PO date.'); return; }
    setSubmitting(true);
    try {
      let preparedBy = 'Inventory Analyst';
      try {
        const rawUser = localStorage.getItem('user');
        const parsedUser = rawUser ? JSON.parse(rawUser) : null;
        if (parsedUser?.first_name || parsedUser?.last_name) {
          preparedBy = `${parsedUser.first_name || ''} ${parsedUser.last_name || ''}`.trim();
        } else if (parsedUser?.username) {
          preparedBy = parsedUser.username;
        }
      } catch (_) {}

      const totalQty = lineItems.reduce((sum, item) => sum + Number(item.qty || 0), 0);
      const topItem = lineItems[0];

      let locationIdForPo = '';
      try {
        const locRes = await locationsAPI.getAll({ per_page: 500 });
        const locs = Array.isArray(locRes?.data) ? locRes.data : [];
        const matchBranch = locs.find((l) => String(l.branch_id ?? '') === String(selectedBranch));
        const wh = locs.find((l) => String(l.location_type || '').toLowerCase() === 'warehouse');
        const first = locs[0];
        const pick = matchBranch || wh || first;
        locationIdForPo = String(pick?.location_id ?? pick?.id ?? '');
      } catch (_) {
        /* location resolved below — queue still works without API payload */
      }

      const poDetails = lineItems
        .map((li) => {
          const pid = li.productId != null ? Number(li.productId) : NaN;
          if (!Number.isFinite(pid) || pid <= 0) return null;
          const qty = Math.max(1, parseInt(li.qty, 10) || 1);
          const unit = Number(li.unitCost) || 0;
          return {
            product_id: pid,
            quantity_ordered: qty,
            unit_price: unit,
            subtotal: Number(li.total) || qty * unit,
          };
        })
        .filter(Boolean);

      const apiCreatePayload =
        poDetails.length > 0 && locationIdForPo
          ? {
              supplier_id: Number(selectedSupplierId),
              location_id: Number(locationIdForPo),
              pc_number: referenceNo,
              order_date: poDate,
              expected_delivery_date: expectedDeliveryDate || null,
              details: poDetails,
            }
          : null;

      const restockEntry = {
        id: `rstk-${Date.now()}-${Math.random().toString(36).slice(2, 7)}`,
        item_name: lineItems.length === 1
          ? (topItem?.product || 'Requested Item')
          : `${lineItems.length} low-stock items`,
        destination: branches.find((b) => String(b.id) === String(selectedBranch))?.location_name || 'Branch',
        quantity: totalQty || lineItems.length,
        from: selectedSupplierName,
        requested_by: preparedBy,
        date: new Date().toLocaleString('en-PH', {
          year: 'numeric',
          month: '2-digit',
          day: '2-digit',
          hour: '2-digit',
          minute: '2-digit',
        }),
        status: 'pending',
        draft_reference: referenceNo,
        estimated_amount: Number(totalEstimatedValue ?? 0),
        expected_delivery_date: expectedDeliveryDate,
      };

      const queuePoId = `aq-po-${Date.now()}`;
      const queuePoBase = {
        id: queuePoId,
        po_number: referenceNo,
        supplier: selectedSupplierName,
        amount: Number(totalEstimatedValue ?? 0),
        prepared_by: preparedBy,
        date: restockEntry.date,
        expected_delivery_date: expectedDeliveryDate,
      };

      if (apiCreatePayload) {
        let pendingStatusId = null;
        try {
          const stRes = await statusAPI.getAll({ category: 'purchase_order' });
          const stRows = Array.isArray(stRes?.data) ? stRes.data : [];
          pendingStatusId = stRows.find((s) => String(s.status_name || '').toLowerCase().includes('pending'))?.status_id ?? null;
        } catch (_) {
          /* optional — PO still created without status */
        }
        const createBody = {
          ...apiCreatePayload,
          ...(pendingStatusId ? { status_id: pendingStatusId } : {}),
        };
        try {
          const res = await purchaseOrdersAPI.create(createBody);
          const data = res?.data;
          const backendPoId = data?.po_id ?? data?.id;
          if (backendPoId == null || backendPoId === '') {
            setSubmitError('Server did not return a purchase order ID. Check the API response.');
            return;
          }
          addApprovalQueueRestockRequest(restockEntry);
          addApprovalQueuePurchaseOrder({
            ...queuePoBase,
            status: 'pending',
            synced_to_api: true,
            backend_po_id: backendPoId,
            api_create_payload: null,
            api_sync_note: undefined,
          });
        } catch (apiErr) {
          const msg = apiErr?.errors
            ? Object.values(apiErr.errors).flat().join(' ')
            : apiErr?.message || 'Could not save the purchase order to the database.';
          setSubmitError(msg);
          return;
        }
      } else {
        addApprovalQueueRestockRequest(restockEntry);
        addApprovalQueuePurchaseOrder({
          ...queuePoBase,
          status: 'pending',
          synced_to_api: false,
          api_create_payload: null,
          api_sync_note:
            poDetails.length === 0
              ? 'Add line items from Item Master (linked products) so the PO can be saved to the database on submit.'
              : !locationIdForPo
                ? 'No receiving location matched this branch; set up locations with branch_id in Location Management.'
                : undefined,
        });
      }

      addSystemNotification({
        type: 'approval',
        title: 'New Restock Request',
        description: `${restockEntry.draft_reference} submitted by ${restockEntry.requested_by}.`,
        details: `${restockEntry.item_name} • Qty: ${restockEntry.quantity} • Est: ₱${restockEntry.estimated_amount.toLocaleString('en-PH')}`,
        route: '/admin/approval-queue?tab=restock-requests',
      });

      setSubmitSuccess(true);
    } catch (err) {
      const msg = err?.errors
        ? Object.values(err.errors).flat().join(' ')
        : err?.message || 'Failed to submit purchase order.';
      setSubmitError(msg);
    } finally {
      setSubmitting(false);
    }
  }, [
    lineItems, selectedSupplierId, poDate, paymentTerms, selectedBranch,
    referenceNo, itemsSubtotal, appliedVat, totalEstimatedValue, selectedSupplierName, branches,
    expectedDeliveryDate,
  ]);

  const handleAfterSuccessClose = useCallback(() => {
    setSubmitSuccess(false);
    setLineItems([]);
    window.scrollTo(0, 0);
  }, []);

  const createdOnLabel = useMemo(() => {
    if (!poDate) return '—';
    const d = new Date(`${poDate}T12:00:00`);
    if (Number.isNaN(d.getTime())) return '—';
    return d
      .toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
      .toUpperCase();
  }, [poDate]);

  const lineTypeLabel = (type) => (type === 'PART' ? 'PART' : 'APPLIANCE');

  return (
    <AdminLayout>
      <div className="po-recommendation-page po-draft-creator-page">
        {submitSuccess && (
          <div className="po-success-banner">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="18" height="18">
              <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
              <polyline points="22 4 12 14.01 9 11.01"></polyline>
            </svg>
            Purchase Order <strong>{referenceNo}</strong> submitted successfully!
            <button
              type="button"
              className="po-success-close"
              onClick={handleAfterSuccessClose}
            >
              ✕
            </button>
          </div>
        )}

        <div className="po-creator-toolbar">
          <button type="button" className="po-back-btn" onClick={() => navigate('/admin/po-recommendations')}>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" width="18" height="18">
              <line x1="19" y1="12" x2="5" y2="12"></line>
              <polyline points="12 19 5 12 12 5"></polyline>
            </svg>
            Back
          </button>
        </div>

        <div className="po-creator-header-card">
          <div className="po-creator-header-grid">
            <div className="po-creator-header-main">
              <div className="po-creator-cart-wrap" aria-hidden>
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" width="28" height="28">
                  <circle cx="9" cy="21" r="1"></circle>
                  <circle cx="20" cy="21" r="1"></circle>
                  <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path>
                </svg>
              </div>
              <div className="po-creator-header-copy">
                <div className="po-creator-title-row">
                  <h1 className="po-page-title">PURCHASE ORDER CREATOR</h1>
                  <span className="po-draft-badge po-draft-badge--inline">INTERNAL DRAFT</span>
                </div>
                <p className="po-page-status">
                  Status: <span className="status-pending">PENDING REVIEW</span>
                  <span className="po-status-dot" aria-hidden> • </span>
                  CREATED ON {createdOnLabel}
                </p>
              </div>
            </div>
            <div className="po-creator-header-actions">
              <button type="button" className="po-btn po-btn-export-excel">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="15" height="15">
                  <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                  <polyline points="7 10 12 15 17 10"></polyline>
                  <line x1="12" y1="15" x2="12" y2="3"></line>
                </svg>
                EXPORT EXCEL
              </button>
              <button type="button" className="po-btn po-btn-export-doc">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="15" height="15">
                  <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                  <polyline points="14 2 14 8 20 8"></polyline>
                </svg>
                EXPORT DOCUMENT
              </button>
              <button
                type="button"
                className="po-btn po-btn-final-submission"
                onClick={handleFinalSubmission}
                disabled={submitting}
              >
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="16" height="16">
                  <path d="M22 2L11 13"></path>
                  <path d="M22 2l-7 20-4-9-9-4 20-7z"></path>
                </svg>
                {submitting ? 'SUBMITTING...' : 'FINAL SUBMISSION'}
              </button>
            </div>
          </div>
        </div>

        {submitError && (
          <div className="po-submit-error">{submitError}</div>
        )}

        <div className="po-content-layout">
          <div className="po-main-content">
            <div className="po-details-card">
              <div className="po-details-grid">
                <div className="po-field">
                  <label className="po-field-label">REFERENCE NO.</label>
                  <div className="po-reference-badge">{referenceNo}</div>
                </div>
                <div className="po-field">
                  <label className="po-field-label">SUPPLIER</label>
                  <select
                    className="po-select"
                    value={selectedSupplierId}
                    onChange={(e) => setSelectedSupplierId(e.target.value)}
                    disabled={loadingSuppliers}
                  >
                    {loadingSuppliers && <option value="">Loading suppliers…</option>}
                    {!loadingSuppliers && suppliers.length === 0 && <option value="">No suppliers</option>}
                    {suppliers.map((s) => (
                      <option key={s.supplier_id ?? s.id} value={String(s.supplier_id ?? s.id)}>
                        {s.supplier_name ?? s.name}
                      </option>
                    ))}
                  </select>
                </div>
                <div className="po-field">
                  <label className="po-field-label">PAYMENT TERMS</label>
                  <select
                    className="po-select"
                    value={paymentTerms}
                    onChange={(e) => setPaymentTerms(e.target.value)}
                  >
                    <option>Net 30</option>
                    <option>Net 60</option>
                    <option>Net 15</option>
                    <option>COD</option>
                    <option>Upon Delivery</option>
                  </select>
                </div>
                <div className="po-field">
                  <label className="po-field-label">PO DATE</label>
                  <input
                    type="date"
                    className="po-input"
                    value={poDate}
                    onChange={(e) => setPoDate(e.target.value)}
                  />
                </div>
                <div className="po-field">
                  <label className="po-field-label">EXPECTED DELIVERY (ARRIVAL)</label>
                  <input
                    type="date"
                    className="po-input"
                    value={expectedDeliveryDate}
                    onChange={(e) => setExpectedDeliveryDate(e.target.value)}
                    title="Used in Approval Queue and to block warehouse scan-receive before this date."
                  />
                  <span className="po-field-hint" style={{ display: 'block', marginTop: 6, fontSize: 12, color: '#64748b' }}>
                    Receive PO scan is blocked until this date (after the PO is approved).
                  </span>
                </div>
              </div>
            </div>

            <div className="po-line-items-card">
              <div className="po-line-items-header">
                <div className="po-line-items-title">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="18" height="18">
                    <line x1="8" y1="6" x2="21" y2="6"></line>
                    <line x1="8" y1="12" x2="21" y2="12"></line>
                    <line x1="8" y1="18" x2="21" y2="18"></line>
                    <line x1="3" y1="6" x2="3.01" y2="6"></line>
                    <line x1="3" y1="12" x2="3.01" y2="12"></line>
                    <line x1="3" y1="18" x2="3.01" y2="18"></line>
                  </svg>
                  LINE ITEMS ORGANIZATION
                  <span className="po-line-items-count">{lineItems.length}</span>
                </div>
                <button type="button" className="po-btn po-btn-add-product" onClick={openManualItemModal}>
                  + ADD CUSTOM PRODUCT
                </button>
              </div>

              {lineItems.length === 0 ? (
                <div className="po-line-items-empty">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" width="40" height="40">
                    <rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect>
                    <line x1="8" y1="21" x2="16" y2="21"></line>
                    <line x1="12" y1="17" x2="12" y2="21"></line>
                  </svg>
                  <p>No line items yet.</p>
                  <span>Add products using the button above, or review PO Recommendation for suggested items.</span>
                </div>
              ) : (
                <div className="po-table-wrapper">
                  <table className="po-table">
                    <thead>
                      <tr>
                        <th>PRODUCT / MODEL / LOCATION</th>
                        <th>CATEGORY</th>
                        <th>TYPE</th>
                        <th>QTY</th>
                        <th>UNIT COST</th>
                        <th>TOTAL</th>
                        <th></th>
                      </tr>
                    </thead>
                    <tbody>
                      {lineItems.map((item) => (
                        <tr key={item.id}>
                          <td>
                            <div className="po-product-cell">
                              <strong>{item.product}</strong>
                              <div className="po-product-meta">
                                {selectedSupplierName} <span className="po-product-meta-sep">|</span>{' '}
                                {item.location && item.location !== '—' ? item.location : '—'}
                              </div>
                            </div>
                          </td>
                          <td>{item.category}</td>
                          <td>
                            <span className={`po-type-badge ${item.type === 'PART' ? 'po-type-part' : 'po-type-appliance'}`}>
                              {lineTypeLabel(item.type)}
                            </span>
                          </td>
                          <td>
                            <input
                              className="po-qty-input"
                              type="number"
                              min="1"
                              value={item.qty}
                              onChange={(e) => updateLineItemQty(item.id, e.target.value)}
                            />
                          </td>
                          <td>₱{item.unitCost.toLocaleString()}</td>
                          <td><strong>₱{item.total.toLocaleString()}</strong></td>
                          <td>
                            <button
                              type="button"
                              className="po-remove-btn"
                              onClick={() => removeLineItem(item.id)}
                              title="Remove item"
                            >
                              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="14" height="14">
                                <polyline points="3 6 5 6 21 6"></polyline>
                                <path d="M19 6l-1 14H6L5 6"></path>
                                <path d="M10 11v6"></path>
                                <path d="M14 11v6"></path>
                                <path d="M9 6V4h6v2"></path>
                              </svg>
                            </button>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              )}
            </div>
          </div>

          <div className="po-summary-sidebar">
            <div className="po-summary-card">
              <h3 className="po-summary-title">
                <span className="po-summary-title-icon" aria-hidden>
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="18" height="18">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                    <polyline points="14 2 14 8 20 8"></polyline>
                    <line x1="16" y1="13" x2="8" y2="13"></line>
                    <line x1="16" y1="17" x2="8" y2="17"></line>
                  </svg>
                </span>
                COMMERCIAL SUMMARY
              </h3>
              <div className="po-summary-row">
                <span>ITEMS SUBTOTAL</span>
                <span className="po-summary-value">₱{itemsSubtotal.toLocaleString()}</span>
              </div>
              <div className="po-summary-row">
                <span>APPLIED VAT (12%)</span>
                <span className="po-summary-value po-summary-vat">₱{appliedVat.toLocaleString()}</span>
              </div>
              <div className="po-summary-row po-summary-row--logistics">
                <span>LOGISTICS EST.</span>
                <span className="po-summary-logistics-value">CALCULATED ON APPROVAL</span>
              </div>
              <div className="po-summary-total">
                <span>TOTAL ESTIMATED VALUE</span>
                <span className="po-summary-total-value">₱{totalEstimatedValue.toLocaleString()}</span>
              </div>
            </div>

            <div className="po-export-reminder">
              <span className="po-export-reminder-icon" aria-hidden>
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="18" height="18">
                  <circle cx="12" cy="12" r="10"></circle>
                  <line x1="12" y1="16" x2="12" y2="12"></line>
                  <line x1="12" y1="8" x2="12.01" y2="8"></line>
                </svg>
              </span>
              <div className="po-export-reminder-body">
                <h4>EXPORT REMINDER</h4>
                <p>
                  Use the Excel or Document export buttons above to generate formal files for offline archiving or physical signing.
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <Modal
        isOpen={showManualItemModal}
        onClose={() => setShowManualItemModal(false)}
        title=""
        hideHeader
        maxWidth={760}
      >
        <div className="manual-item-modal">
          <div className="manual-item-modal-header">
            <div className="manual-item-modal-icon">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="20" height="20">
                <line x1="12" y1="5" x2="12" y2="19"></line>
                <line x1="5" y1="12" x2="19" y2="12"></line>
              </svg>
            </div>
            <div>
              <h2 className="manual-item-modal-title">MANUAL ITEM ENTRY</h2>
              <p className="manual-item-modal-subtitle">ADD CUSTOMIZED ITEMS TO PROCUREMENT</p>
            </div>
            <button
              type="button"
              className="manual-item-close"
              onClick={() => setShowManualItemModal(false)}
              aria-label="Close manual item modal"
            >
              ×
            </button>
          </div>

          <div className="manual-item-type-toggle">
            <button
              type="button"
              className={`manual-item-type-btn${manualItemType === 'unit' ? ' active' : ''}`}
              onClick={() => setManualItemType('unit')}
            >
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="15" height="15">
                <rect x="4" y="4" width="16" height="16" rx="2"></rect>
                <line x1="4" y1="12" x2="20" y2="12"></line>
              </svg>
              UNIT / APPLIANCE
            </button>
            <button
              type="button"
              className={`manual-item-type-btn${manualItemType === 'part' ? ' active' : ''}`}
              onClick={() => setManualItemType('part')}
            >
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="15" height="15">
                <circle cx="12" cy="12" r="3"></circle>
                <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
              </svg>
              PART / CONSUMABLE
            </button>
          </div>

          <div className="manual-item-form">
            <div className="manual-item-form-row">
              <div className="manual-item-form-field">
                <label>TARGET LOCATION</label>
                <select
                  value={manualItemForm.targetBranch || (branches[0] ? String(branches[0].id) : '')}
                  onChange={(e) => handleManualItemFormChange('targetBranch', e.target.value)}
                  disabled={loadingBranches}
                >
                  {loadingBranches && <option value="">Loading…</option>}
                  {!loadingBranches && branches.length === 0 && <option value="">No branches</option>}
                  {branches.map((b) => (
                    <option key={b.id} value={String(b.id)}>{b.location_name || b.name}</option>
                  ))}
                </select>
              </div>
              <div className="manual-item-form-field">
                <label>CATEGORY</label>
                <select
                  value={manualItemForm.category}
                  onChange={(e) => handleManualItemFormChange('category', e.target.value)}
                  disabled={loadingBatch}
                >
                  <option value="">Select Category</option>
                  {categories.map((cat) => (
                    <option key={cat.category_id} value={cat.category_name}>{cat.category_name}</option>
                  ))}
                </select>
              </div>
            </div>

            {manualItemType === 'unit' ? (
              <div className="manual-item-form-row">
                <div className="manual-item-form-field">
                  <label>BRAND</label>
                  <select
                    value={manualItemForm.brand}
                    onChange={(e) => handleManualItemFormChange('brand', e.target.value)}
                    disabled={loadingBatch}
                  >
                    <option value="">Select Brand</option>
                    {brands.map((b) => (
                      <option key={b.brand_id} value={b.brand_name}>{b.brand_name}</option>
                    ))}
                  </select>
                </div>
                <div className="manual-item-form-field">
                  <label>MODEL / NAME</label>
                  <select
                    value={manualItemForm.modelItemId}
                    onChange={(e) => handleModelSelect(e.target.value)}
                    disabled={loadingItemMaster}
                  >
                    <option value="">{loadingItemMaster ? 'Loading model list…' : 'Select Model / Name'}</option>
                    {filteredModelOptions.map((it) => (
                      <option key={it.id} value={it.id}>
                        {it.name}
                      </option>
                    ))}
                  </select>
                </div>
              </div>
            ) : (
              <div className="manual-item-form-row">
                <div className="manual-item-form-field">
                  <label>VARIANT</label>
                  <select
                    value={manualItemForm.variant}
                    onChange={(e) => handleManualItemFormChange('variant', e.target.value)}
                  >
                    <option value="">Select Variant</option>
                    <option>Copper Tube</option>
                    <option>Insulation</option>
                    <option>Refrigerant</option>
                    <option>Filter</option>
                    <option>Capacitor</option>
                    <option>Fan Motor</option>
                    <option>Other</option>
                  </select>
                </div>
                <div className="manual-item-form-field">
                  <label>MEASUREMENT</label>
                  <select
                    value={manualItemForm.measurement}
                    onChange={(e) => handleManualItemFormChange('measurement', e.target.value)}
                  >
                    <option value="">Select Measurement</option>
                    <option>1/4 - 10 Rolls</option>
                    <option>3/8 - 10 Rolls</option>
                    <option>1/2 - 10 Rolls</option>
                    <option>Per Unit</option>
                    <option>Per Piece</option>
                    <option>Per Set</option>
                    <option>Per Box</option>
                    <option>Per Kg</option>
                    <option>Per Liter</option>
                  </select>
                </div>
              </div>
            )}

            <div className="manual-item-form-row manual-item-form-row-3">
              <div className="manual-item-form-field">
                <label>CURRENT STOCK</label>
                <input
                  type="number"
                  min="0"
                  value={manualItemForm.currentStock}
                  readOnly
                  disabled
                />
              </div>
              <div className="manual-item-form-field">
                <label>ORDER QTY</label>
                <input
                  type="number"
                  min="1"
                  value={manualItemForm.orderQty}
                  onChange={(e) => handleManualItemFormChange('orderQty', e.target.value)}
                />
              </div>
              <div className="manual-item-form-field">
                <label>UNIT COST (₱)</label>
                <input
                  type="number"
                  min="0"
                  step="0.01"
                  value={manualItemForm.unitCost}
                  onChange={(e) => handleManualItemFormChange('unitCost', e.target.value)}
                />
              </div>
            </div>
          </div>

          {addItemError && (
            <div className="manual-item-error" role="alert">{addItemError}</div>
          )}

          <div className="manual-item-actions">
            <button
              type="button"
              className="manual-item-btn-cancel"
              onClick={() => setShowManualItemModal(false)}
              disabled={addingItem}
            >
              CANCEL
            </button>
            <button
              type="button"
              className="manual-item-btn-confirm"
              onClick={handleConfirmAndAdd}
              disabled={addingItem}
            >
              {addingItem ? 'Adding…' : 'CONFIRM & ADD'}
            </button>
          </div>
        </div>
      </Modal>
    </AdminLayout>
  );
};

export default DraftPOCreator;
