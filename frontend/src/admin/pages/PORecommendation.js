import React, { useState, useEffect, useCallback, useMemo, useRef } from 'react';
import AdminLayout from '../components/AdminLayout';
import Modal from '../components/Modal';
import {
  branchesAPI,
  itemsAPI,
  batchAPI,
  inventoryAPI,
  suppliersAPI,
  purchaseOrdersAPI,
} from '../services/api';
import '../styles/dashboard_air.css';
import '../styles/po_recommendation.css';

/* ─────────────────────────────────────────────────────────────────────────────
   Priority helper
───────────────────────────────────────────────────────────────────────────── */
function getPriority(item) {
  const qoh = item.quantity_on_hand ?? 0;
  const threshold =
    (item.reorder_level ?? 0) || (item.product?.recommended_stocks ?? 0);
  if (qoh === 0) return 'CRITICAL';
  if (threshold > 0) {
    if (qoh <= Math.max(1, Math.floor(threshold * 0.25))) return 'CRITICAL';
    if (qoh <= Math.max(1, Math.floor(threshold * 0.5))) return 'HIGH';
    return 'MEDIUM';
  }
  return 'MEDIUM';
}

const PRIORITY_CFG = {
  CRITICAL: { label: 'CRITICAL',      color: '#dc2626', bg: '#fef2f2', border: '#fecaca', barColor: '#dc2626' },
  HIGH:     { label: 'HIGH PRIORITY', color: '#d97706', bg: '#fffbeb', border: '#fde68a', barColor: '#d97706' },
  MEDIUM:   { label: 'MEDIUM',        color: '#2563eb', bg: '#eff6ff', border: '#bfdbfe', barColor: '#2563eb' },
};

const FILTER_TABS = ['ALL', 'CRITICAL', 'HIGH', 'MEDIUM', 'APPLIANCES', 'CONSUMABLES'];

/* ─────────────────────────────────────────────────────────────────────────────
   Main Component
───────────────────────────────────────────────────────────────────────────── */
const PORecommendation = () => {
  /* ── View ─────────────────────────────────────────────────────────────────── */
  const [view, setView] = useState('replenishment'); // 'replenishment' | 'creator'

  /* ── Smart Replenishment Engine ───────────────────────────────────────────── */
  const [inventory, setInventory]               = useState([]);
  const [loadingInventory, setLoadingInventory] = useState(true);
  const [filterTab, setFilterTab]               = useState('ALL');
  const [searchQuery, setSearchQuery]           = useState('');
  const [selectedItems, setSelectedItems]       = useState(new Set()); // Set<inventory_id>

  /* ── PO Creator ───────────────────────────────────────────────────────────── */
  const [poDate, setPoDate]                         = useState(() => new Date().toISOString().slice(0, 10));
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
  const [lineItems, setLineItems]                   = useState([]);
  const [submitting, setSubmitting]                 = useState(false);
  const [submitError, setSubmitError]               = useState('');
  const [submitSuccess, setSubmitSuccess]           = useState(false);

  /* ── Manual Item Modal ────────────────────────────────────────────────────── */
  const [showManualItemModal, setShowManualItemModal] = useState(false);
  const [manualItemType, setManualItemType]           = useState('unit');
  const [manualItemForm, setManualItemForm]           = useState({
    targetBranch: '',
    category: '',
    brand: '',
    model: '',
    variant: '',
    measurement: '',
    currentStock: 0,
    orderQty: 1,
    unitCost: 0,
  });
  const [addItemError, setAddItemError] = useState('');
  const [addingItem, setAddingItem]     = useState(false);

  /* Stable reference number for this session */
  const referenceNo = useRef((() => {
    const d   = new Date();
    const ymd = `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}${String(d.getDate()).padStart(2, '0')}`;
    const seq = String(Math.floor(Math.random() * 999) + 1).padStart(3, '0');
    return `PO-${ymd}-${seq}`;
  })()).current;

  /* ── Fetch Inventory ─────────────────────────────────────────────────────── */
  useEffect(() => {
    let mounted = true;
    setLoadingInventory(true);
    inventoryAPI
      .getAll({ per_page: 1000 })
      .then((res) => {
        if (!mounted) return;
        setInventory(Array.isArray(res?.data) ? res.data : []);
      })
      .catch((err) => console.error('Inventory fetch failed:', err))
      .finally(() => { if (mounted) setLoadingInventory(false); });
    return () => { mounted = false; };
  }, []);

  /* ── Fetch Branches ──────────────────────────────────────────────────────── */
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

  /* ── Fetch Categories, Brands, Suppliers ─────────────────────────────────── */
  useEffect(() => {
    let mounted = true;
    Promise.allSettled([
      batchAPI.get({ include: ['categories', 'brands'] }),
      suppliersAPI.getAll({ per_page: 200 }),
    ]).then(([batchResult, suppResult]) => {
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
      setLoadingBatch(false);
      setLoadingSuppliers(false);
    });
    return () => { mounted = false; };
  }, []);

  /* ── Derived: Low-Stock Items ────────────────────────────────────────────── */
  const lowStockItems = useMemo(() => {
    return inventory.filter((item) => {
      const qoh       = item.quantity_on_hand ?? 0;
      const threshold = (item.reorder_level ?? 0) || (item.product?.recommended_stocks ?? 0);
      return threshold > 0 && qoh <= threshold;
    });
  }, [inventory]);

  /* ── Counts per tab ──────────────────────────────────────────────────────── */
  const counts = useMemo(() => ({
    ALL:         lowStockItems.length,
    CRITICAL:    lowStockItems.filter((i) => getPriority(i) === 'CRITICAL').length,
    HIGH:        lowStockItems.filter((i) => getPriority(i) === 'HIGH').length,
    MEDIUM:      lowStockItems.filter((i) => getPriority(i) === 'MEDIUM').length,
    APPLIANCES:  lowStockItems.filter((i) => i.product?.product_type === 'appliance').length,
    CONSUMABLES: lowStockItems.filter((i) => i.product?.product_type === 'consumable').length,
  }), [lowStockItems]);

  /* ── Filtered display list ───────────────────────────────────────────────── */
  const filteredInventory = useMemo(() => {
    return lowStockItems.filter((item) => {
      const priority = getPriority(item);
      if (filterTab === 'CRITICAL'    && priority !== 'CRITICAL') return false;
      if (filterTab === 'HIGH'        && priority !== 'HIGH')     return false;
      if (filterTab === 'MEDIUM'      && priority !== 'MEDIUM')   return false;
      if (filterTab === 'APPLIANCES'  && item.product?.product_type !== 'appliance')  return false;
      if (filterTab === 'CONSUMABLES' && item.product?.product_type !== 'consumable') return false;
      if (searchQuery.trim()) {
        const q     = searchQuery.toLowerCase();
        const name  = (item.product?.product_name              || '').toLowerCase();
        const code  = (item.product?.product_code              || '').toLowerCase();
        const cat   = (item.product?.category?.category_name   || '').toLowerCase();
        const brand = (item.product?.brand?.brand_name         || '').toLowerCase();
        if (!name.includes(q) && !code.includes(q) && !cat.includes(q) && !brand.includes(q)) return false;
      }
      return true;
    });
  }, [lowStockItems, filterTab, searchQuery]);

  /* ── Selection helpers ───────────────────────────────────────────────────── */
  const allFilteredSelected =
    filteredInventory.length > 0 &&
    filteredInventory.every((i) => selectedItems.has(i.inventory_id));

  const toggleItem = useCallback((id) => {
    setSelectedItems((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  }, []);

  const handleSelectAll = useCallback(() => {
    if (allFilteredSelected) {
      setSelectedItems(new Set());
    } else {
      setSelectedItems(new Set(filteredInventory.map((i) => i.inventory_id)));
    }
  }, [allFilteredSelected, filteredInventory]);

  /* ── Generate Draft PO ───────────────────────────────────────────────────── */
  const handleGenerateDraftPO = useCallback(() => {
    const selected = inventory.filter((i) => selectedItems.has(i.inventory_id));
    const items = selected.map((item) => {
      const product    = item.product;
      const qoh        = item.quantity_on_hand ?? 0;
      const threshold  = (item.reorder_level ?? 0) || (product?.recommended_stocks ?? 0);
      const suggested  = Math.max(1, threshold - qoh);
      const unitCost   = parseFloat(product?.cost_price) || parseFloat(product?.unit_price) || 0;
      return {
        id:        `inv-${item.inventory_id}`,
        productId: product?.product_id ?? null,
        product:   product?.product_name || 'Unknown Product',
        brand:     product?.brand?.brand_name || '—',
        category:  product?.category?.category_name || '—',
        type:      product?.product_type === 'appliance' ? 'APPLIANCES' : 'PART',
        qty:       suggested,
        unitCost,
        total:     suggested * unitCost,
        location:  item.location?.location_name || '—',
      };
    });
    setLineItems(items);
    setSubmitSuccess(false);
    setSubmitError('');
    setView('creator');
    window.scrollTo(0, 0);
  }, [inventory, selectedItems]);

  /* ── Line Item Operations ────────────────────────────────────────────────── */
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

  /* ── Computed Totals ─────────────────────────────────────────────────────── */
  const itemsSubtotal = useMemo(
    () => lineItems.reduce((s, i) => s + i.total, 0),
    [lineItems]
  );
  const appliedVat         = Math.round(itemsSubtotal * 0.12);
  const totalEstimatedValue = itemsSubtotal + appliedVat;

  /* ── Manual Item Modal ───────────────────────────────────────────────────── */
  const openManualItemModal = useCallback(() => {
    setAddItemError('');
    setManualItemType('unit');
    setManualItemForm({
      targetBranch: selectedBranch || (branches[0] ? String(branches[0].id) : ''),
      category: '',
      brand: '',
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

  const handleConfirmAndAdd = useCallback(async () => {
    setAddItemError('');
    const { category, brand, model, variant, measurement, currentStock, orderQty, unitCost } =
      manualItemForm;
    const name = (manualItemType === 'unit' ? model || brand : variant)?.trim() || 'Custom Item';
    if (!category?.trim()) { setAddItemError('Category is required.'); return; }
    const unitPrice = parseFloat(unitCost) || 0;
    if (unitPrice < 0) { setAddItemError('Unit cost must be 0 or greater.'); return; }

    setAddingItem(true);
    try {
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
  }, [manualItemForm, manualItemType]);

  /* ── Final Submission ────────────────────────────────────────────────────── */
  const handleFinalSubmission = useCallback(async () => {
    setSubmitError('');
    if (lineItems.length === 0) { setSubmitError('Add at least one item to the purchase order.'); return; }
    if (!selectedSupplierId)    { setSubmitError('Please select a supplier.'); return; }
    if (!poDate)                { setSubmitError('Please select a PO date.'); return; }
    setSubmitting(true);
    try {
      await purchaseOrdersAPI.create({
        reference_no:  referenceNo,
        supplier_id:   parseInt(selectedSupplierId, 10),
        payment_terms: paymentTerms,
        po_date:       poDate,
        branch_id:     selectedBranch ? parseInt(selectedBranch, 10) : null,
        status:        'Pending',
        items: lineItems.map((i) => ({
          product_id: i.productId,
          quantity:   i.qty,
          unit_cost:  i.unitCost,
          total:      i.total,
        })),
        subtotal:     itemsSubtotal,
        vat_amount:   appliedVat,
        total_amount: totalEstimatedValue,
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
    referenceNo, itemsSubtotal, appliedVat, totalEstimatedValue,
  ]);

  /* ── Derived ─────────────────────────────────────────────────────────────── */
  const selectedBranchRecord = branches.find((b) => String(b.id) === selectedBranch);

  /* ════════════════════════════════════════════════════════════════════════════
     RENDER
  ════════════════════════════════════════════════════════════════════════════ */
  return (
    <AdminLayout>
      {/* ══════════════════════════════════════════════════════════════════════
          VIEW: SMART REPLENISHMENT ENGINE
      ══════════════════════════════════════════════════════════════════════ */}
      {view === 'replenishment' && (
        <div className="sre-page">

          {/* ── Banner ──────────────────────────────────────────────────── */}
          <div className="sre-banner">
            <div className="sre-banner-left">
              <div className="sre-banner-icon-wrap">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" width="26" height="26">
                  <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon>
                </svg>
              </div>
              <div>
                <div className="sre-banner-title-row">
                  <h1 className="sre-banner-title">Smart Replenishment Engine</h1>
                  <span className="sre-banner-chip">AUTOMATED SYSTEM</span>
                </div>
                <p className="sre-banner-subtitle">
                  AI-assisted analysis of stock levels across all branches.&nbsp;
                  {counts.CRITICAL > 0 && (
                    <span className="sre-stat-chip sre-stat-critical">{counts.CRITICAL} CRITICAL</span>
                  )}
                  {counts.HIGH > 0 && (
                    <span className="sre-stat-chip sre-stat-high">{counts.HIGH} HIGH</span>
                  )}
                  {counts.MEDIUM > 0 && (
                    <span className="sre-stat-chip sre-stat-medium">{counts.MEDIUM} MEDIUM</span>
                  )}
                  &nbsp;priority items detected
                </p>
              </div>
            </div>
            <button
              className={`sre-generate-btn${selectedItems.size === 0 ? ' sre-generate-btn--disabled' : ''}`}
              onClick={handleGenerateDraftPO}
              disabled={selectedItems.size === 0}
            >
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="18" height="18">
                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                <polyline points="14 2 14 8 20 8"></polyline>
                <line x1="16" y1="13" x2="8" y2="13"></line>
                <line x1="16" y1="17" x2="8" y2="17"></line>
              </svg>
              GENERATE DRAFT PO
              {selectedItems.size > 0 && (
                <span className="sre-generate-count">{selectedItems.size}</span>
              )}
            </button>
          </div>

          {/* ── Controls ────────────────────────────────────────────────── */}
          <div className="sre-controls-bar">
            <div className="sre-filter-tabs">
              {FILTER_TABS.map((tab) => (
                <button
                  key={tab}
                  className={`sre-filter-tab${filterTab === tab ? ' active' : ''}`}
                  onClick={() => setFilterTab(tab)}
                >
                  {tab === 'ALL'         ? `All (${counts.ALL})`         :
                   tab === 'CRITICAL'    ? `Critical (${counts.CRITICAL})` :
                   tab === 'HIGH'        ? `High (${counts.HIGH})`       :
                   tab === 'MEDIUM'      ? `Medium (${counts.MEDIUM})`   :
                   tab === 'APPLIANCES'  ? `Appliances (${counts.APPLIANCES})` :
                   `Consumables (${counts.CONSUMABLES})`}
                </button>
              ))}
            </div>
            <div className="sre-search-wrap">
              <svg className="sre-search-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="15" height="15">
                <circle cx="11" cy="11" r="8"></circle>
                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
              </svg>
              <input
                className="sre-search-input"
                type="text"
                placeholder="Search products, brands, categories…"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
              />
              {searchQuery && (
                <button className="sre-search-clear" onClick={() => setSearchQuery('')}>✕</button>
              )}
            </div>
          </div>

          {/* ── Select-all bar ───────────────────────────────────────────── */}
          {!loadingInventory && filteredInventory.length > 0 && (
            <div className="sre-selectall-bar">
              <label className="sre-selectall-label">
                <input
                  type="checkbox"
                  checked={allFilteredSelected}
                  onChange={handleSelectAll}
                  className="sre-checkbox"
                />
                <span>Select all {filteredInventory.length} visible items</span>
              </label>
              {selectedItems.size > 0 && (
                <span className="sre-selected-count">
                  {selectedItems.size} item{selectedItems.size > 1 ? 's' : ''} selected
                </span>
              )}
            </div>
          )}

          {/* ── Cards Grid ───────────────────────────────────────────────── */}
          {loadingInventory ? (
            <div className="sre-state-box">
              <div className="sre-spinner"></div>
              <p>Loading inventory data…</p>
            </div>
          ) : filteredInventory.length === 0 ? (
            <div className="sre-state-box sre-state-empty">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" width="48" height="48">
                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                <polyline points="22 4 12 14.01 9 11.01"></polyline>
              </svg>
              <p>No low-stock items found</p>
              <span>All products are above their reorder thresholds</span>
            </div>
          ) : (
            <div className="sre-cards-grid">
              {filteredInventory.map((item) => {
                const priority   = getPriority(item);
                const cfg        = PRIORITY_CFG[priority];
                const qoh        = item.quantity_on_hand ?? 0;
                const threshold  = (item.reorder_level ?? 0) || (item.product?.recommended_stocks ?? 0);
                const suggested  = Math.max(0, threshold - qoh);
                const pct        = threshold > 0 ? Math.min(100, Math.round((qoh / threshold) * 100)) : 0;
                const isSelected = selectedItems.has(item.inventory_id);
                const prodType   = item.product?.product_type === 'appliance' ? 'APPLIANCE' : 'CONSUMABLE';

                return (
                  <div
                    key={item.inventory_id}
                    className={`sre-card${isSelected ? ' sre-card--selected' : ''}`}
                    onClick={() => toggleItem(item.inventory_id)}
                    style={{ '--priority-color': cfg.color, '--priority-bg': cfg.bg }}
                  >
                    {/* Card Top Row */}
                    <div className="sre-card-top">
                      <span
                        className="sre-priority-badge"
                        style={{ color: cfg.color, background: cfg.bg, borderColor: cfg.border }}
                      >
                        <span className="sre-priority-dot" style={{ background: cfg.color }}></span>
                        {cfg.label}
                      </span>
                      <div className="sre-card-top-right">
                        <span className={`sre-type-chip sre-type-chip--${item.product?.product_type || 'appliance'}`}>
                          {prodType}
                        </span>
                        <div
                          className={`sre-card-checkbox${isSelected ? ' checked' : ''}`}
                          onClick={(e) => { e.stopPropagation(); toggleItem(item.inventory_id); }}
                        >
                          {isSelected && (
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" width="11" height="11">
                              <polyline points="20 6 9 17 4 12"></polyline>
                            </svg>
                          )}
                        </div>
                      </div>
                    </div>

                    {/* Product Info */}
                    <div className="sre-card-body">
                      <h3 className="sre-card-name">
                        {item.product?.product_name || 'Unknown Product'}
                      </h3>
                      <p className="sre-card-meta">
                        {item.product?.category?.category_name && (
                          <span className="sre-card-category">{item.product.category.category_name}</span>
                        )}
                        {item.product?.brand?.brand_name && (
                          <span className="sre-card-brand">{item.product.brand.brand_name}</span>
                        )}
                      </p>
                      {item.location?.location_name && (
                        <p className="sre-card-location">
                          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="11" height="11">
                            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                            <circle cx="12" cy="10" r="3"></circle>
                          </svg>
                          {item.location.location_name}
                        </p>
                      )}
                    </div>

                    {/* Stock Level */}
                    <div className="sre-card-stock">
                      <div className="sre-stock-header">
                        <span className="sre-stock-label">STOCK LEVEL</span>
                        <span className="sre-stock-pct" style={{ color: cfg.color }}>{pct}%</span>
                      </div>
                      <div className="sre-stock-bar">
                        <div
                          className="sre-stock-fill"
                          style={{ width: `${pct}%`, background: cfg.barColor }}
                        ></div>
                      </div>
                      <div className="sre-stock-numbers">
                        <span>Current: <strong>{qoh}</strong></span>
                        <span>Target: <strong>{threshold}</strong></span>
                        <span className="sre-shortfall" style={{ color: cfg.color }}>
                          -{Math.max(0, threshold - qoh)} short
                        </span>
                      </div>
                    </div>

                    {/* Suggested Order */}
                    <div className="sre-card-suggest">
                      <span className="sre-suggest-label">SUGGESTED ORDER</span>
                      <div className="sre-suggest-qty" style={{ color: cfg.color }}>
                        {suggested}
                        <span className="sre-suggest-unit">units</span>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          )}

          {/* ── Floating Action Bar ───────────────────────────────────────── */}
          {selectedItems.size > 0 && (
            <div className="sre-action-bar">
              <div className="sre-action-bar-info">
                <div className="sre-action-bar-count">{selectedItems.size}</div>
                <span>item{selectedItems.size > 1 ? 's' : ''} selected for procurement</span>
              </div>
              <div className="sre-action-bar-btns">
                <button
                  className="sre-action-bar-clear"
                  onClick={() => setSelectedItems(new Set())}
                >
                  Clear selection
                </button>
                <button
                  className="sre-action-bar-generate"
                  onClick={handleGenerateDraftPO}
                >
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="16" height="16">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                    <polyline points="14 2 14 8 20 8"></polyline>
                  </svg>
                  GENERATE DRAFT PO ({selectedItems.size} items)
                </button>
              </div>
            </div>
          )}
        </div>
      )}

      {/* ══════════════════════════════════════════════════════════════════════
          VIEW: PURCHASE ORDER CREATOR
      ══════════════════════════════════════════════════════════════════════ */}
      {view === 'creator' && (
        <div className="po-recommendation-page">

          {/* ── Success Banner ─────────────────────────────────────────── */}
          {submitSuccess && (
            <div className="po-success-banner">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="18" height="18">
                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                <polyline points="22 4 12 14.01 9 11.01"></polyline>
              </svg>
              Purchase Order <strong>{referenceNo}</strong> submitted successfully!
              <button
                className="po-success-close"
                onClick={() => { setSubmitSuccess(false); setView('replenishment'); setSelectedItems(new Set()); }}
              >
                ✕
              </button>
            </div>
          )}

          {/* ── Page Header ────────────────────────────────────────────── */}
          <div className="po-page-header">
            <div className="po-page-header-left">
              <button className="po-back-btn" onClick={() => setView('replenishment')}>
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" width="18" height="18">
                  <line x1="19" y1="12" x2="5" y2="12"></line>
                  <polyline points="12 19 5 12 12 5"></polyline>
                </svg>
                Back
              </button>
              <div className="po-page-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                  <polyline points="14 2 14 8 20 8"></polyline>
                  <line x1="16" y1="13" x2="8" y2="13"></line>
                  <line x1="16" y1="17" x2="8" y2="17"></line>
                </svg>
              </div>
              <div>
                <h1 className="po-page-title">PURCHASE ORDER CREATOR</h1>
                <p className="po-page-status">
                  Status: <span className="status-pending">PENDING REVIEW</span> &bull; {lineItems.length} item{lineItems.length !== 1 ? 's' : ''} in this draft
                </p>
              </div>
            </div>
            <div className="po-page-header-right">
              <span className="po-draft-badge">INTERNAL DRAFT</span>
              <div className="po-header-actions">
                <button className="po-btn po-btn-export-excel">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="15" height="15">
                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                    <polyline points="7 10 12 15 17 10"></polyline>
                    <line x1="12" y1="15" x2="12" y2="3"></line>
                  </svg>
                  EXPORT EXCEL
                </button>
                <button className="po-btn po-btn-export-doc">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="15" height="15">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                    <polyline points="14 2 14 8 20 8"></polyline>
                  </svg>
                  EXPORT DOCUMENT
                </button>
              </div>
            </div>
          </div>

          {/* ── Action Row ─────────────────────────────────────────────── */}
          <div className="po-action-row">
            <button
              className="po-btn po-btn-final-submission"
              onClick={handleFinalSubmission}
              disabled={submitting}
            >
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="16" height="16">
                <path d="M22 2L11 13"></path>
                <path d="M22 2l-7 20-4-9-9-4 20-7z"></path>
              </svg>
              {submitting ? 'SUBMITTING…' : 'FINAL SUBMISSION'}
            </button>
          </div>

          {submitError && (
            <div className="po-submit-error">{submitError}</div>
          )}

          <div className="po-content-layout">
            {/* ── Main Content ─────────────────────────────────────────── */}
            <div className="po-main-content">

              {/* PO Details */}
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
                </div>
              </div>

              {/* Delivery Destination */}
              <div className="po-destination-card">
                <div className="po-destination-header">
                  <div className="po-destination-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="18" height="18">
                      <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                      <circle cx="12" cy="10" r="3"></circle>
                    </svg>
                  </div>
                  <span className="po-destination-title">DELIVERY DESTINATION</span>
                </div>
                <div className="po-destination-grid">
                  <div className="po-field">
                    <label className="po-field-label">BRANCH (FOR SORTING)</label>
                    <select
                      className="po-select"
                      value={selectedBranch}
                      onChange={(e) => setSelectedBranch(e.target.value)}
                      disabled={loadingBranches}
                    >
                      {loadingBranches && <option value="">Loading branches…</option>}
                      {!loadingBranches && branches.length === 0 && <option value="">No active branches</option>}
                      {branches.map((b) => (
                        <option key={b.id} value={String(b.id)}>
                          {b.location_name || b.name}
                        </option>
                      ))}
                    </select>
                  </div>
                  <div className="po-field po-field-address">
                    <label className="po-field-label">WAREHOUSE DELIVERY ADDRESS</label>
                    <div className="po-address-display">
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="14" height="14">
                        <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                        <circle cx="12" cy="10" r="3"></circle>
                      </svg>
                      <span>{selectedBranchRecord?.address ?? '—'}</span>
                    </div>
                  </div>
                </div>
                <div className="po-destination-note">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="14" height="14">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="12" y1="16" x2="12" y2="12"></line>
                    <line x1="12" y1="8" x2="12.01" y2="8"></line>
                  </svg>
                  All purchase orders are delivered to the Bulua warehouse address regardless of branch selection. Branch is used for inventory sorting only.
                </div>
              </div>

              {/* Line Items */}
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
                  <button className="po-btn po-btn-add-product" onClick={openManualItemModal}>
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
                    <span>Go back to select items from the replenishment list, or add custom products manually.</span>
                  </div>
                ) : (
                  <div className="po-table-wrapper">
                    <table className="po-table">
                      <thead>
                        <tr>
                          <th>PRODUCT / MODEL / BRAND</th>
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
                                <div className="po-product-tags">
                                  {item.brand && item.brand !== '—' && (
                                    <span className="po-tag po-tag-supplier">{item.brand}</span>
                                  )}
                                  {item.location && item.location !== '—' && (
                                    <span className="po-tag po-tag-info">{item.location}</span>
                                  )}
                                </div>
                              </div>
                            </td>
                            <td>{item.category}</td>
                            <td>
                              <span className={`po-type-badge ${item.type === 'PART' ? 'po-type-part' : 'po-type-appliance'}`}>
                                {item.type}
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

            {/* ── Commercial Summary Sidebar ────────────────────────────── */}
            <div className="po-summary-sidebar">
              <div className="po-summary-card">
                <h3 className="po-summary-title">COMMERCIAL SUMMARY</h3>
                <div className="po-summary-row">
                  <span>ITEMS SUBTOTAL</span>
                  <span className="po-summary-value">₱{itemsSubtotal.toLocaleString()}</span>
                </div>
                <div className="po-summary-row">
                  <span>APPLIED VAT (12%)</span>
                  <span className="po-summary-value po-summary-vat">₱{appliedVat.toLocaleString()}</span>
                </div>
                <div className="po-summary-row">
                  <span>LOGISTICS</span>
                  <span className="po-summary-calculated">CALCULATED ON EST. APPROVAL</span>
                </div>
                <div className="po-summary-total">
                  <span>TOTAL ESTIMATED VALUE</span>
                  <span className="po-summary-total-value">₱{totalEstimatedValue.toLocaleString()}</span>
                </div>
              </div>

              <div className="po-summary-items-card">
                <h4 className="po-summary-items-title">ITEMS BREAKDOWN</h4>
                <div className="po-summary-type-row">
                  <span>Appliances</span>
                  <strong>{lineItems.filter((i) => i.type === 'APPLIANCES').length}</strong>
                </div>
                <div className="po-summary-type-row">
                  <span>Parts / Consumables</span>
                  <strong>{lineItems.filter((i) => i.type === 'PART').length}</strong>
                </div>
                <div className="po-summary-type-row po-summary-type-total">
                  <span>Total Items</span>
                  <strong>{lineItems.length}</strong>
                </div>
              </div>

              <div className="po-export-reminder">
                <h4>EXPORT REMINDER</h4>
                <p>
                  Use the Excel or Document export buttons to generate formal files for offline archiving or physical signing.
                </p>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* ══════════════════════════════════════════════════════════════════════
          MANUAL ITEM ENTRY MODAL
      ══════════════════════════════════════════════════════════════════════ */}
      <Modal
        isOpen={showManualItemModal}
        onClose={() => setShowManualItemModal(false)}
        title=""
      >
        <div className="manual-item-modal">
          {/* Modal Header */}
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
          </div>

          {/* Type Toggle */}
          <div className="manual-item-type-toggle">
            <button
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

          {/* Form */}
          <div className="manual-item-form">
            {/* Row 1: Branch + Category */}
            <div className="manual-item-form-row">
              <div className="manual-item-form-field">
                <label>TARGET BRANCH</label>
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

            {/* Row 2: Type-specific fields */}
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
                  <input
                    type="text"
                    value={manualItemForm.model}
                    onChange={(e) => handleManualItemFormChange('model', e.target.value)}
                    placeholder="Enter model or product name"
                  />
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

            {/* Row 3: Stock fields */}
            <div className="manual-item-form-row manual-item-form-row-3">
              <div className="manual-item-form-field">
                <label>CURRENT STOCK</label>
                <input
                  type="number"
                  min="0"
                  value={manualItemForm.currentStock}
                  onChange={(e) => handleManualItemFormChange('currentStock', e.target.value)}
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
              className="manual-item-btn-cancel"
              onClick={() => setShowManualItemModal(false)}
              disabled={addingItem}
            >
              CANCEL
            </button>
            <button
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

export default PORecommendation;
