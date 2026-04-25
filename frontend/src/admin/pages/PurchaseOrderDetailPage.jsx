import React, { useCallback, useEffect, useState } from 'react';
import { Link, useNavigate, useParams } from 'react-router-dom';
import AdminLayout from '../components/AdminLayout';
import { useAuth } from '../context/AuthContext';
import { purchaseOrdersAPI } from '../services/api';
import { canApprovePurchaseOrders } from '../utils/roles';
import { downloadPoCsv, downloadPoHtmlDocument, openPoPrintPdf } from '../utils/purchaseOrderExport';
import { toast } from '../utils/toast';
import '../styles/approval_queue.css';

const formatShortDate = (value) => {
  if (!value) return '—';
  const d = new Date(value);
  if (Number.isNaN(d.getTime())) return String(value);
  return d.toLocaleDateString('en-PH', { year: 'numeric', month: 'short', day: 'numeric' });
};

const statusLabel = (po) => {
  const raw = po?.status?.status_name || '';
  const n = String(raw).toLowerCase();
  if (n.includes('authori')) return 'Approved';
  if (n.includes('pending')) return 'Pending';
  if (n.includes('reject')) return 'Rejected';
  if (n.includes('partial')) return 'Partial';
  if (n.includes('fulfill') && !n.includes('partial')) return 'Fulfilled';
  return raw || '—';
};

const PurchaseOrderDetailPage = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const { user } = useAuth();
  const canApprove = canApprovePurchaseOrders(user);
  const [po, setPo] = useState(null);
  const [loading, setLoading] = useState(true);
  const [actionLoading, setActionLoading] = useState(false);

  const load = useCallback(async () => {
    if (!id) return;
    setLoading(true);
    try {
      const res = await purchaseOrdersAPI.getById(id);
      setPo(res?.data ?? null);
    } catch (e) {
      toast.error(e.message || 'Could not load purchase order.');
      setPo(null);
    } finally {
      setLoading(false);
    }
  }, [id]);

  useEffect(() => {
    load();
  }, [load]);

  const nameLower = String(po?.status?.status_name || '').toLowerCase();
  const isPending = nameLower.includes('pending');
  const isRejected = nameLower.includes('reject');
  const isApprovedish = nameLower.includes('authori') || nameLower.includes('approved');

  const handleApprove = async () => {
    if (!canApprove || !id) return;
    setActionLoading(true);
    try {
      const res = await purchaseOrdersAPI.approve(id);
      setPo(res?.data ?? po);
      toast.success('Purchase order approved.');
    } catch (e) {
      toast.error(e.message || 'Approval failed.');
    } finally {
      setActionLoading(false);
    }
  };

  const handleReject = async () => {
    if (!canApprove || !id) return;
    if (!window.confirm('Reject this purchase order? It will remain on record with Rejected status.')) return;
    setActionLoading(true);
    try {
      const res = await purchaseOrdersAPI.reject(id, {});
      setPo(res?.data ?? po);
      toast.success('Purchase order rejected.');
    } catch (e) {
      toast.error(e.message || 'Reject failed.');
    } finally {
      setActionLoading(false);
    }
  };

  const num = po?.pc_number ?? po?.po_number ?? id;

  return (
    <AdminLayout>
      <div className="aq-content">
        <div className="aq-page-header">
          <div style={{ display: 'flex', alignItems: 'center', gap: 12, flexWrap: 'wrap' }}>
            <button type="button" className="aq-modal-done" onClick={() => navigate('/admin/purchase-orders')}>
              ← Back to list
            </button>
            <h1 style={{ margin: 0 }}>PO {num}</h1>
            {po && (
              <span className={`aq-badge ${isRejected ? 'rejected' : isApprovedish ? 'authorized' : 'inactive'}`}>
                {statusLabel(po)}
              </span>
            )}
          </div>
          <p style={{ marginTop: 12 }}>
            <Link to="/admin/approval-queue?tab=purchase-orders">Open Approvals</Link>
            {' · '}
            <Link to="/admin/draft-po-creator">Draft PO Creator</Link>
          </p>
        </div>

        {loading ? (
          <p className="aq-meta" style={{ padding: 24 }}>
            Loading…
          </p>
        ) : !po ? (
          <div className="aq-empty-state">
            <p>Purchase order not found.</p>
          </div>
        ) : (
          <>
            <div className="aq-card" style={{ marginBottom: 20 }}>
              <div className="aq-card-top">
                <div className="aq-card-title">
                  <h3>Summary</h3>
                  <p>
                    {po.supplier?.supplier_name ?? po.supplier?.name ?? '—'} ·{' '}
                    {po.location?.location_name ?? po.location?.name ?? '—'}
                  </p>
                </div>
              </div>
              <div className="aq-card-bottom">
                <div className="aq-card-info">
                  <span className="aq-amount">₱{Number(po.grand_total ?? po.total_amount ?? 0).toLocaleString('en-PH')}</span>
                  <span className="aq-meta">
                    Order date {formatShortDate(po.order_date)}
                    {po.expected_delivery_date ? ` · Expected ${formatShortDate(po.expected_delivery_date)}` : ''}
                  </span>
                  <span className="aq-meta" style={{ display: 'block', marginTop: 8 }}>
                    Created by {po.createdBy?.username ?? po.createdBy?.first_name ?? '—'} ·{' '}
                    {formatShortDate(po.created_at)}
                  </span>
                </div>
                <div className="aq-card-actions" style={{ flexWrap: 'wrap', gap: 8 }}>
                  <button
                    type="button"
                    className="aq-modal-done"
                    onClick={() => downloadPoCsv(po)}
                    style={{ border: '1px solid #d1d5db' }}
                  >
                    Export Excel (CSV)
                  </button>
                  <button
                    type="button"
                    className="aq-modal-done"
                    onClick={() => downloadPoHtmlDocument(po)}
                    style={{ border: '1px solid #d1d5db' }}
                  >
                    Export document
                  </button>
                  <button
                    type="button"
                    className="aq-modal-done"
                    onClick={() => openPoPrintPdf(po)}
                    style={{ border: '1px solid #d1d5db' }}
                  >
                    Export PDF (print)
                  </button>
                  {canApprove && isPending && (
                    <>
                      <button
                        type="button"
                        className="aq-btn-reject"
                        disabled={actionLoading}
                        onClick={handleReject}
                      >
                        Reject
                      </button>
                      <button
                        type="button"
                        className="aq-btn-approve"
                        disabled={actionLoading}
                        onClick={handleApprove}
                      >
                        {actionLoading ? '…' : 'Approve'}
                      </button>
                    </>
                  )}
                  {!canApprove && isPending && (
                    <span className="aq-badge view-only">Pending — admin approves</span>
                  )}
                </div>
              </div>
            </div>

            <div className="aq-modal-table-wrap" style={{ background: '#fff', borderRadius: 12, padding: 16 }}>
              <h3 style={{ marginTop: 0 }}>Line items</h3>
              <table className="aq-modal-table">
                <thead>
                  <tr>
                    <th>Product</th>
                    <th>Qty</th>
                    <th>Unit</th>
                    <th>Subtotal</th>
                  </tr>
                </thead>
                <tbody>
                  {(po.details || []).map((d) => {
                    const p = d.product || {};
                    const label = p.product_name || p.name || `Product #${d.product_id}`;
                    return (
                      <tr key={d.po_detail_id ?? d.product_id}>
                        <td>{label}</td>
                        <td>{d.quantity_ordered}</td>
                        <td>₱{Number(d.unit_price ?? 0).toLocaleString('en-PH')}</td>
                        <td>₱{Number(d.subtotal ?? 0).toLocaleString('en-PH')}</td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          </>
        )}
      </div>
    </AdminLayout>
  );
};

export default PurchaseOrderDetailPage;
