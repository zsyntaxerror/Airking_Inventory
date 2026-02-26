import React, { useState, useEffect, useCallback, useRef } from 'react';
import AdminLayout from '../components/AdminLayout';
import Modal from '../components/Modal';
import { receivingsAPI, purchaseOrdersAPI, locationsAPI, productsAPI, statusAPI } from '../services/api';
import { toast } from '../utils/toast';
import '../../admin/styles/dashboard_air.css';

const CONDITIONS = ['Good', 'Damaged', 'Expired', 'Defective'];
const emptyDetail = () => ({ product_id: '', quantity_amount: 1, condition: 'Good' });
const emptyForm = () => ({
  pc_id: '', location_id: '', receiving_number: '', receiving_date: '',
  total_quantity_damaged: 0, status_id: '', details: [emptyDetail()],
});

const ReceivingManagement = () => {
  const [receivings, setReceivings] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [currentPage, setCurrentPage] = useState(1);
  const [pagination, setPagination] = useState({ total: 0, last_page: 1 });
  const [searchTerm, setSearchTerm] = useState('');
  const [purchaseOrders, setPurchaseOrders] = useState([]);
  const [locations, setLocations] = useState([]);
  const [products, setProducts] = useState([]);
  const [statuses, setStatuses] = useState([]);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [viewingReceiving, setViewingReceiving] = useState(null);
  const [editingReceiving, setEditingReceiving] = useState(null);
  const [submitting, setSubmitting] = useState(false);
  const [formData, setFormData] = useState(emptyForm());
  const debounceRef = useRef(null);

  const fetchDropdowns = useCallback(async () => {
    try {
      const [poRes, locRes, prodRes, statRes] = await Promise.all([
        purchaseOrdersAPI.getAll({ per_page: 500 }),
        locationsAPI.getAll(),
        productsAPI.getAll({ per_page: 500 }),
        statusAPI.getAll(),
      ]);
      setPurchaseOrders(Array.isArray(poRes?.data) ? poRes.data : []);
      setLocations(Array.isArray(locRes?.data) ? locRes.data : []);
      setProducts(Array.isArray(prodRes?.data) ? prodRes.data : []);
      setStatuses(Array.isArray(statRes?.data) ? statRes.data : []);
    } catch (e) { console.error('Dropdown fetch error:', e); }
  }, []);

  const fetchReceivings = useCallback(async (page = 1) => {
    setLoading(true);
    try {
      const params = { page, per_page: 10 };
      if (searchTerm) params.search = searchTerm;
      const res = await receivingsAPI.getAll(params);
      setReceivings(Array.isArray(res?.data) ? res.data : []);
      setPagination(res?.pagination || res?.meta || { total: 0, last_page: 1 });
      setError(null);
    } catch (e) { setError(e.message); } finally { setLoading(false); }
  }, [searchTerm]);

  useEffect(() => { fetchDropdowns(); }, [fetchDropdowns]);
  useEffect(() => { fetchReceivings(currentPage); }, [currentPage, fetchReceivings]);
  useEffect(() => {
    if (debounceRef.current) clearTimeout(debounceRef.current);
    debounceRef.current = setTimeout(() => setCurrentPage(1), 400);
    return () => clearTimeout(debounceRef.current);
  }, [searchTerm]);

  const openAddModal = () => { setEditingReceiving(null); setFormData(emptyForm()); setIsModalOpen(true); };
  const openEditModal = (r) => {
    setEditingReceiving(r);
    setFormData({
      pc_id: r.pc_id || r.purchase_order?.po_id || '',
      location_id: r.location_id || '',
      receiving_number: r.receiving_number || '',
      receiving_date: r.receiving_date ? r.receiving_date.split('T')[0] : '',
      total_quantity_damaged: r.total_quantity_damaged || 0,
      status_id: r.status_id || '',
      details: r.details?.length ? r.details.map(d => ({
        product_id: d.product_id || '', quantity_amount: d.quantity_amount || 1, condition: d.condition || 'Good',
      })) : [emptyDetail()],
    });
    setIsModalOpen(true);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!formData.details[0]?.product_id) { toast.error('Add at least one product.'); return; }
    setSubmitting(true);
    try {
      const payload = { ...formData, details: formData.details.map(d => ({ ...d, quantity_amount: parseInt(d.quantity_amount, 10) || 0 })) };
      if (editingReceiving) {
        await receivingsAPI.update(editingReceiving.receiving_id, payload);
        toast.success('Receiving record updated.');
      } else {
        await receivingsAPI.create(payload);
        toast.success('Receiving record created. Inventory updated.');
      }
      setIsModalOpen(false);
      fetchReceivings(currentPage);
    } catch (e) { toast.error(e.message || 'Failed to save.'); } finally { setSubmitting(false); }
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Delete this receiving record?')) return;
    try { await receivingsAPI.delete(id); toast.success('Deleted.'); fetchReceivings(currentPage); }
    catch (e) { toast.error(e.message || 'Failed to delete.'); }
  };

  const addDetailRow = () => setFormData(f => ({ ...f, details: [...f.details, emptyDetail()] }));
  const removeDetailRow = (i) => setFormData(f => ({ ...f, details: f.details.filter((_, idx) => idx !== i) }));
  const updateDetail = (i, field, value) => setFormData(f => {
    const details = [...f.details]; details[i] = { ...details[i], [field]: value }; return { ...f, details };
  });

  const totalQtyReceived = receivings.reduce((s, r) => s + (r.total_quantity_received || 0), 0);
  const now = new Date();
  const thisMonth = receivings.filter(r => {
    if (!r.receiving_date) return false;
    const d = new Date(r.receiving_date);
    return d.getMonth() === now.getMonth() && d.getFullYear() === now.getFullYear();
  });

  const renderPages = () => {
    const total = pagination.last_page || 1;
    let start = Math.max(1, currentPage - 2), end = Math.min(total, start + 4);
    if (end - start < 4) start = Math.max(1, end - 4);
    const pages = []; for (let i = start; i <= end; i++) pages.push(i); return pages;
  };

  return (
    <AdminLayout>
      <div className="page-container">
        <div className="page-header">
          <div>
            <h1 className="page-title">Receiving of Items</h1>
            <p className="page-subtitle">Record goods received from purchase orders</p>
          </div>
          <button className="btn-primary" onClick={openAddModal}>+ New Receiving</button>
        </div>

        <div className="stats-row">
          {[
            { label: 'Total Receivings', value: pagination.total || receivings.length, color: '#6366f1' },
            { label: 'Pending', value: receivings.filter(r => r.status?.status_name === 'Pending').length, color: '#f59e0b' },
            { label: 'Completed', value: receivings.filter(r => ['Completed', 'Received'].includes(r.status?.status_name)).length, color: '#10b981' },
            { label: 'Total Qty Received', value: totalQtyReceived, color: '#3b82f6' },
          ].map((s, i) => (
            <div key={i} className="stat-card">
              <div className="stat-icon" style={{ background: s.color + '20', color: s.color }}>
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="20" height="20">
                  <path d="M5 12h14"></path><path d="m12 5 7 7-7 7"></path>
                </svg>
              </div>
              <div><div className="stat-value">{s.value}</div><div className="stat-label">{s.label}</div></div>
            </div>
          ))}
        </div>

        <div className="table-toolbar">
          <input className="search-input" placeholder="Search receiving number..." value={searchTerm} onChange={e => setSearchTerm(e.target.value)} />
        </div>

        <div className="table-wrapper">
          <table className="data-table">
            <thead>
              <tr><th>Receiving #</th><th>PO Number</th><th>Location</th><th>Date</th><th>Total Qty</th><th>Damaged</th><th>Status</th><th>Actions</th></tr>
            </thead>
            <tbody>
              {loading ? <tr><td colSpan="8" className="table-empty">Loading...</td></tr>
                : error ? <tr><td colSpan="8" className="table-empty"><span style={{ color: '#ef4444' }}>{error}</span><button className="btn-link" onClick={() => fetchReceivings(currentPage)} style={{ marginLeft: 8 }}>Retry</button></td></tr>
                  : receivings.length === 0 ? <tr><td colSpan="8" className="table-empty">No receiving records found.</td></tr>
                    : receivings.map(r => (
                      <tr key={r.receiving_id}>
                        <td><span className="badge badge-blue">{r.receiving_number}</span></td>
                        <td>{r.purchase_order?.po_number || '—'}</td>
                        <td>{r.location?.location_name || r.location?.name || '—'}</td>
                        <td>{r.receiving_date ? new Date(r.receiving_date).toLocaleDateString() : '—'}</td>
                        <td>{r.total_quantity_received ?? '—'}</td>
                        <td><span style={{ color: r.total_quantity_damaged > 0 ? '#ef4444' : '#10b981' }}>{r.total_quantity_damaged ?? 0}</span></td>
                        <td><span className={`badge ${r.status?.status_name === 'Received' || r.status?.status_name === 'Completed' ? 'badge-green' : 'badge-yellow'}`}>{r.status?.status_name || 'N/A'}</span></td>
                        <td>
                          <div className="action-btns">
                            <button className="btn-action btn-view" onClick={() => setViewingReceiving(r)}>View</button>
                            <button className="btn-action btn-edit" onClick={() => openEditModal(r)}>Edit</button>
                            <button className="btn-action btn-delete" onClick={() => handleDelete(r.receiving_id)}>Delete</button>
                          </div>
                        </td>
                      </tr>
                    ))}
            </tbody>
          </table>
        </div>

        {pagination.last_page > 1 && (
          <div className="pagination">
            <button className="page-btn" disabled={currentPage === 1} onClick={() => setCurrentPage(p => p - 1)}>Previous</button>
            {renderPages().map(p => <button key={p} className={`page-btn ${p === currentPage ? 'active' : ''}`} onClick={() => setCurrentPage(p)}>{p}</button>)}
            <button className="page-btn" disabled={currentPage === pagination.last_page} onClick={() => setCurrentPage(p => p + 1)}>Next</button>
          </div>
        )}
      </div>

      {viewingReceiving && (
        <Modal title={`Receiving: ${viewingReceiving.receiving_number}`} onClose={() => setViewingReceiving(null)}>
          <div className="detail-grid">
            <div><span className="detail-label">PO Number</span><span className="detail-value">{viewingReceiving.purchase_order?.po_number || '—'}</span></div>
            <div><span className="detail-label">Location</span><span className="detail-value">{viewingReceiving.location?.location_name || '—'}</span></div>
            <div><span className="detail-label">Receiving Date</span><span className="detail-value">{viewingReceiving.receiving_date ? new Date(viewingReceiving.receiving_date).toLocaleDateString() : '—'}</span></div>
            <div><span className="detail-label">Total Qty Received</span><span className="detail-value">{viewingReceiving.total_quantity_received ?? '—'}</span></div>
            <div><span className="detail-label">Total Qty Damaged</span><span className="detail-value" style={{ color: viewingReceiving.total_quantity_damaged > 0 ? '#ef4444' : undefined }}>{viewingReceiving.total_quantity_damaged ?? 0}</span></div>
            <div><span className="detail-label">Status</span><span className="detail-value">{viewingReceiving.status?.status_name || '—'}</span></div>
          </div>
          {viewingReceiving.details?.length > 0 && (
            <div style={{ marginTop: 16 }}>
              <h4 style={{ marginBottom: 8, color: '#374151' }}>Items Received</h4>
              <table className="data-table">
                <thead><tr><th>Product</th><th>Qty</th><th>Condition</th></tr></thead>
                <tbody>{viewingReceiving.details.map((d, i) => (
                  <tr key={i}><td>{d.product?.product_name || '—'}</td><td>{d.quantity_amount}</td><td>{d.condition || '—'}</td></tr>
                ))}</tbody>
              </table>
            </div>
          )}
          <div className="modal-footer"><button className="btn-secondary" onClick={() => setViewingReceiving(null)}>Close</button></div>
        </Modal>
      )}

      {isModalOpen && (
        <Modal title={editingReceiving ? 'Edit Receiving' : 'New Receiving'} onClose={() => setIsModalOpen(false)}>
          <form onSubmit={handleSubmit}>
            <div className="form-grid-2">
              <div className="form-group">
                <label>Purchase Order *</label>
                <select required value={formData.pc_id} onChange={e => setFormData(f => ({ ...f, pc_id: e.target.value }))}>
                  <option value="">Select PO</option>
                  {purchaseOrders.map(po => <option key={po.po_id} value={po.po_id}>{po.po_number}</option>)}
                </select>
              </div>
              <div className="form-group">
                <label>Location *</label>
                <select required value={formData.location_id} onChange={e => setFormData(f => ({ ...f, location_id: e.target.value }))}>
                  <option value="">Select location</option>
                  {locations.map(l => <option key={l.id} value={l.id}>{l.location_name || l.name}</option>)}
                </select>
              </div>
              <div className="form-group">
                <label>Receiving Number *</label>
                <input required type="text" value={formData.receiving_number} onChange={e => setFormData(f => ({ ...f, receiving_number: e.target.value }))} placeholder="e.g. RCV-2024-001" />
              </div>
              <div className="form-group">
                <label>Receiving Date *</label>
                <input required type="date" value={formData.receiving_date} onChange={e => setFormData(f => ({ ...f, receiving_date: e.target.value }))} />
              </div>
              <div className="form-group">
                <label>Damaged Qty</label>
                <input type="number" min="0" value={formData.total_quantity_damaged} onChange={e => setFormData(f => ({ ...f, total_quantity_damaged: parseInt(e.target.value, 10) || 0 }))} />
              </div>
              <div className="form-group">
                <label>Status</label>
                <select value={formData.status_id} onChange={e => setFormData(f => ({ ...f, status_id: e.target.value }))}>
                  <option value="">Select status</option>
                  {statuses.map(s => <option key={s.status_id} value={s.status_id}>{s.status_name}</option>)}
                </select>
              </div>
            </div>

            <div style={{ marginTop: 16 }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 8 }}>
                <h4 style={{ margin: 0, color: '#374151' }}>Items Received</h4>
                <button type="button" className="btn-secondary" style={{ padding: '4px 12px', fontSize: 13 }} onClick={addDetailRow}>+ Add Item</button>
              </div>
              <table className="data-table" style={{ marginBottom: 8 }}>
                <thead><tr><th>Product</th><th>Qty</th><th>Condition</th><th></th></tr></thead>
                <tbody>
                  {formData.details.map((d, i) => (
                    <tr key={i}>
                      <td>
                        <select required value={d.product_id} onChange={e => updateDetail(i, 'product_id', e.target.value)} style={{ width: '100%' }}>
                          <option value="">Select product</option>
                          {products.map(p => <option key={p.product_id || p.id} value={p.product_id || p.id}>{p.product_name || p.name}</option>)}
                        </select>
                      </td>
                      <td><input type="number" min="0" required value={d.quantity_amount} onChange={e => updateDetail(i, 'quantity_amount', e.target.value)} style={{ width: 80 }} /></td>
                      <td>
                        <select value={d.condition} onChange={e => updateDetail(i, 'condition', e.target.value)}>
                          {CONDITIONS.map(c => <option key={c} value={c}>{c}</option>)}
                        </select>
                      </td>
                      <td>{formData.details.length > 1 && <button type="button" className="btn-action btn-delete" onClick={() => removeDetailRow(i)}>✕</button>}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            <div className="modal-footer">
              <button type="button" className="btn-secondary" onClick={() => setIsModalOpen(false)}>Cancel</button>
              <button type="submit" className="btn-primary" disabled={submitting}>{submitting ? 'Saving...' : editingReceiving ? 'Update' : 'Create'}</button>
            </div>
          </form>
        </Modal>
      )}
    </AdminLayout>
  );
};

export default ReceivingManagement;
