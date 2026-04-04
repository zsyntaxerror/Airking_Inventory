import React, { useEffect, useMemo, useState, useCallback } from 'react';
import { useLocation } from 'react-router-dom';
import AdminLayout from '../components/AdminLayout';
import Modal from '../components/Modal';
import { useAuth } from '../context/AuthContext';
import { canActOnApprovalQueue, canApprovePendingRegistrations } from '../utils/roles';
import {
  getApprovalQueuePurchaseOrders,
  getApprovalQueueRestockRequests,
  updateApprovalQueuePurchaseOrderStatus,
  updateApprovalQueueRestockRequestStatus,
  mergeApprovalQueuePurchaseOrder,
} from '../utils/approvalNotifications';
import { purchaseOrdersAPI, statusAPI, productsAPI, pendingProductsAPI, consumableSupplyAPI } from '../services/api';
import { toast } from '../utils/toast';
import '../styles/approval_queue.css';

const AQ_TABS = ['item-registration', 'restock-requests', 'purchase-orders', 'branch-transfers'];

const formatYmd = (value) => {
  if (!value) return '—';
  const d = new Date(value);
  if (Number.isNaN(d.getTime())) return String(value);
  return d.toLocaleDateString('en-PH', { year: 'numeric', month: 'short', day: 'numeric' });
};

const daysUntil = (value) => {
  if (!value) return null;
  const exp = new Date(value);
  if (Number.isNaN(exp.getTime())) return null;
  const today = new Date();
  exp.setHours(0, 0, 0, 0);
  today.setHours(0, 0, 0, 0);
  return Math.ceil((exp.getTime() - today.getTime()) / 86400000);
};

const formatDateTime = (value) => {
  if (!value) return '—';
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return String(value);
  return date.toLocaleString('en-PH', {
    year: 'numeric',
    month: 'short',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
  });
};

const ApprovalQueue = ({ initialTab } = {}) => {
  const { user } = useAuth();
  const canActOnQueue = useMemo(() => canActOnApprovalQueue(user), [user]);
  const canApproveRegistrations = useMemo(() => canApprovePendingRegistrations(user), [user]);
  const location = useLocation();
  const [activeTab, setActiveTab] = useState(() => {
    if (typeof window === 'undefined') return 'restock-requests';
    const q = new URLSearchParams(window.location.search).get('tab');
    if (q && AQ_TABS.includes(q)) return q;
    if (initialTab && AQ_TABS.includes(initialTab)) return initialTab;
    return 'restock-requests';
  });

  useEffect(() => {
    const q = new URLSearchParams(location.search).get('tab');
    if (q && AQ_TABS.includes(q)) {
      setActiveTab(q);
      return;
    }
    if (location.pathname === '/admin/purchase-orders' && initialTab && AQ_TABS.includes(initialTab)) {
      setActiveTab(initialTab);
    }
  }, [location.search, location.pathname, initialTab]);

  // Sample data — replace with API calls later
  const [purchaseOrders, setPurchaseOrders] = useState([
    {
      id: 1,
      po_number: 'PO-2025-5678',
      supplier: 'Samsung Philippines',
      amount: 329990,
      prepared_by: 'Sarah Johnson',
      date: '2025-11-28 09:00',
      status: 'authorized',
      expected_delivery_date: '2025-12-10',
      approved_at: '2025-11-28T09:05:00.000Z',
    },
    {
      id: 2,
      po_number: 'PO-2025-5679',
      supplier: 'LG Electronics',
      amount: 434985,
      prepared_by: 'Sarah Johnson',
      date: '2025-11-29 11:30',
      status: 'pending',
      expected_delivery_date: '2025-12-15',
    },
  ]);

  useEffect(() => {
    const hydrateFromStorage = () => {
      const stored = getApprovalQueuePurchaseOrders();
      const storedRestock = getApprovalQueueRestockRequests();
      if (stored.length) {
        setPurchaseOrders((prev) => {
          const existing = new Set(prev.map((po) => String(po.id)));
          const merged = [...stored.filter((po) => !existing.has(String(po.id))), ...prev];
          return merged;
        });
      }
      if (storedRestock.length) {
        setRestockRequests((prev) => {
          const existing = new Set(prev.map((req) => String(req.id)));
          const merged = [...storedRestock.filter((req) => !existing.has(String(req.id))), ...prev];
          return merged;
        });
      }
    };

    hydrateFromStorage();
    window.addEventListener('approval-notifications-updated', hydrateFromStorage);
    return () => window.removeEventListener('approval-notifications-updated', hydrateFromStorage);
  }, []);

  const [restockRequests, setRestockRequests] = useState([
    {
      id: 1,
      item_name: 'Airking Inverter Aircon 2HP',
      destination: 'Quezon City Branch',
      quantity: 10,
      from: 'Main Warehouse',
      requested_date: '2025-11-30 10:00',
      status: 'pending',
    },
    {
      id: 2,
      item_name: 'Samsung Top Load Washing Machine 8KG',
      destination: 'Makati Branch',
      quantity: 5,
      from: 'Main Warehouse',
      requested_date: '2025-11-29 14:30',
      status: 'inactive',
    },
  ]);

  const [branchTransfers] = useState([]);

  const [pendingRegistrations, setPendingRegistrations] = useState([]);
  const [pendingRegLoading, setPendingRegLoading] = useState(false);
  const [packLabels, setPackLabels] = useState({});
  const [irApproveOpen, setIrApproveOpen] = useState(false);
  const [irSelected, setIrSelected] = useState(null);
  const [irApproveForm, setIrApproveForm] = useState({
    final_product_name: '',
  });
  const [irSubmitting, setIrSubmitting] = useState(false);

  const [poActionLoading, setPoActionLoading] = useState(null);
  const [poVerifyModal, setPoVerifyModal] = useState(null);
  const [poVerifyLines, setPoVerifyLines] = useState([]);
  const [poVerifyLoading, setPoVerifyLoading] = useState(false);
  const [poVerifyError, setPoVerifyError] = useState('');

  useEffect(() => {
    if (!poVerifyModal) {
      setPoVerifyLines([]);
      setPoVerifyError('');
      setPoVerifyLoading(false);
      return;
    }

    const po = poVerifyModal;
    const fromSnapshot = Array.isArray(po.line_items_snapshot) ? po.line_items_snapshot : [];
    if (fromSnapshot.length) {
      setPoVerifyLines(
        fromSnapshot.map((row, i) => ({
          key: `snap-${i}`,
          name: row.product || `Product #${row.product_id ?? '—'}`,
          product_id: row.product_id,
          qty: row.qty,
          unit: row.unit_cost,
          lineTotal: row.total,
          type: row.type,
          brand: row.brand,
          category: row.category,
        })),
      );
      setPoVerifyLoading(false);
      return;
    }

    const payloadDetails = po.api_create_payload?.details;
    if (Array.isArray(payloadDetails) && payloadDetails.length) {
      setPoVerifyLoading(true);
      setPoVerifyError('');
      (async () => {
        try {
          const rows = await Promise.all(
            payloadDetails.map(async (d, i) => {
              const pid = d.product_id;
              let name = `Product #${pid}`;
              try {
                const res = await productsAPI.getById(pid);
                const p = res?.data;
                name = p?.product_name || p?.name || name;
              } catch {
                /* keep fallback label */
              }
              return {
                key: `pay-${i}`,
                name,
                product_id: pid,
                qty: d.quantity_ordered,
                unit: d.unit_price,
                lineTotal: d.subtotal,
              };
            }),
          );
          setPoVerifyLines(rows);
        } catch {
          setPoVerifyError('Could not load product names for this PO.');
          setPoVerifyLines(
            payloadDetails.map((d, i) => ({
              key: `pay-${i}`,
              name: `Product #${d.product_id}`,
              product_id: d.product_id,
              qty: d.quantity_ordered,
              unit: d.unit_price,
              lineTotal: d.subtotal,
            })),
          );
        } finally {
          setPoVerifyLoading(false);
        }
      })();
      return;
    }

    const backendId = po.backend_po_id;
    if (backendId != null && backendId !== '') {
      setPoVerifyLoading(true);
      setPoVerifyError('');
      (async () => {
        try {
          const res = await purchaseOrdersAPI.getById(String(backendId));
          const data = res?.data;
          const details = Array.isArray(data?.details) ? data.details : [];
          setPoVerifyLines(
            details.map((d, i) => {
              const p = d.product || {};
              return {
                key: `api-${d.detail_id ?? i}`,
                name: p.product_name || p.name || `Product #${d.product_id}`,
                product_id: d.product_id,
                qty: d.quantity_ordered,
                unit: d.unit_price,
                lineTotal: d.subtotal,
              };
            }),
          );
        } catch (err) {
          setPoVerifyError(err?.message || 'Could not load PO lines from the server.');
          setPoVerifyLines([]);
        } finally {
          setPoVerifyLoading(false);
        }
      })();
      return;
    }

    setPoVerifyLines([]);
    setPoVerifyError('No line items are stored for this PO. Older sample/local entries may not include a product list.');
    setPoVerifyLoading(false);
  }, [poVerifyModal]);

  useEffect(() => {
    consumableSupplyAPI.getCatalog().then((res) => {
      const units = res?.data?.packaging_units;
      const map = {};
      if (Array.isArray(units)) {
        units.forEach((u) => {
          if (u?.key) map[u.key] = u.label || u.key;
        });
      }
      setPackLabels(map);
    }).catch(() => setPackLabels({}));
  }, []);

  const fetchPendingRegistrations = useCallback(async () => {
    setPendingRegLoading(true);
    try {
      const res = await pendingProductsAPI.getAll({ per_page: 100 });
      const raw = res?.data;
      const list = Array.isArray(raw) ? raw : raw && Array.isArray(raw.data) ? raw.data : [];
      setPendingRegistrations(list);
    } catch (e) {
      toast.error(e.message || 'Could not load pending item registrations.');
      setPendingRegistrations([]);
    } finally {
      setPendingRegLoading(false);
    }
  }, []);

  useEffect(() => {
    if (activeTab === 'item-registration') {
      fetchPendingRegistrations();
    }
  }, [activeTab, fetchPendingRegistrations]);

  const packLabel = (key) => packLabels[key] || key || '—';

  const openIrApprove = (row) => {
    setIrSelected(row);
    setIrApproveForm({
      final_product_name: row.generated_name || '',
    });
    setIrApproveOpen(true);
  };

  const handleIrApproveSubmit = async (e) => {
    e.preventDefault();
    if (!irSelected?.pending_product_id) return;
    const name = irApproveForm.final_product_name.trim();
    if (!name) {
      toast.error('Product name is required.');
      return;
    }
    setIrSubmitting(true);
    try {
      await pendingProductsAPI.approve(irSelected.pending_product_id, {
        final_product_name: name,
      });
      toast.success('Approved — item is in Item Master. Add unit price and cost there if needed.');
      setIrApproveOpen(false);
      setIrSelected(null);
      fetchPendingRegistrations();
    } catch (err) {
      toast.error(err.message || 'Approval failed.');
    } finally {
      setIrSubmitting(false);
    }
  };

  const handlePOAction = async (id, action) => {
    const nextStatus = action === 'approve' ? 'authorized' : 'rejected';
    if (action === 'reject') {
      setPurchaseOrders((prev) =>
        prev.map((po) => (po.id === id ? { ...po, status: nextStatus } : po)),
      );
      updateApprovalQueuePurchaseOrderStatus(id, nextStatus);
      return;
    }

    const po = purchaseOrders.find((p) => p.id === id);

    if (po?.synced_to_api && po?.backend_po_id && !po.api_create_payload) {
      setPoActionLoading(id);
      try {
        const stRes = await statusAPI.getAll({ category: 'purchase_order' });
        const stRows = Array.isArray(stRes?.data) ? stRes.data : [];
        const authorizedId = stRows.find((s) => {
          const n = String(s.status_name || '').toLowerCase();
          return n === 'authorized' || n.includes('authori');
        })?.status_id;
        if (!authorizedId) {
          toast.error('No Authorized status for purchase orders. Run backend migrations, then try again.');
          return;
        }
        await purchaseOrdersAPI.update(String(po.backend_po_id), { status_id: authorizedId });
        const patch = {
          status: 'authorized',
          approved_at: new Date().toISOString(),
        };
        mergeApprovalQueuePurchaseOrder(id, patch);
        setPurchaseOrders((prev) =>
          prev.map((p) => (p.id === id ? { ...p, ...patch } : p)),
        );
        toast.success('PO authorized on the server. It stays in Receive PO; receiving follows expected date rules.');
      } catch (err) {
        if (err?.status === 403) {
          toast.error('This account cannot update purchase orders on the server.');
          return;
        }
        const msg = err?.errors
          ? Object.values(err.errors).flat().join(' ')
          : err?.message || 'Could not authorize this PO on the server.';
        toast.error(msg);
        return;
      } finally {
        setPoActionLoading(null);
      }
      return;
    }

    if (po?.api_create_payload && !po.synced_to_api) {
      setPoActionLoading(id);
      try {
        const res = await purchaseOrdersAPI.create(po.api_create_payload);
        const data = res?.data ?? res;
        const backendId = data?.po_id ?? data?.id;
        if (backendId == null || backendId === '') {
          toast.error('Server saved the PO but did not return an ID. Check the network response.');
          return;
        }
        const patch = {
          status: 'authorized',
          synced_to_api: true,
          backend_po_id: backendId,
          approved_at: new Date().toISOString(),
          api_create_payload: null,
        };
        mergeApprovalQueuePurchaseOrder(id, patch);
        setPurchaseOrders((prev) =>
          prev.map((p) => (p.id === id ? { ...p, ...patch } : p)),
        );
        toast.success('PO saved to the server. It appears in Receive PO now (merged with your purchase order list).');
      } catch (err) {
        if (err?.status === 403) {
          toast.error('This account cannot create purchase orders on the server. Use an Admin, Inventory Analyst, or Branch Manager account to approve.');
          return;
        }
        const msg = err?.errors
          ? Object.values(err.errors).flat().join(' ')
          : err?.message || 'Could not create this PO on the server.';
        toast.error(msg);
        return;
      } finally {
        setPoActionLoading(null);
      }
      return;
    }

    setPurchaseOrders((prev) =>
      prev.map((p) => (p.id === id ? { ...p, status: nextStatus } : p)),
    );
    updateApprovalQueuePurchaseOrderStatus(id, nextStatus);
    if (!po?.api_create_payload) {
      toast.warning(
        'Approved locally only — not sent to server. Receive PO will not list this unless it was synced (Draft PO with Item Master lines + branch location) or created in the database.',
      );
    }
  };

  const handleRestockAction = (id, action) => {
    if (!canActOnQueue) return;
    const nextStatus = action === 'approve' ? 'approved' : 'denied';
    setRestockRequests(prev =>
      prev.map(req =>
        req.id === id ? { ...req, status: nextStatus } : req
      )
    );
    updateApprovalQueueRestockRequestStatus(id, nextStatus);
  };

  return (
    <AdminLayout>
      <div className="aq-content">
        {/* Page Header */}
        <div className="aq-page-header">
          <h1>Approvals</h1>
          {!canActOnQueue && !canApproveRegistrations && (
            <p className="aq-viewonly-banner">
              <strong>View only.</strong> Only <strong>Admin</strong> and <strong>Branch Manager</strong> can approve
              item registrations and authorize purchase orders / restock here. You can review and open PO line items
              with the eye icon.
            </p>
          )}
          {!canActOnQueue && canApproveRegistrations && (
            <p className="aq-viewonly-banner">
              <strong>Item registration:</strong> you can approve pending catalog submissions.{' '}
              <strong>Purchase orders</strong> and <strong>restock</strong> on this page are view-only unless you are
              Admin or Branch Manager.
            </p>
          )}
          <p>
            <strong>Item registration</strong> is approval-only: confirm the catalog name here;{' '}
            <strong>unit price and cost</strong> are set later in <strong>Item Master</strong>. When a draft has{' '}
            <strong>Item Master</strong> lines and a{' '}
            <strong>branch-linked location</strong>, <strong>Final Submission</strong> creates the purchase order in the{' '}
            <strong>database</strong> immediately (status Pending Approval) so it appears in <strong>Receive PO</strong>.{' '}
            {canActOnQueue ? (
              <>
                <strong>Approve</strong> sets it to <strong>Authorized</strong> on the server. Receiving stays blocked
                until authorized and on or after the expected delivery date when set.
              </>
            ) : (
              <>
                <strong>Admin</strong> or <strong>Branch Manager</strong> must <strong>Authorize</strong> on the server
                before receiving can proceed (expected delivery date rules still apply).
              </>
            )}
          </p>
        </div>

        {/* Tab Navigation */}
        <div className="aq-tabs">
          <button
            type="button"
            className={`aq-tab-btn ${activeTab === 'item-registration' ? 'active' : ''}`}
            onClick={() => setActiveTab('item-registration')}
          >
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
              <polyline points="14 2 14 8 20 8"></polyline>
              <line x1="12" y1="18" x2="12" y2="12"></line>
              <line x1="9" y1="15" x2="15" y2="15"></line>
            </svg>
            Item registration
          </button>
          <button
            type="button"
            className={`aq-tab-btn ${activeTab === 'restock-requests' ? 'active' : ''}`}
            onClick={() => setActiveTab('restock-requests')}
          >
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <polyline points="23 4 23 10 17 10"></polyline>
              <polyline points="1 20 1 14 7 14"></polyline>
              <path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"></path>
            </svg>
            Restock requests
          </button>
          <button
            type="button"
            className={`aq-tab-btn ${activeTab === 'purchase-orders' ? 'active' : ''}`}
            onClick={() => setActiveTab('purchase-orders')}
          >
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
              <polyline points="14 2 14 8 20 8"></polyline>
            </svg>
            Purchase orders (local)
          </button>
          <button
            type="button"
            className={`aq-tab-btn ${activeTab === 'branch-transfers' ? 'active' : ''}`}
            onClick={() => setActiveTab('branch-transfers')}
          >
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <polyline points="17 1 21 5 17 9"></polyline>
              <path d="M3 11V9a4 4 0 0 1 4-4h14"></path>
              <polyline points="7 23 3 19 7 15"></polyline>
              <path d="M21 13v2a4 4 0 0 1-4 4H3"></path>
            </svg>
            Branch Transfers
          </button>
        </div>

        {/* Item registration (pending products → Item Master) */}
        {activeTab === 'item-registration' && (
          <div className="aq-list">
            {pendingRegLoading ? (
              <p className="aq-meta" style={{ padding: 24 }}>Loading pending registrations…</p>
            ) : pendingRegistrations.length === 0 ? (
              <div className="aq-empty-state">
                <div className="aq-empty-icon">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                    <polyline points="14 2 14 8 20 8"></polyline>
                  </svg>
                </div>
                <p>No products waiting for registration approval.</p>
              </div>
            ) : (
              pendingRegistrations.map((row) => {
                const kind = row.registration_kind === 'appliance' ? 'Appliance' : 'Consumable';
                const snap = row.appliance_snapshot || {};
                const detail =
                  row.registration_kind === 'appliance'
                    ? [snap.capacity_rating, snap.variant].filter(Boolean).join(' · ') || '—'
                    : [row.supply_type, packLabel(row.packaging_unit)].filter(Boolean).join(' · ');
                return (
                  <div className="aq-card" key={row.pending_product_id}>
                    <div className="aq-card-top">
                      <div className="aq-card-title">
                        <h3>
                          <span
                            style={{
                              display: 'inline-block',
                              marginRight: 8,
                              fontSize: 11,
                              fontWeight: 600,
                              padding: '2px 8px',
                              borderRadius: 4,
                              verticalAlign: 'middle',
                              background: row.registration_kind === 'appliance' ? '#dbeafe' : '#fef3c7',
                              color: row.registration_kind === 'appliance' ? '#1e40af' : '#92400e',
                            }}
                          >
                            {kind}
                          </span>
                          {row.generated_name || '—'}
                        </h3>
                        <p>
                          Barcode <code>{row.barcode}</code>
                          {row.category?.category_name || row.brand?.brand_name
                            ? ` · ${[row.category?.category_name, row.brand?.brand_name].filter(Boolean).join(' · ')}`
                            : ''}
                        </p>
                      </div>
                    </div>
                    <div className="aq-card-bottom">
                      <div className="aq-card-info">
                        <span className="aq-meta">{detail}</span>
                        <span className="aq-meta" style={{ display: 'block', marginTop: 6 }}>
                          Submitted {formatDateTime(row.created_at)}
                          {row.creator?.username ? ` · ${row.creator.username}` : ''}
                          {Number(row.opening_quantity) > 0 ? (
                            <>
                              {' · '}
                              <strong>Opening stock:</strong>{' '}
                              {Number(row.opening_quantity).toLocaleString()}
                              {row.openingLocation?.location_name
                                ? ` @ ${row.openingLocation.location_name}`
                                : row.opening_location_id
                                  ? ` @ location #${row.opening_location_id}`
                                  : ''}
                            </>
                          ) : null}
                        </span>
                      </div>
                      <div className="aq-card-actions">
                        {canApproveRegistrations ? (
                          <button
                            type="button"
                            className="aq-btn-approve-restock"
                            onClick={() => openIrApprove(row)}
                          >
                            APPROVE
                          </button>
                        ) : (
                          <span className="aq-badge view-only">PENDING — view only</span>
                        )}
                      </div>
                    </div>
                  </div>
                );
              })
            )}
          </div>
        )}

        {/* Purchase Orders Tab */}
        {activeTab === 'purchase-orders' && (
          <div className="aq-list">
            {purchaseOrders.map(po => (
              <div className="aq-card" key={po.id}>
                <div className="aq-card-top">
                  <div className="aq-card-title">
                    <h3>PO: {po.po_number}</h3>
                    <p>Supplier: {po.supplier}</p>
                  </div>
                </div>
                <div className="aq-card-bottom">
                  <div className="aq-card-info">
                    <span className="aq-amount">₱{Number(po.amount ?? 0).toLocaleString('en-PH')}</span>
                    <span className="aq-meta">Prepared by: {po.prepared_by} • {po.date}</span>
                    <span className="aq-meta" style={{ display: 'block', marginTop: 6 }}>
                      Expected arrival: <strong>{formatYmd(po.expected_delivery_date)}</strong>
                      {po.expected_delivery_date && daysUntil(po.expected_delivery_date) != null && (
                        <>
                          {' '}
                          ({daysUntil(po.expected_delivery_date) > 0
                            ? `in ${daysUntil(po.expected_delivery_date)} day(s)`
                            : daysUntil(po.expected_delivery_date) === 0
                              ? 'due today'
                              : `${Math.abs(daysUntil(po.expected_delivery_date))} day(s) overdue`})
                        </>
                      )}
                    </span>
                    {po.status === 'authorized' && (
                      <span className="aq-meta" style={{ display: 'block', marginTop: 4, color: '#15803d' }}>
                        Approved{po.approved_at ? ` • ${formatYmd(po.approved_at)}` : ''}.
                        {po.synced_to_api
                          ? ' In the database — listed in Receive PO (subject to expected delivery date).'
                          : ' Local-only — not in Receive PO until the PO exists in the database.'}
                      </span>
                    )}
                    {po.status === 'pending' && (
                      <span
                        className="aq-meta"
                        style={{ display: 'block', marginTop: 4, color: po.synced_to_api ? '#1d4ed8' : '#b45309' }}
                      >
                        {canActOnQueue
                          ? po.synced_to_api
                            ? 'Saved in the database (Pending Approval). Approve here to set Authorized — then Receive PO can post against it (expected date rules still apply).'
                            : `Pending approval — Receive PO is blocked until you approve${
                                po.api_create_payload ? ' (legacy: will create on server when approved).' : '.'
                              }`
                          : po.synced_to_api
                            ? 'Saved in the database (Pending Approval). Awaiting Admin or Branch Manager authorization before Receive PO can post against it.'
                            : 'Pending approval — Receive PO stays blocked until an Admin or Branch Manager approves.'}
                      </span>
                    )}
                    {po.status === 'pending' && po.api_sync_note && (
                      <span className="aq-meta" style={{ display: 'block', marginTop: 6, color: '#b91c1c', fontSize: 13 }}>
                        {po.api_sync_note}
                      </span>
                    )}
                  </div>
                  <div className="aq-card-actions">
                    <button
                      type="button"
                      className="aq-btn-view"
                      title="View PO line items for verification"
                      aria-label="View PO products"
                      onClick={() => setPoVerifyModal(po)}
                    >
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                        <circle cx="12" cy="12" r="3"></circle>
                      </svg>
                    </button>
                    {po.status === 'authorized' ? (
                      <span className="aq-badge authorized">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                          <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                          <polyline points="22 4 12 14.01 9 11.01"></polyline>
                        </svg>
                        AUTHORIZED
                      </span>
                    ) : po.status === 'rejected' ? (
                      <span className="aq-badge rejected">REJECTED</span>
                    ) : canActOnQueue ? (
                      <>
                        <button
                          type="button"
                          className="aq-btn-reject"
                          disabled={poActionLoading === po.id}
                          onClick={() => handlePOAction(po.id, 'reject')}
                        >
                          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <circle cx="12" cy="12" r="10"></circle>
                            <line x1="15" y1="9" x2="9" y2="15"></line>
                            <line x1="9" y1="9" x2="15" y2="15"></line>
                          </svg>
                          REJECT
                        </button>
                        <button
                          type="button"
                          className="aq-btn-approve"
                          disabled={poActionLoading === po.id}
                          onClick={() => handlePOAction(po.id, 'approve')}
                        >
                          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                            <polyline points="22 4 12 14.01 9 11.01"></polyline>
                          </svg>
                          {poActionLoading === po.id ? 'SAVING…' : 'APPROVE'}
                        </button>
                      </>
                    ) : (
                      <span className="aq-badge view-only">PENDING — view only</span>
                    )}
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}

        {/* Restock Requests Tab */}
        {activeTab === 'restock-requests' && (
          <div className="aq-list">
            {restockRequests.map(req => (
              <div className="aq-card" key={req.id}>
                <div className="aq-card-top">
                  <div className="aq-card-title">
                    <h3>Restock: {req.item_name}</h3>
                    <p>Destination: {req.destination}</p>
                  </div>
                </div>
                <div className="aq-card-bottom">
                  <div className="aq-card-info">
                    <span className="aq-amount">Quantity: {req.quantity} units</span>
                    <span className="aq-meta">From: {req.from} • Requested: {req.requested_date}</span>
                  </div>
                  <div className="aq-card-actions">
                    {req.status === 'approved' ? (
                      <span className="aq-badge authorized">APPROVED</span>
                    ) : req.status === 'denied' ? (
                      <span className="aq-badge rejected">DENIED</span>
                    ) : req.status === 'inactive' ? (
                      <span className="aq-badge inactive">Inactive</span>
                    ) : canActOnQueue ? (
                      <>
                        <button type="button" className="aq-btn-deny" onClick={() => handleRestockAction(req.id, 'deny')}>
                          DENY
                        </button>
                        <button
                          type="button"
                          className="aq-btn-approve-restock"
                          onClick={() => handleRestockAction(req.id, 'approve')}
                        >
                          APPROVE
                        </button>
                      </>
                    ) : (
                      <span className="aq-badge view-only">PENDING — view only</span>
                    )}
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}

        {/* Branch Transfers Tab */}
        {activeTab === 'branch-transfers' && (
          <div className="aq-list">
            {branchTransfers.length === 0 ? (
              <div className="aq-empty-state">
                <div className="aq-empty-icon">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                    <polyline points="14 2 14 8 20 8"></polyline>
                  </svg>
                </div>
                <p>No pending transfers for approval</p>
              </div>
            ) : (
              branchTransfers.map(transfer => (
                <div className="aq-card" key={transfer.id}>
                  <p>{transfer.description}</p>
                </div>
              ))
            )}
          </div>
        )}
      </div>

      {irApproveOpen && irSelected && (
        <Modal
          title="Approve item registration"
          onClose={() => !irSubmitting && setIrApproveOpen(false)}
          maxWidth={480}
        >
          <form onSubmit={handleIrApproveSubmit}>
            <p style={{ fontSize: 13, color: '#6b7280', marginBottom: 12 }}>
              Barcode <code>{irSelected.barcode}</code>
              {' · '}
              {irSelected.registration_kind === 'appliance' ? 'Appliance' : 'Consumable'}
            </p>
            <p style={{ fontSize: 13, color: '#1e40af', background: '#eff6ff', padding: 10, borderRadius: 8, marginBottom: 12 }}>
              Pricing is not entered here. After approval, open this product in <strong>Item Master</strong> to set unit price and cost.
            </p>
            <label style={{ display: 'block', marginBottom: 16, fontSize: 13, fontWeight: 600 }}>
              Catalog product name
              <input
                type="text"
                style={{ width: '100%', marginTop: 4, padding: '8px 10px', border: '1px solid #e5e7eb', borderRadius: 6 }}
                value={irApproveForm.final_product_name}
                onChange={(e) =>
                  setIrApproveForm((f) => ({ ...f, final_product_name: e.target.value }))
                }
                required
              />
            </label>
            <div style={{ display: 'flex', gap: 8, justifyContent: 'flex-end' }}>
              <button type="button" className="aq-modal-done" disabled={irSubmitting} onClick={() => setIrApproveOpen(false)}>
                Cancel
              </button>
              <button type="submit" className="aq-btn-approve-restock" disabled={irSubmitting} style={{ border: 'none', cursor: 'pointer' }}>
                {irSubmitting ? 'Approving…' : 'Approve & add to Item Master'}
              </button>
            </div>
          </form>
        </Modal>
      )}

      {poVerifyModal && (
        <div
          className="aq-modal-backdrop"
          role="presentation"
          onClick={() => setPoVerifyModal(null)}
        >
          <div
            className="aq-modal"
            role="dialog"
            aria-labelledby="aq-po-verify-title"
            aria-modal="true"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="aq-modal-head">
              <h2 id="aq-po-verify-title">Verify PO products</h2>
              <button
                type="button"
                className="aq-modal-close"
                onClick={() => setPoVerifyModal(null)}
                aria-label="Close"
              >
                ×
              </button>
            </div>
            <p className="aq-modal-sub">
              <strong>{poVerifyModal.po_number}</strong>
              {' · '}
              {poVerifyModal.supplier}
              {' · '}
              ₱{Number(poVerifyModal.amount || 0).toLocaleString('en-PH')}
            </p>
            {poVerifyLoading && <p className="aq-modal-loading">Loading line items…</p>}
            {poVerifyError && !poVerifyLoading && (
              <p className="aq-modal-err">{poVerifyError}</p>
            )}
            {!poVerifyLoading && poVerifyLines.length > 0 && (
              <div className="aq-modal-table-wrap">
                <table className="aq-modal-table">
                  <thead>
                    <tr>
                      <th>Product</th>
                      <th>ID</th>
                      <th>Qty</th>
                      <th>Unit</th>
                      <th>Line total</th>
                    </tr>
                  </thead>
                  <tbody>
                    {poVerifyLines.map((row) => (
                      <tr key={row.key}>
                        <td>
                          <span className="aq-modal-prod">{row.name}</span>
                          {(row.brand || row.category) && (
                            <span className="aq-modal-meta">
                              {[row.brand, row.category].filter(Boolean).join(' · ')}
                              {row.type ? ` · ${row.type}` : ''}
                            </span>
                          )}
                        </td>
                        <td>{row.product_id ?? '—'}</td>
                        <td>{row.qty}</td>
                        <td>₱{Number(row.unit || 0).toLocaleString('en-PH')}</td>
                        <td>₱{Number(row.lineTotal || 0).toLocaleString('en-PH')}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
            <div className="aq-modal-foot">
              <button type="button" className="aq-modal-done" onClick={() => setPoVerifyModal(null)}>
                Close
              </button>
            </div>
          </div>
        </div>
      )}
    </AdminLayout>
  );
};

export default ApprovalQueue;
