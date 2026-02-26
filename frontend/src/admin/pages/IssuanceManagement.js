import React, { useState, useEffect, useCallback, useRef } from 'react';
import AdminLayout from '../components/AdminLayout';
import Modal from '../components/Modal';
import { issuancesAPI, locationsAPI, productsAPI, statusAPI } from '../services/api';
import { toast } from '../utils/toast';
import '../../admin/styles/dashboard_air.css';

const ISSUANCE_TYPES = ['Internal', 'Maintenance', 'Operations', 'Office Use', 'Other'];
const emptyDetail = () => ({ product_id: '', quantity_issued: 1, condition_issued: 'Good' });
const emptyForm = () => ({
  location_id: '', issuance_date: '', issuance_type: 'Internal',
  purpose: '', expected_return_date: '', status_id: '', details: [emptyDetail()],
});

const IssuanceManagement = () => {
  const [issuances, setIssuances] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [currentPage, setCurrentPage] = useState(1);
  const [pagination, setPagination] = useState({ total: 0, last_page: 1 });
  const [searchTerm, setSearchTerm] = useState('');
  const [filterType, setFilterType] = useState('');
  const [locations, setLocations] = useState([]);
  const [products, setProducts] = useState([]);
  const [statuses, setStatuses] = useState([]);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [viewingIssuance, setViewingIssuance] = useState(null);
  const [editingIssuance, setEditingIssuance] = useState(null);
  const [submitting, setSubmitting] = useState(false);
  const [formData, setFormData] = useState(emptyForm());
  const debounceRef = useRef(null);

  const fetchDropdowns = useCallback(async () => {
    try {
      const [locRes, prodRes, statRes] = await Promise.all([
        locationsAPI.getAll(), productsAPI.getAll({ per_page: 500 }), statusAPI.getAll(),
      ]);
      setLocations(Array.isArray(locRes?.data) ? locRes.data : []);
      setProducts(Array.isArray(prodRes?.data) ? prodRes.data : []);
      setStatuses(Array.isArray(statRes?.data) ? statRes.data : []);
    } catch (e) { console.error(e); }
  }, []);

  const fetchIssuances = useCallback(async (page = 1) => {
    setLoading(true);
    try {
      const params = { page, per_page: 10 };
      if (searchTerm) params.search = searchTerm;
      if (filterType) params.issuance_type = filterType;
      const res = await issuancesAPI.getAll(params);
      setIssuances(Array.isArray(res?.data) ? res.data : []);
      setPagination(res?.pagination || res?.meta || { total: 0, last_page: 1 });
      setError(null);
    } catch (e) { setError(e.message); } finally { setLoading(false); }
  }, [searchTerm, filterType]);

  useEffect(() => { fetchDropdowns(); }, [fetchDropdowns]);
  useEffect(() => { fetchIssuances(currentPage); }, [currentPage, fetchIssuances]);
  useEffect(() => {
    if (debounceRef.current) clearTimeout(debounceRef.current);
    debounceRef.current = setTimeout(() => setCurrentPage(1), 400);
    return () => clearTimeout(debounceRef.current);
  }, [searchTerm, filterType]);

  const openAddModal = () => { setEditingIssuance(null); setFormData(emptyForm()); setIsModalOpen(true); };
  const openEditModal = (item) => {
    setEditingIssuance(item);
    setFormData({
      location_id: item.location_id || '',
      issuance_date: item.issuance_date ? item.issuance_date.split('T')[0] : '',
      issuance_type: item.issuance_type || 'Internal',
      purpose: item.purpose || '',
      expected_return_date: item.expected_return_date ? item.expected_return_date.split('T')[0] : '',
      status_id: item.status_id || '',
      details: item.details?.length ? item.details.map(d => ({
        product_id: d.product_id || '', quantity_issued: d.quantity_issued || 1, condition_issued: d.condition_issued || 'Good',
      })) : [emptyDetail()],
    });
    setIsModalOpen(true);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!formData.details[0]?.product_id) { toast.error('Add at least one product.'); return; }
    setSubmitting(true);
    try {
      const payload = { ...formData, details: formData.details.map(d => ({ ...d, quantity_issued: parseInt(d.quantity_issued, 10) || 1 })) };
      if (editingIssuance) {
        await issuancesAPI.update(editingIssuance.issuance_id, payload);
        toast.success('Issuance updated.');
      } else {
        await issuancesAPI.create(payload);
        toast.success('Issuance created. Stock deducted.');
      }
      setIsModalOpen(false); fetchIssuances(currentPage);
    } catch (e) { toast.error(e.message || 'Failed to save.'); } finally { setSubmitting(false); }
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Delete this issuance record?')) return;
    try { await issuancesAPI.delete(id); toast.success('Deleted.'); fetchIssuances(currentPage); }
    catch (e) { toast.error(e.message || 'Failed to delete.'); }
  };

  const addDetailRow = () => setFormData(f => ({ ...f, details: [...f.details, emptyDetail()] }));
  const removeDetailRow = (i) => setFormData(f => ({ ...f, details: f.details.filter((_, idx) => idx !== i) }));
  const updateDetail = (i, field, value) => setFormData(f => {
    const details = [...f.details]; details[i] = { ...details[i], [field]: value }; return { ...f, details };
  });

  const now = new Date();
  const thisMonth = issuances.filter(iss => {
    if (!iss.issuance_date) return false;
    const d = new Date(iss.issuance_date);
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
            <h1 className="page-title">Issuance for Internal Use</h1>
            <p className="page-subtitle">Issue stock for internal operations, maintenance, and office use</p>
          </div>
          <button className="btn-primary" onClick={openAddModal}>+ New Issuance</button>
        </div>

        <div className="stats-row">
          {[
            { label: 'Total Issuances', value: pagination.total || issuances.length, color: '#6366f1' },
            { label: 'Internal', value: issuances.filter(i => i.issuance_type === 'Internal').length, color: '#8b5cf6' },
            { label: 'Maintenance/Ops', value: issuances.filter(i => ['Maintenance', 'Operations'].includes(i.issuance_type)).length, color: '#f59e0b' },
            { label: 'This Month', value: thisMonth.length, color: '#10b981' },
          ].map((s, i) => (
            <div key={i} className="stat-card">
              <div className="stat-icon" style={{ background: s.color + '20', color: s.color }}>
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="20" height="20">
                  <polyline points="9 11 12 14 22 4"></polyline>
                  <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
                </svg>
              </div>
              <div><div className="stat-value">{s.value}</div><div className="stat-label">{s.label}</div></div>
            </div>
          ))}
        </div>

        <div className="table-toolbar">
          <input className="search-input" placeholder="Search issuance number..." value={searchTerm} onChange={e => setSearchTerm(e.target.value)} />
          <select className="filter-select" value={filterType} onChange={e => setFilterType(e.target.value)}>
            <option value="">All Types</option>
            {ISSUANCE_TYPES.map(t => <option key={t} value={t}>{t}</option>)}
          </select>
        </div>

        <div className="table-wrapper">
          <table className="data-table">
            <thead>
              <tr><th>Issuance #</th><th>Type</th><th>Location</th><th>Date</th><th>Purpose</th><th>Items</th><th>Status</th><th>Actions</th></tr>
            </thead>
            <tbody>
              {loading ? <tr><td colSpan="8" className="table-empty">Loading...</td></tr>
                : error ? <tr><td colSpan="8" className="table-empty"><span style={{ color: '#ef4444' }}>{error}</span><button className="btn-link" onClick={() => fetchIssuances(currentPage)} style={{ marginLeft: 8 }}>Retry</button></td></tr>
                  : issuances.length === 0 ? <tr><td colSpan="8" className="table-empty">No issuance records found.</td></tr>
                    : issuances.map(iss => (
                      <tr key={iss.issuance_id}>
                        <td><span className="badge badge-blue">{iss.issuance_number || `ISS-${iss.issuance_id}`}</span></td>
                        <td><span className="badge badge-gray">{iss.issuance_type}</span></td>
                        <td>{iss.location?.location_name || '—'}</td>
                        <td>{iss.issuance_date ? new Date(iss.issuance_date).toLocaleDateString() : '—'}</td>
                        <td style={{ maxWidth: 180, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{iss.purpose || '—'}</td>
                        <td>{iss.details?.length ?? '—'}</td>
                        <td><span className={`badge ${iss.status?.status_name === 'Approved' ? 'badge-green' : 'badge-yellow'}`}>{iss.status?.status_name || 'N/A'}</span></td>
                        <td>
                          <div className="action-btns">
                            <button className="btn-action btn-view" onClick={() => setViewingIssuance(iss)}>View</button>
                            <button className="btn-action btn-edit" onClick={() => openEditModal(iss)}>Edit</button>
                            <button className="btn-action btn-delete" onClick={() => handleDelete(iss.issuance_id)}>Delete</button>
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

      {viewingIssuance && (
        <Modal title={`Issuance: ${viewingIssuance.issuance_number || `ISS-${viewingIssuance.issuance_id}`}`} onClose={() => setViewingIssuance(null)}>
          <div className="detail-grid">
            <div><span className="detail-label">Type</span><span className="detail-value">{viewingIssuance.issuance_type}</span></div>
            <div><span className="detail-label">Location</span><span className="detail-value">{viewingIssuance.location?.location_name || '—'}</span></div>
            <div><span className="detail-label">Date</span><span className="detail-value">{viewingIssuance.issuance_date ? new Date(viewingIssuance.issuance_date).toLocaleDateString() : '—'}</span></div>
            <div><span className="detail-label">Purpose</span><span className="detail-value">{viewingIssuance.purpose || '—'}</span></div>
            <div><span className="detail-label">Expected Return</span><span className="detail-value">{viewingIssuance.expected_return_date ? new Date(viewingIssuance.expected_return_date).toLocaleDateString() : '—'}</span></div>
            <div><span className="detail-label">Status</span><span className="detail-value">{viewingIssuance.status?.status_name || '—'}</span></div>
          </div>
          {viewingIssuance.details?.length > 0 && (
            <div style={{ marginTop: 16 }}>
              <h4 style={{ marginBottom: 8, color: '#374151' }}>Items Issued</h4>
              <table className="data-table">
                <thead><tr><th>Product</th><th>Qty</th><th>Condition</th></tr></thead>
                <tbody>{viewingIssuance.details.map((d, i) => (
                  <tr key={i}><td>{d.product?.product_name || '—'}</td><td>{d.quantity_issued}</td><td>{d.condition_issued || '—'}</td></tr>
                ))}</tbody>
              </table>
            </div>
          )}
          <div className="modal-footer"><button className="btn-secondary" onClick={() => setViewingIssuance(null)}>Close</button></div>
        </Modal>
      )}

      {isModalOpen && (
        <Modal title={editingIssuance ? 'Edit Issuance' : 'New Issuance'} onClose={() => setIsModalOpen(false)}>
          <form onSubmit={handleSubmit}>
            <div className="form-grid-2">
              <div className="form-group">
                <label>Location *</label>
                <select required value={formData.location_id} onChange={e => setFormData(f => ({ ...f, location_id: e.target.value }))}>
                  <option value="">Select location</option>
                  {locations.map(l => <option key={l.id} value={l.id}>{l.location_name || l.name}</option>)}
                </select>
              </div>
              <div className="form-group">
                <label>Issuance Date *</label>
                <input required type="date" value={formData.issuance_date} onChange={e => setFormData(f => ({ ...f, issuance_date: e.target.value }))} />
              </div>
              <div className="form-group">
                <label>Type *</label>
                <select required value={formData.issuance_type} onChange={e => setFormData(f => ({ ...f, issuance_type: e.target.value }))}>
                  {ISSUANCE_TYPES.map(t => <option key={t} value={t}>{t}</option>)}
                </select>
              </div>
              <div className="form-group">
                <label>Expected Return Date</label>
                <input type="date" value={formData.expected_return_date} onChange={e => setFormData(f => ({ ...f, expected_return_date: e.target.value }))} />
              </div>
              <div className="form-group" style={{ gridColumn: '1 / -1' }}>
                <label>Purpose</label>
                <textarea rows="2" value={formData.purpose} onChange={e => setFormData(f => ({ ...f, purpose: e.target.value }))} placeholder="Describe the purpose of this issuance..." style={{ resize: 'vertical' }} />
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
                <h4 style={{ margin: 0, color: '#374151' }}>Items to Issue</h4>
                <button type="button" className="btn-secondary" style={{ padding: '4px 12px', fontSize: 13 }} onClick={addDetailRow}>+ Add Item</button>
              </div>
              <table className="data-table">
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
                      <td><input type="number" min="1" required value={d.quantity_issued} onChange={e => updateDetail(i, 'quantity_issued', e.target.value)} style={{ width: 80 }} /></td>
                      <td>
                        <select value={d.condition_issued} onChange={e => updateDetail(i, 'condition_issued', e.target.value)}>
                          {['Good', 'Fair', 'Damaged'].map(c => <option key={c} value={c}>{c}</option>)}
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
              <button type="submit" className="btn-primary" disabled={submitting}>{submitting ? 'Saving...' : editingIssuance ? 'Update' : 'Create'}</button>
            </div>
          </form>
        </Modal>
      )}
    </AdminLayout>
  );
};

export default IssuanceManagement;
