import React, { useEffect, useState } from 'react';
import { useLocation } from 'react-router-dom';
import AdminLayout from '../components/AdminLayout';
import {
  getApprovalQueuePurchaseOrders,
  getApprovalQueueRestockRequests,
  updateApprovalQueuePurchaseOrderStatus,
  updateApprovalQueueRestockRequestStatus,
  mergeApprovalQueuePurchaseOrder,
} from '../utils/approvalNotifications';
import { purchaseOrdersAPI, statusAPI } from '../services/api';
import { toast } from '../utils/toast';
import '../styles/approval_queue.css';

const AQ_TABS = ['restock-requests', 'purchase-orders', 'branch-transfers'];

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

const ApprovalQueue = ({ initialTab } = {}) => {
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
  const [poActionLoading, setPoActionLoading] = useState(null);

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
          <h1>Approval Queue</h1>
          <p>
            When a draft has <strong>Item Master</strong> lines and a <strong>branch-linked location</strong>,{' '}
            <strong>Final Submission</strong> creates the purchase order in the <strong>database</strong> immediately
            (status Pending Approval) so it appears in <strong>Receive PO</strong>. <strong>Approve</strong> sets it to{' '}
            <strong>Authorized</strong> on the server. Receiving stays blocked until authorized and on or after the
            expected delivery date when set.
          </p>
        </div>

        {/* Tab Navigation */}
        <div className="aq-tabs">
          <button
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
                    <span className="aq-amount">₱{po.amount.toLocaleString('en-PH')}</span>
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
                        {po.synced_to_api
                          ? 'Saved in the database (Pending Approval). Approve here to set Authorized — then Receive PO can post against it (expected date rules still apply).'
                          : `Pending approval — Receive PO is blocked until you approve${
                              po.api_create_payload ? ' (legacy: will create on server when approved).' : '.'
                            }`}
                      </span>
                    )}
                    {po.status === 'pending' && po.api_sync_note && (
                      <span className="aq-meta" style={{ display: 'block', marginTop: 6, color: '#b91c1c', fontSize: 13 }}>
                        {po.api_sync_note}
                      </span>
                    )}
                  </div>
                  <div className="aq-card-actions">
                    <button className="aq-btn-view" title="View details">
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
                    ) : (
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
                    ) : (
                      <>
                        <button className="aq-btn-deny" onClick={() => handleRestockAction(req.id, 'deny')}>DENY</button>
                        <button className="aq-btn-approve-restock" onClick={() => handleRestockAction(req.id, 'approve')}>APPROVE</button>
                      </>
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
    </AdminLayout>
  );
};

export default ApprovalQueue;
