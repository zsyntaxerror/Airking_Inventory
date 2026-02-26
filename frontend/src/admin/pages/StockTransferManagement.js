import React, { useState, useEffect, useCallback, useRef } from 'react';
import AdminLayout from '../components/AdminLayout';
import Modal from '../components/Modal';
import { transfersAPI, locationsAPI, productsAPI, statusAPI } from '../services/api';
import { toast } from '../utils/toast';
import '../../admin/styles/dashboard_air.css';

const emptyDetail = () => ({ product_id: '', quantity_transferred: 1 });
const emptyForm = () => ({
  from_location_id: '', to_location_id: '', transfer_number: '',
  transfer_date: '', status_id: '', details: [emptyDetail()],
});

const StockTransferManagement = () => {
  const [transfers, setTransfers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [currentPage, setCurrentPage] = useState(1);
  const [pagination, setPagination] = useState({ total: 0, last_page: 1 });
  const [searchTerm, setSearchTerm] = useState('');
  const [locations, setLocations] = useState([]);
  const [products, setProducts] = useState([]);
  const [statuses, setStatuses] = useState([]);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [viewingTransfer, setViewingTransfer] = useState(null);
  const [editingTransfer, setEditingTransfer] = useState(null);
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

  const fetchTransfers = useCallback(async (page = 1) => {
    setLoading(true);
    try {
      const params = { page, per_page: 10 };
      if (searchTerm) params.search = searchTerm;
      const res = await transfersAPI.getAll(params);
      setTransfers(Array.isArray(res?.data) ? res.data : []);
      setPagination(res?.pagination || res?.meta || { total: 0, last_page: 1 });
      setError(null);
    } catch (e) { setError(e.message); } finally { setLoading(false); }
  }, [searchTerm]);

  useEffect(() => { fetchDropdowns(); }, [fetchDropdowns]);
  useEffect(() => { fetchTransfers(currentPage); }, [currentPage, fetchTransfers]);
  useEffect(() => {
    if (debounceRef.current) clearTimeout(debounceRef.current);
    debounceRef.current = setTimeout(() => setCurrentPage(1), 400);
    return () => clearTimeout(debounceRef.current);
  }, [searchTerm]);

  const openAddModal = () => { setEditingTransfer(null); setFormData(emptyForm()); setIsModalOpen(true); };
  const openEditModal = (t) => {
    setEditingTransfer(t);
    setFormData({
      from_location_id: t.from_location_id || '',
      to_location_id: t.to_location_id || '',
      transfer_number: t.transfer_number || '',
      transfer_date: t.transfer_date ? t.transfer_date.split('T')[0] : '',
      status_id: t.status_id || '',
      details: t.details?.length ? t.details.map(d => ({
        product_id: d.product_id || '', quantity_transferred: d.quantity_transferred || 1,
      })) : [emptyDetail()],
    });
    setIsModalOpen(true);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (formData.from_location_id && formData.from_location_id === formData.to_location_id) {
      toast.error('From and To locations must be different.');
      return;
    }
    if (!formData.details[0]?.product_id) { toast.error('Add at least one product.'); return; }
    setSubmitting(true);
    try {
      const payload = {
        ...formData,
        details: formData.details.map(d => ({ ...d, quantity_transferred: parseInt(d.quantity_transferred, 10) || 1 })),
      };
      if (editingTransfer) {
        await transfersAPI.update(editingTransfer.transfer_id, payload);
        toast.success('Transfer updated.');
      } else {
        await transfersAPI.create(payload);
        toast.success('Transfer created. Stock moved.');
      }
      setIsModalOpen(false); fetchTransfers(currentPage);
    } catch (e) { toast.error(e.message || 'Failed to save.'); } finally { setSubmitting(false); }
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Delete this transfer record?')) return;
    try { await transfersAPI.delete(id); toast.success('Deleted.'); fetchTransfers(currentPage); }
    catch (e) { toast.error(e.message || 'Failed to delete.'); }
  };

  const addDetailRow = () => setFormData(f => ({ ...f, details: [...f.details, emptyDetail()] }));
  const removeDetailRow = (i) => setFormData(f => ({ ...f, details: f.details.filter((_, idx) => idx !== i) }));
  const updateDetail = (i, field, value) => setFormData(f => {
    const details = [...f.details]; details[i] = { ...details[i], [field]: value }; return { ...f, details };
  });

  const printTransfer = (t) => {
    const fromLoc  = t.from_location?.location_name || t.fromLocation?.location_name || '—';
    const toLoc    = t.to_location?.location_name   || t.toLocation?.location_name   || '—';
    const tDate    = t.transfer_date
      ? new Date(t.transfer_date).toLocaleDateString('en-US', { month: 'long', day: '2-digit', year: 'numeric' }).toUpperCase()
      : new Date().toLocaleDateString('en-US', { month: 'long', day: '2-digit', year: 'numeric' }).toUpperCase();
    const items    = t.details || [];
    const blankCount = Math.max(0, 18 - items.length);

    const itemRows = items.map(d => `
      <tr>
        <td class="tc">${d.quantity_transferred || ''}</td>
        <td>${d.product?.product_name || d.product?.product_code || ''}</td>
        <td></td>
      </tr>`).join('') + Array(blankCount).fill(`<tr><td>&nbsp;</td><td></td><td></td></tr>`).join('');

    const html = `<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8"/>
<title>Transfer ${t.transfer_number}</title>
<style>
  *{margin:0;padding:0;box-sizing:border-box;}
  body{font-family:Arial,Helvetica,sans-serif;font-size:11.5px;color:#000;padding:28px 36px;}
  .co-name{font-size:13px;font-weight:bold;}
  .co-addr{font-size:10px;margin:1px 0;}
  .header-row{display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:12px;}
  .doc-block{text-align:right;}
  .doc-title{font-size:13px;font-weight:bold;letter-spacing:0.1em;text-align:center;margin:8px 0 2px;}
  .no-badge{font-size:13px;font-weight:bold;color:#c00;}
  .from-to{display:grid;grid-template-columns:1fr 1fr;gap:4px 16px;margin:10px 0;font-size:11.5px;}
  .ft-row{display:flex;gap:6px;align-items:flex-end;}
  .ft-lbl{font-weight:bold;white-space:nowrap;font-size:11px;}
  .ft-val{border-bottom:1px solid #000;flex:1;font-size:11.5px;padding-bottom:1px;}
  table.items{width:100%;border-collapse:collapse;margin-top:4px;}
  table.items th{border:1px solid #000;padding:4px 8px;font-size:10.5px;text-align:center;font-weight:bold;}
  table.items td{border:1px solid #000;padding:3px 8px;font-size:11px;height:20px;}
  .tc{text-align:center;}
  .sigs{display:flex;justify-content:space-between;margin-top:16px;}
  .sig-left{width:40%;}
  .sig-right{width:50%;}
  .sig-line{display:flex;gap:6px;align-items:flex-end;margin-bottom:10px;}
  .sig-line .lbl{font-size:10.5px;font-weight:bold;white-space:nowrap;}
  .sig-line .line{border-bottom:1px solid #000;flex:1;}
  .rcvd-txt{font-size:10.5px;font-weight:bold;margin-bottom:8px;}
  .rcvd-sub{font-size:9.5px;}
  @media print{body{padding:15px 20px;}@page{size:A4 portrait;margin:10mm;}}
</style>
</head>
<body>
  <div class="header-row">
    <div>
      <div class="co-name">PARAMOND INC.</div>
      <div class="co-addr">Zone 5, Lower Bulua, Cagayan De Oro City</div>
      <div class="co-addr">Email: mta.paramond@gmail.com</div>
    </div>
    <div class="doc-block">
      <div class="doc-title">INTERBRANCH STOCK TRANSFER</div>
      <div class="no-badge">No. ${t.transfer_number}</div>
    </div>
  </div>

  <div class="from-to">
    <div class="ft-row"><span class="ft-lbl">FROM:</span><span class="ft-val">${fromLoc}</span></div>
    <div class="ft-row"><span class="ft-lbl">DATE:</span><span class="ft-val">${tDate}</span></div>
    <div class="ft-row"><span class="ft-lbl">TO:</span><span class="ft-val">${toLoc}</span></div>
    <div class="ft-row"><span class="ft-lbl">MR #:</span><span class="ft-val"></span></div>
  </div>

  <table class="items">
    <thead>
      <tr>
        <th style="width:80px;">QUANTITY</th>
        <th>MODEL</th>
        <th style="width:160px;">SERIAL NO.</th>
      </tr>
    </thead>
    <tbody>${itemRows}</tbody>
  </table>

  <div class="sigs">
    <div class="sig-left">
      <div class="sig-line"><span class="lbl">Prepared by:</span><span class="line"></span></div>
      <div class="sig-line"><span class="lbl">Approved by:</span><span class="line"></span></div>
    </div>
    <div class="sig-right">
      <div class="rcvd-txt">Received the goods in order and condition</div>
      <div class="sig-line"><span class="line"></span></div>
      <div class="rcvd-sub">Receiver's Signature over Printed Name</div>
    </div>
  </div>
</body>
</html>`;

    const win = window.open('', '_blank', 'width=860,height=750');
    win.document.write(html);
    win.document.close();
    win.focus();
    setTimeout(() => win.print(), 600);
  };

  const now = new Date();
  const thisMonth = transfers.filter(t => {
    if (!t.transfer_date) return false;
    const d = new Date(t.transfer_date);
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
            <h1 className="page-title">Stock Transfer</h1>
            <p className="page-subtitle">Transfer inventory between warehouse locations</p>
          </div>
          <button className="btn-primary" onClick={openAddModal}>+ New Transfer</button>
        </div>

        <div className="stats-row">
          {[
            { label: 'Total Transfers', value: pagination.total || transfers.length, color: '#6366f1' },
            { label: 'Pending', value: transfers.filter(t => t.status?.status_name === 'Pending').length, color: '#f59e0b' },
            { label: 'Completed', value: transfers.filter(t => ['Completed', 'Received'].includes(t.status?.status_name)).length, color: '#10b981' },
            { label: 'This Month', value: thisMonth.length, color: '#3b82f6' },
          ].map((s, i) => (
            <div key={i} className="stat-card">
              <div className="stat-icon" style={{ background: s.color + '20', color: s.color }}>
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="20" height="20">
                  <path d="M17 3l4 4-4 4"></path><path d="M3 7h18"></path>
                  <path d="M7 21l-4-4 4-4"></path><path d="M21 17H3"></path>
                </svg>
              </div>
              <div><div className="stat-value">{s.value}</div><div className="stat-label">{s.label}</div></div>
            </div>
          ))}
        </div>

        <div className="table-toolbar">
          <input className="search-input" placeholder="Search transfer number..." value={searchTerm} onChange={e => setSearchTerm(e.target.value)} />
        </div>

        <div className="table-wrapper">
          <table className="data-table">
            <thead>
              <tr><th>Transfer #</th><th>From</th><th>To</th><th>Date</th><th>Items</th><th>Status</th><th>Actions</th></tr>
            </thead>
            <tbody>
              {loading ? <tr><td colSpan="7" className="table-empty">Loading...</td></tr>
                : error ? <tr><td colSpan="7" className="table-empty"><span style={{ color: '#ef4444' }}>{error}</span><button className="btn-link" onClick={() => fetchTransfers(currentPage)} style={{ marginLeft: 8 }}>Retry</button></td></tr>
                  : transfers.length === 0 ? <tr><td colSpan="7" className="table-empty">No transfer records found.</td></tr>
                    : transfers.map(t => (
                      <tr key={t.transfer_id}>
                        <td><span className="badge badge-blue">{t.transfer_number}</span></td>
                        <td>{t.from_location?.location_name || t.fromLocation?.location_name || '—'}</td>
                        <td>{t.to_location?.location_name || t.toLocation?.location_name || '—'}</td>
                        <td>{t.transfer_date ? new Date(t.transfer_date).toLocaleDateString() : '—'}</td>
                        <td>{t.details?.length ?? t.total_quantity_transferred ?? '—'}</td>
                        <td><span className={`badge ${t.status?.status_name === 'Completed' || t.status?.status_name === 'Received' ? 'badge-green' : t.status?.status_name === 'Pending' ? 'badge-yellow' : 'badge-gray'}`}>{t.status?.status_name || 'N/A'}</span></td>
                        <td>
                          <div className="action-btns">
                            <button className="btn-action btn-view" onClick={() => setViewingTransfer(t)}>View</button>
                            <button className="btn-action" style={{ background: '#f0fdf4', color: '#059669', border: '1px solid #bbf7d0' }} onClick={() => printTransfer(t)}>Print</button>
                            <button className="btn-action btn-edit" onClick={() => openEditModal(t)}>Edit</button>
                            <button className="btn-action btn-delete" onClick={() => handleDelete(t.transfer_id)}>Delete</button>
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

      {viewingTransfer && (
        <Modal title={`Transfer: ${viewingTransfer.transfer_number}`} onClose={() => setViewingTransfer(null)}>
          <div className="detail-grid">
            <div><span className="detail-label">From Location</span><span className="detail-value">{viewingTransfer.from_location?.location_name || viewingTransfer.fromLocation?.location_name || '—'}</span></div>
            <div><span className="detail-label">To Location</span><span className="detail-value">{viewingTransfer.to_location?.location_name || viewingTransfer.toLocation?.location_name || '—'}</span></div>
            <div><span className="detail-label">Transfer Date</span><span className="detail-value">{viewingTransfer.transfer_date ? new Date(viewingTransfer.transfer_date).toLocaleDateString() : '—'}</span></div>
            <div><span className="detail-label">Status</span><span className="detail-value">{viewingTransfer.status?.status_name || '—'}</span></div>
          </div>
          {viewingTransfer.details?.length > 0 && (
            <div style={{ marginTop: 16 }}>
              <h4 style={{ marginBottom: 8, color: '#374151' }}>Items Transferred</h4>
              <table className="data-table">
                <thead><tr><th>Product</th><th>Qty Transferred</th></tr></thead>
                <tbody>{viewingTransfer.details.map((d, i) => (
                  <tr key={i}><td>{d.product?.product_name || '—'}</td><td>{d.quantity_transferred}</td></tr>
                ))}</tbody>
              </table>
            </div>
          )}
          <div className="modal-footer">
            <button className="btn-secondary" onClick={() => setViewingTransfer(null)}>Close</button>
            <button className="btn-primary" onClick={() => printTransfer(viewingTransfer)}>Print Transfer</button>
          </div>
        </Modal>
      )}

      {isModalOpen && (
        <Modal title={editingTransfer ? 'Edit Transfer' : 'New Stock Transfer'} onClose={() => setIsModalOpen(false)}>
          <form onSubmit={handleSubmit}>
            <div className="form-grid-2">
              <div className="form-group">
                <label>From Location *</label>
                <select required value={formData.from_location_id} onChange={e => setFormData(f => ({ ...f, from_location_id: e.target.value }))}>
                  <option value="">Select source location</option>
                  {locations.map(l => <option key={l.id} value={l.id}>{l.location_name || l.name}</option>)}
                </select>
              </div>
              <div className="form-group">
                <label>To Location *</label>
                <select required value={formData.to_location_id} onChange={e => setFormData(f => ({ ...f, to_location_id: e.target.value }))}>
                  <option value="">Select destination location</option>
                  {locations.map(l => <option key={l.id} value={l.id}>{l.location_name || l.name}</option>)}
                </select>
              </div>
              <div className="form-group">
                <label>Transfer Number *</label>
                <input required type="text" value={formData.transfer_number} onChange={e => setFormData(f => ({ ...f, transfer_number: e.target.value }))} placeholder="e.g. TRF-2024-001" />
              </div>
              <div className="form-group">
                <label>Transfer Date *</label>
                <input required type="date" value={formData.transfer_date} onChange={e => setFormData(f => ({ ...f, transfer_date: e.target.value }))} />
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
                <h4 style={{ margin: 0, color: '#374151' }}>Items to Transfer</h4>
                <button type="button" className="btn-secondary" style={{ padding: '4px 12px', fontSize: 13 }} onClick={addDetailRow}>+ Add Item</button>
              </div>
              <table className="data-table">
                <thead><tr><th>Product</th><th>Qty to Transfer</th><th></th></tr></thead>
                <tbody>
                  {formData.details.map((d, i) => (
                    <tr key={i}>
                      <td>
                        <select required value={d.product_id} onChange={e => updateDetail(i, 'product_id', e.target.value)} style={{ width: '100%' }}>
                          <option value="">Select product</option>
                          {products.map(p => <option key={p.product_id || p.id} value={p.product_id || p.id}>{p.product_name || p.name}</option>)}
                        </select>
                      </td>
                      <td><input type="number" min="1" required value={d.quantity_transferred} onChange={e => updateDetail(i, 'quantity_transferred', e.target.value)} style={{ width: 100 }} /></td>
                      <td>{formData.details.length > 1 && <button type="button" className="btn-action btn-delete" onClick={() => removeDetailRow(i)}>✕</button>}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            <div className="modal-footer">
              <button type="button" className="btn-secondary" onClick={() => setIsModalOpen(false)}>Cancel</button>
              <button type="submit" className="btn-primary" disabled={submitting}>{submitting ? 'Saving...' : editingTransfer ? 'Update' : 'Create'}</button>
            </div>
          </form>
        </Modal>
      )}
    </AdminLayout>
  );
};

export default StockTransferManagement;
