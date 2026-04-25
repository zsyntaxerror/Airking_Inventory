import React, { useCallback, useEffect, useMemo, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import AdminLayout from '../components/AdminLayout';
import Modal from '../components/Modal';
import { purchaseOrdersAPI, statusAPI } from '../services/api';
import { downloadPoCsv, openPoPrintPdf } from '../utils/purchaseOrderExport';
import { toast } from '../utils/toast';
import '../styles/approval_queue.css';
import '../styles/purchase_order_list.css';

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

const statusClass = (po) => {
  const n = String(po?.status?.status_name || '').toLowerCase();
  if (n.includes('reject')) return 'rejected';
  if (n.includes('authori') || n.includes('approved')) return 'authorized';
  if (n.includes('pending')) return 'inactive';
  if (n.includes('partial')) return 'inactive';
  if (n.includes('fulfill')) return 'authorized';
  return 'inactive';
};

const PurchaseOrderListPage = () => {
  const navigate = useNavigate();
  const [rows, setRows] = useState([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [statusFilter, setStatusFilter] = useState('');
  const [statusChoices, setStatusChoices] = useState([]);
  const [viewPoId, setViewPoId] = useState(null);
  const [viewPo, setViewPo] = useState(null);
  const [viewLoading, setViewLoading] = useState(false);

  useEffect(() => {
    statusAPI
      .getAll({ category: 'purchase_order' })
      .then((res) => {
        const list = Array.isArray(res?.data) ? res.data : [];
        setStatusChoices(list);
      })
      .catch(() => setStatusChoices([]));
  }, []);

  const loadAll = useCallback(async () => {
    setLoading(true);
    try {
      const acc = [];
      let page = 1;
      let lastPage = 1;
      do {
        const params = { per_page: 50, page, ...(search.trim() ? { search: search.trim() } : {}) };
        if (statusFilter) params.status_id = statusFilter;
        const res = await purchaseOrdersAPI.getAll(params);
        const chunk = Array.isArray(res?.data) ? res.data : [];
        acc.push(...chunk);
        lastPage = res?.pagination?.last_page ?? 1;
        page += 1;
      } while (page <= lastPage);
      acc.sort((a, b) => {
        const ta = new Date(a.updated_at || a.created_at || 0).getTime();
        const tb = new Date(b.updated_at || b.created_at || 0).getTime();
        return tb - ta;
      });
      setRows(acc);
    } catch (e) {
      toast.error(e.message || 'Could not load purchase orders.');
      setRows([]);
    } finally {
      setLoading(false);
    }
  }, [search, statusFilter]);

  useEffect(() => {
    const t = setTimeout(() => {
      loadAll();
    }, 300);
    return () => clearTimeout(t);
  }, [loadAll]);

  const openDetails = useCallback(async (id) => {
    if (!id) return;
    setViewPoId(id);
    setViewLoading(true);
    try {
      const res = await purchaseOrdersAPI.getById(id);
      setViewPo(res?.data ?? null);
    } catch (e) {
      setViewPo(null);
      toast.error(e.message || 'Could not load purchase order details.');
    } finally {
      setViewLoading(false);
    }
  }, []);

  const closeDetails = () => {
    setViewPoId(null);
    setViewPo(null);
    setViewLoading(false);
  };

  const kpis = useMemo(() => {
    const pending = rows.filter((r) => String(r?.status?.status_name || '').toLowerCase().includes('pending')).length;
    const approved = rows.filter((r) => {
      const n = String(r?.status?.status_name || '').toLowerCase();
      return n.includes('authori') || n.includes('approved');
    }).length;
    const rejected = rows.filter((r) => String(r?.status?.status_name || '').toLowerCase().includes('reject')).length;
    return { pending, approved, rejected };
  }, [rows]);

  const priorityLabel = (po) => {
    const amount = Number(po?.grand_total ?? po?.total_amount ?? 0);
    if (amount >= 100000) return { text: 'HIGH', cls: 'high' };
    if (amount >= 40000) return { text: 'MEDIUM', cls: 'medium' };
    return { text: 'LOW', cls: 'low' };
  };

  const sourceLabel = (po) => po?.supplier?.supplier_name ?? po?.supplier?.name ?? '—';

  return (
    <AdminLayout>
      <div className="aq-content po-list-page">
        <div className="po-list-hero">
          <div className="po-list-title-wrap">
            <h1>DRAFT PURCHASE ORDERS</h1>
            <p>View, review, and manage all draft purchase orders saved in the database.</p>
          </div>
          <div className="po-list-actions">
            <button
              type="button"
              className="po-list-export-btn"
              disabled={!rows.length}
              onClick={() => downloadPoCsv({ pc_number: 'all-drafts', details: [] }, 'purchase-orders-summary')}
              title="Export template summary CSV"
            >
              Export Excel
            </button>
            <button
              type="button"
              className="po-list-submit-btn"
              onClick={() => navigate('/admin/draft-po-creator')}
            >
              Create / Final Submission
            </button>
          </div>
        </div>

        <div className="po-list-tabs">
          <Link to="/admin/draft-po-creator">Create PO</Link>
          <span className="active">Draft PO Status</span>
        </div>

        <div className="po-kpi-row">
          <span className="po-kpi-chip pending">Pending: {kpis.pending}</span>
          <span className="po-kpi-chip approved">Approved: {kpis.approved}</span>
          <span className="po-kpi-chip rejected">Rejected: {kpis.rejected}</span>
        </div>

        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 12, marginBottom: 16, alignItems: 'center' }}>
          <input
            type="search"
            placeholder="Search PO number..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            style={{
              padding: '10px 12px',
              borderRadius: 8,
              border: '1px solid #e5e7eb',
              minWidth: 220,
            }}
          />
          <label style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: 14 }}>
            Status
            <select
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value)}
              style={{ padding: '8px 10px', borderRadius: 8, border: '1px solid #e5e7eb' }}
            >
              <option value="">All</option>
              {statusChoices.map((s) => (
                <option key={s.status_id} value={s.status_id}>
                  {s.status_name}
                </option>
              ))}
            </select>
          </label>
          <button
            type="button"
            className="aq-modal-done"
            onClick={() => loadAll()}
            style={{ border: '1px solid #d1d5db' }}
          >
            Refresh
          </button>
        </div>

        {loading ? (
          <p className="aq-meta" style={{ padding: 24 }}>
            Loading…
          </p>
        ) : rows.length === 0 ? (
          <div className="aq-empty-state">
            <p>No purchase orders found. Submit a draft from Draft PO Creator (with Item Master lines and a location).</p>
          </div>
        ) : (
          <div className="aq-list">
            {rows.map((po) => {
              const id = po.po_id ?? po.id;
              const num = po.pc_number ?? po.po_number ?? `#${id}`;
              const supplier = sourceLabel(po);
              const amount = Number(po.grand_total ?? po.total_amount ?? 0);
              const detailsCount = Array.isArray(po.details) ? po.details.length : Number(po.total_items ?? 0);
              const priority = priorityLabel(po);
              const st = statusLabel(po).toUpperCase();
              return (
                <div key={id} className="po-status-card">
                  <div className="po-status-card-head">
                    <div>
                      <h3>{num}</h3>
                      <p>Supplier: {supplier}</p>
                    </div>
                    <div className="po-status-card-right">
                      <span className={`po-mini-badge status-${statusClass(po)}`}>{st}</span>
                      <span className={`po-mini-badge priority-${priority.cls}`}>{priority.text}</span>
                    </div>
                  </div>
                  <div className="po-status-grid">
                    <div>
                      <label>Created By</label>
                      <strong>{po.createdBy?.first_name || po.createdBy?.username || '—'}</strong>
                    </div>
                    <div>
                      <label>Created Date</label>
                      <strong>{formatShortDate(po.order_date || po.created_at)}</strong>
                    </div>
                    <div>
                      <label>Items</label>
                      <strong>{detailsCount} items</strong>
                    </div>
                    <div className="amount">
                      <label>Total Amount</label>
                      <strong>₱{amount.toLocaleString('en-PH')}</strong>
                    </div>
                  </div>
                  <div className="po-status-card-foot">
                    <button type="button" className="po-view-btn" onClick={() => openDetails(id)}>
                      View Details
                    </button>
                    <Link to={`/admin/purchase-orders/${id}`} className="po-open-page-link">
                      Open page
                    </Link>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>

      <Modal isOpen={!!viewPoId} onClose={closeDetails} title="" hideHeader maxWidth={980}>
        <div className="po-detail-modal">
          {viewLoading ? (
            <div className="po-detail-loading">Loading purchase order details...</div>
          ) : !viewPo ? (
            <div className="po-detail-loading">No purchase order found.</div>
          ) : (
            <>
              <div className="po-detail-head">
                <div>
                  <h2>{viewPo.pc_number ?? viewPo.po_number ?? `PO-${viewPoId}`}</h2>
                  <p>Purchase Order Details</p>
                </div>
                <div className="po-detail-head-actions">
                  <button type="button" onClick={() => downloadPoCsv(viewPo)}>Export to Excel</button>
                  <button type="button" onClick={() => openPoPrintPdf(viewPo)}>Export to PDF</button>
                  <button type="button" className="close" onClick={closeDetails}>×</button>
                </div>
              </div>

              <div className="po-detail-block">
                <h4>Supplier Information</h4>
                <div className="po-detail-cols">
                  <div><label>Supplier Name</label><strong>{sourceLabel(viewPo)}</strong></div>
                  <div><label>Email</label><strong>{viewPo.supplier?.email ?? '—'}</strong></div>
                  <div><label>Contact Person</label><strong>{viewPo.supplier?.contact_person ?? '—'}</strong></div>
                  <div><label>Address</label><strong>{viewPo.supplier?.address ?? '—'}</strong></div>
                </div>
              </div>

              <div className="po-detail-block">
                <h4>Order Information</h4>
                <div className="po-detail-cols">
                  <div><label>Created By</label><strong>{viewPo.createdBy?.first_name || viewPo.createdBy?.username || '—'}</strong></div>
                  <div><label>Created Date</label><strong>{formatShortDate(viewPo.order_date || viewPo.created_at)}</strong></div>
                  <div><label>Delivery Location</label><strong>{viewPo.location?.location_name ?? '—'}</strong></div>
                  <div><label>Total Items</label><strong>{Array.isArray(viewPo.details) ? viewPo.details.length : 0} items</strong></div>
                  <div><label>Status</label><strong>{statusLabel(viewPo)}</strong></div>
                  <div><label>Expected Delivery</label><strong>{formatShortDate(viewPo.expected_delivery_date)}</strong></div>
                </div>
              </div>

              <div className="po-detail-block">
                <h4>Order Items</h4>
                <table className="po-detail-table">
                  <thead>
                    <tr>
                      <th>SKU</th>
                      <th>Product Name</th>
                      <th>Category</th>
                      <th>Quantity</th>
                      <th>Unit Price</th>
                      <th>Total</th>
                    </tr>
                  </thead>
                  <tbody>
                    {(viewPo.details || []).map((d) => (
                      <tr key={d.po_detail_id ?? d.product_id}>
                        <td>{d.product?.product_code ?? `P-${d.product_id ?? '—'}`}</td>
                        <td>{d.product?.product_name ?? '—'}</td>
                        <td>{d.product?.category?.category_name ?? d.product?.category_name ?? '—'}</td>
                        <td>{Number(d.quantity_ordered ?? 0).toLocaleString('en-PH')}</td>
                        <td>₱{Number(d.unit_price ?? 0).toLocaleString('en-PH')}</td>
                        <td>₱{Number(d.subtotal ?? 0).toLocaleString('en-PH')}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>

              <div className="po-detail-total">
                <span>Total Amount</span>
                <strong>₱{Number(viewPo.grand_total ?? viewPo.total_amount ?? 0).toLocaleString('en-PH')}</strong>
              </div>
            </>
          )}
        </div>
      </Modal>
    </AdminLayout>
  );
};

export default PurchaseOrderListPage;
