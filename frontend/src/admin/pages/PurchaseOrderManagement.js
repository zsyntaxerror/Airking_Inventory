import React, { useState, useEffect, useCallback, useRef } from 'react';
import AdminLayout from '../components/AdminLayout';
import Modal from '../components/Modal';
import { purchaseOrdersAPI, suppliersAPI, locationsAPI, productsAPI, statusAPI } from '../services/api';
import { toast } from '../utils/toast';
import '../../admin/styles/dashboard_air.css';

const emptyDetail = () => ({ product_id: '', quantity_ordered: 1, unit_price: '' });
const emptyForm = () => ({
  supplier_id: '', location_id: '', po_number: '', order_date: '',
  expected_delivery_date: '', status_id: '', details: [emptyDetail()],
});

const PurchaseOrderManagement = () => {
  const [pos, setPos] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [currentPage, setCurrentPage] = useState(1);
  const [pagination, setPagination] = useState({ total: 0, last_page: 1 });
  const [searchTerm, setSearchTerm] = useState('');
  const [suppliers, setSuppliers] = useState([]);
  const [locations, setLocations] = useState([]);
  const [products, setProducts] = useState([]);
  const [statuses, setStatuses] = useState([]);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [viewingPO, setViewingPO] = useState(null);
  const [editingPO, setEditingPO] = useState(null);
  const [submitting, setSubmitting] = useState(false);
  const [formData, setFormData] = useState(emptyForm());
  const debounceRef = useRef(null);

  const fetchDropdowns = useCallback(async () => {
    try {
      const [supRes, locRes, prodRes, statRes] = await Promise.all([
        suppliersAPI.getAll(),
        locationsAPI.getAll(),
        productsAPI.getAll({ per_page: 500 }),
        statusAPI.getAll(),
      ]);
      setSuppliers(Array.isArray(supRes?.data) ? supRes.data : []);
      setLocations(Array.isArray(locRes?.data) ? locRes.data : []);
      setProducts(Array.isArray(prodRes?.data) ? prodRes.data : []);
      setStatuses(Array.isArray(statRes?.data) ? statRes.data : []);
    } catch (e) {
      console.error('Failed to load dropdowns:', e);
    }
  }, []);

  const fetchPOs = useCallback(async (page = 1) => {
    setLoading(true);
    try {
      const params = { page, per_page: 10 };
      if (searchTerm) params.search = searchTerm;
      const res = await purchaseOrdersAPI.getAll(params);
      setPos(Array.isArray(res?.data) ? res.data : []);
      setPagination(res?.pagination || res?.meta || { total: 0, last_page: 1 });
      setError(null);
    } catch (e) {
      setError(e.message);
    } finally {
      setLoading(false);
    }
  }, [searchTerm]);

  useEffect(() => { fetchDropdowns(); }, [fetchDropdowns]);

  useEffect(() => { fetchPOs(currentPage); }, [currentPage, fetchPOs]);

  useEffect(() => {
    if (debounceRef.current) clearTimeout(debounceRef.current);
    debounceRef.current = setTimeout(() => setCurrentPage(1), 400);
    return () => clearTimeout(debounceRef.current);
  }, [searchTerm]);

  const openAddModal = () => {
    setEditingPO(null);
    setFormData(emptyForm());
    setIsModalOpen(true);
  };

  const openEditModal = (po) => {
    setEditingPO(po);
    setFormData({
      supplier_id: po.supplier_id || '',
      location_id: po.location_id || '',
      po_number: po.po_number || '',
      order_date: po.order_date ? po.order_date.split('T')[0] : '',
      expected_delivery_date: po.expected_delivery_date ? po.expected_delivery_date.split('T')[0] : '',
      status_id: po.status_id || '',
      details: po.details?.length ? po.details.map(d => ({
        product_id: d.product_id || '',
        quantity_ordered: d.quantity_ordered || 1,
        unit_price: d.unit_price || '',
      })) : [emptyDetail()],
    });
    setIsModalOpen(true);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!formData.details.length || !formData.details[0].product_id) {
      toast.error('Add at least one product line item.');
      return;
    }
    setSubmitting(true);
    try {
      const payload = {
        ...formData,
        details: formData.details.map(d => ({
          ...d,
          quantity_ordered: parseInt(d.quantity_ordered, 10) || 1,
          unit_price: parseFloat(d.unit_price) || 0,
        })),
      };
      if (editingPO) {
        await purchaseOrdersAPI.update(editingPO.po_id, payload);
        toast.success('Purchase order updated.');
      } else {
        await purchaseOrdersAPI.create(payload);
        toast.success('Purchase order created.');
      }
      setIsModalOpen(false);
      fetchPOs(currentPage);
    } catch (e) {
      toast.error(e.message || 'Failed to save purchase order.');
    } finally {
      setSubmitting(false);
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Delete this purchase order?')) return;
    try {
      await purchaseOrdersAPI.delete(id);
      toast.success('Purchase order deleted.');
      fetchPOs(currentPage);
    } catch (e) {
      toast.error(e.message || 'Failed to delete.');
    }
  };

  const addDetailRow = () =>
    setFormData(f => ({ ...f, details: [...f.details, emptyDetail()] }));

  const removeDetailRow = (i) =>
    setFormData(f => ({ ...f, details: f.details.filter((_, idx) => idx !== i) }));

  const updateDetail = (i, field, value) =>
    setFormData(f => {
      const details = [...f.details];
      details[i] = { ...details[i], [field]: value };
      return { ...f, details };
    });

  const estimatedTotal = formData.details.reduce((sum, d) => {
    const qty = parseFloat(d.quantity_ordered) || 0;
    const price = parseFloat(d.unit_price) || 0;
    return sum + qty * price;
  }, 0);

  const now = new Date();
  const thisMonth = pos.filter(p => {
    if (!p.order_date) return false;
    const d = new Date(p.order_date);
    return d.getMonth() === now.getMonth() && d.getFullYear() === now.getFullYear();
  });

  const renderPages = () => {
    const total = pagination.last_page || 1;
    const pages = [];
    let start = Math.max(1, currentPage - 2);
    let end = Math.min(total, start + 4);
    if (end - start < 4) start = Math.max(1, end - 4);
    for (let i = start; i <= end; i++) pages.push(i);
    return pages;
  };

  return (
    <AdminLayout>
      <div className="page-container">
        <div className="page-header">
          <div>
            <h1 className="page-title">Purchase Orders</h1>
            <p className="page-subtitle">Create and manage purchase orders for suppliers</p>
          </div>
          <button className="btn-primary" onClick={openAddModal}>+ New Purchase Order</button>
        </div>

        <div className="stats-row">
          {[
            { label: 'Total POs', value: pagination.total || pos.length, color: '#6366f1' },
            { label: 'Pending', value: pos.filter(p => p.status?.status_name === 'Pending').length, color: '#f59e0b' },
            { label: 'Approved', value: pos.filter(p => p.status?.status_name === 'Approved').length, color: '#10b981' },
            { label: 'This Month', value: thisMonth.length, color: '#3b82f6' },
          ].map((s, i) => (
            <div key={i} className="stat-card">
              <div className="stat-icon" style={{ background: s.color + '20', color: s.color }}>
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="20" height="20">
                  <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                  <polyline points="14 2 14 8 20 8"></polyline>
                </svg>
              </div>
              <div>
                <div className="stat-value">{s.value}</div>
                <div className="stat-label">{s.label}</div>
              </div>
            </div>
          ))}
        </div>

        <div className="table-toolbar">
          <input
            className="search-input"
            placeholder="Search PO number..."
            value={searchTerm}
            onChange={e => setSearchTerm(e.target.value)}
          />
        </div>

        <div className="table-wrapper">
          <table className="data-table">
            <thead>
              <tr>
                <th>PO Number</th>
                <th>Supplier</th>
                <th>Location</th>
                <th>Order Date</th>
                <th>Expected Delivery</th>
                <th>Total Amount</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {loading ? (
                <tr><td colSpan="8" className="table-empty">Loading...</td></tr>
              ) : error ? (
                <tr><td colSpan="8" className="table-empty">
                  <span style={{ color: '#ef4444' }}>{error}</span>
                  <button className="btn-link" onClick={() => fetchPOs(currentPage)} style={{ marginLeft: 8 }}>Retry</button>
                </td></tr>
              ) : pos.length === 0 ? (
                <tr><td colSpan="8" className="table-empty">No purchase orders found.</td></tr>
              ) : pos.map(po => (
                <tr key={po.po_id}>
                  <td><span className="badge badge-blue">{po.po_number}</span></td>
                  <td>{po.supplier?.name || po.supplier?.supplier_name || '—'}</td>
                  <td>{po.location?.location_name || po.location?.name || '—'}</td>
                  <td>{po.order_date ? new Date(po.order_date).toLocaleDateString() : '—'}</td>
                  <td>{po.expected_delivery_date ? new Date(po.expected_delivery_date).toLocaleDateString() : '—'}</td>
                  <td>₱{parseFloat(po.grand_total || po.total_amount || 0).toLocaleString('en-PH', { minimumFractionDigits: 2 })}</td>
                  <td><span className={`badge ${po.status?.status_name === 'Approved' ? 'badge-green' : po.status?.status_name === 'Pending' ? 'badge-yellow' : 'badge-gray'}`}>{po.status?.status_name || 'N/A'}</span></td>
                  <td>
                    <div className="action-btns">
                      <button className="btn-action btn-view" onClick={() => setViewingPO(po)}>View</button>
                      <button className="btn-action btn-edit" onClick={() => openEditModal(po)}>Edit</button>
                      <button className="btn-action btn-delete" onClick={() => handleDelete(po.po_id)}>Delete</button>
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
            {renderPages().map(p => (
              <button key={p} className={`page-btn ${p === currentPage ? 'active' : ''}`} onClick={() => setCurrentPage(p)}>{p}</button>
            ))}
            <button className="page-btn" disabled={currentPage === pagination.last_page} onClick={() => setCurrentPage(p => p + 1)}>Next</button>
          </div>
        )}
      </div>

      {/* View Modal */}
      {viewingPO && (
        <Modal title={`PO: ${viewingPO.po_number}`} onClose={() => setViewingPO(null)}>
          <div className="detail-grid">
            <div><span className="detail-label">Supplier</span><span className="detail-value">{viewingPO.supplier?.name || viewingPO.supplier?.supplier_name || '—'}</span></div>
            <div><span className="detail-label">Location</span><span className="detail-value">{viewingPO.location?.location_name || '—'}</span></div>
            <div><span className="detail-label">Order Date</span><span className="detail-value">{viewingPO.order_date ? new Date(viewingPO.order_date).toLocaleDateString() : '—'}</span></div>
            <div><span className="detail-label">Expected Delivery</span><span className="detail-value">{viewingPO.expected_delivery_date ? new Date(viewingPO.expected_delivery_date).toLocaleDateString() : '—'}</span></div>
            <div><span className="detail-label">Total Amount</span><span className="detail-value">₱{parseFloat(viewingPO.grand_total || viewingPO.total_amount || 0).toLocaleString('en-PH', { minimumFractionDigits: 2 })}</span></div>
            <div><span className="detail-label">Status</span><span className="detail-value">{viewingPO.status?.status_name || '—'}</span></div>
          </div>
          {viewingPO.details?.length > 0 && (
            <div style={{ marginTop: 16 }}>
              <h4 style={{ marginBottom: 8, color: '#374151' }}>Line Items</h4>
              <table className="data-table">
                <thead><tr><th>Product</th><th>Qty</th><th>Unit Price</th><th>Subtotal</th></tr></thead>
                <tbody>
                  {viewingPO.details.map((d, i) => (
                    <tr key={i}>
                      <td>{d.product?.product_name || d.product?.name || '—'}</td>
                      <td>{d.quantity_ordered}</td>
                      <td>₱{parseFloat(d.unit_price || 0).toLocaleString('en-PH', { minimumFractionDigits: 2 })}</td>
                      <td>₱{parseFloat(d.subtotal || (d.quantity_ordered * d.unit_price) || 0).toLocaleString('en-PH', { minimumFractionDigits: 2 })}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
          <div className="modal-footer"><button className="btn-secondary" onClick={() => setViewingPO(null)}>Close</button></div>
        </Modal>
      )}

      {/* Add/Edit Modal */}
      {isModalOpen && (
        <Modal title={editingPO ? 'Edit Purchase Order' : 'New Purchase Order'} onClose={() => setIsModalOpen(false)}>
          <form onSubmit={handleSubmit}>
            <div className="form-grid-2">
              <div className="form-group">
                <label>Supplier *</label>
                <select required value={formData.supplier_id} onChange={e => setFormData(f => ({ ...f, supplier_id: e.target.value }))}>
                  <option value="">Select supplier</option>
                  {suppliers.map(s => <option key={s.id} value={s.id}>{s.name || s.supplier_name}</option>)}
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
                <label>PO Number *</label>
                <input required type="text" value={formData.po_number} onChange={e => setFormData(f => ({ ...f, po_number: e.target.value }))} placeholder="e.g. PO-2024-001" />
              </div>
              <div className="form-group">
                <label>Order Date *</label>
                <input required type="date" value={formData.order_date} onChange={e => setFormData(f => ({ ...f, order_date: e.target.value }))} />
              </div>
              <div className="form-group">
                <label>Expected Delivery</label>
                <input type="date" value={formData.expected_delivery_date} onChange={e => setFormData(f => ({ ...f, expected_delivery_date: e.target.value }))} />
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
                <h4 style={{ margin: 0, color: '#374151' }}>Line Items</h4>
                <button type="button" className="btn-secondary" style={{ padding: '4px 12px', fontSize: 13 }} onClick={addDetailRow}>+ Add Item</button>
              </div>
              <table className="data-table" style={{ marginBottom: 8 }}>
                <thead><tr><th>Product</th><th>Qty</th><th>Unit Price</th><th></th></tr></thead>
                <tbody>
                  {formData.details.map((d, i) => (
                    <tr key={i}>
                      <td>
                        <select required value={d.product_id} onChange={e => updateDetail(i, 'product_id', e.target.value)} style={{ width: '100%' }}>
                          <option value="">Select product</option>
                          {products.map(p => <option key={p.product_id || p.id} value={p.product_id || p.id}>{p.product_name || p.name}</option>)}
                        </select>
                      </td>
                      <td><input type="number" min="1" required value={d.quantity_ordered} onChange={e => updateDetail(i, 'quantity_ordered', e.target.value)} style={{ width: 80 }} /></td>
                      <td><input type="number" min="0" step="0.01" required value={d.unit_price} onChange={e => updateDetail(i, 'unit_price', e.target.value)} style={{ width: 100 }} placeholder="0.00" /></td>
                      <td>{formData.details.length > 1 && <button type="button" className="btn-action btn-delete" onClick={() => removeDetailRow(i)}>✕</button>}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
              <div style={{ textAlign: 'right', fontWeight: 600, color: '#374151' }}>
                Estimated Total: ₱{estimatedTotal.toLocaleString('en-PH', { minimumFractionDigits: 2 })}
              </div>
            </div>

            <div className="modal-footer">
              <button type="button" className="btn-secondary" onClick={() => setIsModalOpen(false)}>Cancel</button>
              <button type="submit" className="btn-primary" disabled={submitting}>{submitting ? 'Saving...' : editingPO ? 'Update' : 'Create'}</button>
            </div>
          </form>
        </Modal>
      )}
    </AdminLayout>
  );
};

export default PurchaseOrderManagement;
