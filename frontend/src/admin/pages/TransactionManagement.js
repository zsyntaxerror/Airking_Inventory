import React, { useState, useEffect, useCallback, useRef } from 'react';
import AdminLayout from '../components/AdminLayout';
import Modal from '../components/Modal';
import { transactionsAPI, itemsAPI } from '../services/api';
import { toast } from '../utils/toast';
import '../styles/dashboard_air.css';
import '../styles/transaction_management.css';

const TransactionManagement = () => {
  const [transactions, setTransactions] = useState([]);
  const [items, setItems] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [currentPage, setCurrentPage] = useState(1);
  const [pagination, setPagination] = useState({ total: 0, last_page: 1 });
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingTransaction, setEditingTransaction] = useState(null);
  const [viewingTransaction, setViewingTransaction] = useState(null);
  const [filters, setFilters] = useState({ type: '', status: '', dateFrom: '', dateTo: '' });
  const [searchTerm, setSearchTerm] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const rowsPerPage = 10;
  const debounceRef = useRef(null);

  const [formData, setFormData] = useState({
    transaction_id: '', date: '', type: '', status: 'Pending',
    item_name: '', quantity: '', unit_price: '', total_amount: '', notes: ''
  });

  // Fetch products from Product Management for the item dropdown
  useEffect(() => {
    const fetchItems = async () => {
      try {
        const res = await itemsAPI.getAll({ per_page: 500 });
        setItems(Array.isArray(res.data) ? res.data : []);
      } catch (err) {
        console.error('Failed to fetch items:', err);
      }
    };
    fetchItems();
  }, []);

  const fetchTransactions = useCallback(async (page = 1) => {
    try {
      setLoading(true);
      const params = { page, per_page: rowsPerPage };
      if (searchTerm) params.search = searchTerm;
      if (filters.type) params.type = filters.type;
      if (filters.status) params.status = filters.status;
      if (filters.dateFrom) params.date_from = filters.dateFrom;
      if (filters.dateTo) params.date_to = filters.dateTo;
      const res = await transactionsAPI.getAll(params);
      setTransactions(Array.isArray(res.data) ? res.data : []);
      setPagination(res.pagination || { total: 0, last_page: 1 });
      setError(null);
    } catch (err) {
      setError(err.message);
      console.error('Failed to fetch transactions:', err);
    } finally {
      setLoading(false);
    }
  }, [searchTerm, filters, rowsPerPage]);

  useEffect(() => {
    fetchTransactions(currentPage);
  }, [currentPage, fetchTransactions]);

  // Debounce search/filter changes
  useEffect(() => {
    if (debounceRef.current) clearTimeout(debounceRef.current);
    debounceRef.current = setTimeout(() => {
      setCurrentPage(1);
    }, 400);
    return () => clearTimeout(debounceRef.current);
  }, [searchTerm, filters]);

  // Auto-calculate total amount
  useEffect(() => {
    if (formData.quantity && formData.unit_price) {
      const total = parseFloat(formData.quantity) * parseFloat(formData.unit_price);
      setFormData((prev) => ({ ...prev, total_amount: total.toFixed(2) }));
    }
  }, [formData.quantity, formData.unit_price]);

  const handleAdd = () => {
    setEditingTransaction(null);
    setFormData({
      transaction_id: '', date: new Date().toISOString().split('T')[0],
      type: '', status: 'Pending', item_name: '', quantity: '', unit_price: '', total_amount: '', notes: ''
    });
    setIsModalOpen(true);
  };

  const handleEdit = (transaction) => {
    if (transaction.status === 'Completed') {
      toast.warning('Completed transactions cannot be edited.');
      return;
    }
    setEditingTransaction(transaction);
    setFormData({
      transaction_id: transaction.transaction_id || '',
      date: transaction.date || '',
      type: transaction.type || '',
      status: transaction.status || '',
      item_name: transaction.item_name || transaction.item?.name || '',
      quantity: transaction.quantity || '',
      unit_price: transaction.unit_price || '',
      total_amount: transaction.total_amount || '',
      notes: transaction.notes || ''
    });
    setIsModalOpen(true);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setSubmitting(true);
    try {
      const payload = {
        transaction_id: formData.transaction_id,
        date: formData.date,
        type: formData.type,
        item_name: formData.item_name,
        quantity: parseInt(formData.quantity),
        unit_price: parseFloat(formData.unit_price),
        total_amount: parseFloat(formData.total_amount),
        status: formData.status,
        notes: formData.notes
      };
      if (editingTransaction) {
        await transactionsAPI.update(editingTransaction.id, payload);
        toast.success('Transaction updated successfully!');
      } else {
        await transactionsAPI.create(payload);
        toast.success('Transaction created successfully!');
      }
      setIsModalOpen(false);
      fetchTransactions(currentPage);
    } catch (err) {
      toast.error(err.errors ? Object.values(err.errors).flat().join(', ') : err.message);
    } finally {
      setSubmitting(false);
    }
  };

  // When user selects an item, auto-fill price
  const handleItemSelect = (e) => {
    const selectedName = e.target.value;
    setFormData(prev => ({ ...prev, item_name: selectedName }));
    const match = items.find(i => (i.product_name || i.name) === selectedName);
    if (match) {
      const price = parseFloat(match.unit_price || match.price || 0);
      setFormData(prev => ({ ...prev, unit_price: price || prev.unit_price }));
    }
  };

  const getTxnId = (t) => t.transaction_id || `TXN-${t.id}`;
  const getTxnItem = (t) => t.item_name || t.item?.name || t.product?.product_name || 'N/A';
  const getTxnAmount = (t) => parseFloat(t.total_amount || 0);

  const totalTransactions = pagination.total || 0;
  const totalPages = pagination.last_page || 1;

  const getStatusClass = (status) => {
    if (status === 'Completed') return 'txn-status-completed';
    if (status === 'Pending') return 'txn-status-pending';
    if (status === 'Cancelled') return 'txn-status-cancelled';
    return '';
  };

  const getTypeClass = (type) => {
    if (type === 'Sale') return 'txn-type-sale';
    if (type === 'Purchase') return 'txn-type-purchase';
    if (type === 'Transfer') return 'txn-type-transfer';
    if (type === 'Restock') return 'txn-type-restock';
    if (type === 'Adjustment') return 'txn-type-adjustment';
    return '';
  };

  // Unique product names from Product Management for dropdown
  const itemOptions = [...new Set(items.map(i => i.product_name || i.name).filter(Boolean))];

  return (
    <AdminLayout>
      <div className="txn-page">
        <div className="txn-page-header">
          <div className="txn-page-header-left">
            <h1>Transaction Management</h1>
            <p>Create and manage stock transactions including sales, purchases, and adjustments</p>
          </div>
          <button className="txn-btn-create" onClick={handleAdd}>+ New Transaction</button>
        </div>

        {/* Stats Cards */}
        <div className="txn-stats-row">
          <div className="txn-stat-card">
            <div className="txn-stat-icon txn-stat-icon-blue">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#3b82f6" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
            </div>
            <div className="txn-stat-info">
              <span className="txn-stat-label">Total Transactions</span>
              <span className="txn-stat-number">{totalTransactions}</span>
            </div>
          </div>
          <div className="txn-stat-card">
            <div className="txn-stat-icon txn-stat-icon-green">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#22c55e" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
            </div>
            <div className="txn-stat-info">
              <span className="txn-stat-label">Completed</span>
              <span className="txn-stat-number">{transactions.filter(t => t.status === 'Completed').length}</span>
            </div>
          </div>
          <div className="txn-stat-card">
            <div className="txn-stat-icon txn-stat-icon-orange">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
            </div>
            <div className="txn-stat-info">
              <span className="txn-stat-label">Pending</span>
              <span className="txn-stat-number">{transactions.filter(t => t.status === 'Pending').length}</span>
            </div>
          </div>
          <div className="txn-stat-card">
            <div className="txn-stat-icon txn-stat-icon-purple">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#8b5cf6" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
            </div>
            <div className="txn-stat-info">
              <span className="txn-stat-label">Total Value</span>
              <span className="txn-stat-number">&#8369;{transactions.reduce((sum, t) => sum + getTxnAmount(t), 0).toLocaleString('en-PH', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</span>
            </div>
          </div>
        </div>

        {loading && <div className="txn-loading">Loading transactions...</div>}
        {error && <div className="txn-error">Error: {error}</div>}

        {/* Table Section */}
        <div className="txn-table-card">
          <div className="txn-table-top">
            <div className="txn-table-title">
              <h3>Transaction List</h3>
              <p>{totalTransactions} transactions total</p>
            </div>
            <div className="txn-table-actions-top">
              <button className="txn-btn-export" onClick={() => toast.info('Exporting transactions data...')}>Export</button>
              <button className="txn-btn-print" onClick={() => window.print()}>Print</button>
            </div>
          </div>

          {/* Search + Filters */}
          <div className="txn-filter-row">
            <div className="txn-search-input">
              <input type="text" placeholder="Search by Transaction ID or Item Name..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} />
            </div>
            <div className="txn-filter-group">
              <select value={filters.type} onChange={(e) => setFilters({...filters, type: e.target.value})}>
                <option value="">All Types</option>
                <option value="Sale">Sale (Stock Out)</option>
                <option value="Purchase">Purchase (Stock In)</option>
                <option value="Transfer">Transfer</option>
                <option value="Restock">Restock (Stock In)</option>
                <option value="Adjustment">Adjustment</option>
              </select>
              <select value={filters.status} onChange={(e) => setFilters({...filters, status: e.target.value})}>
                <option value="">All Status</option>
                <option value="Completed">Completed</option>
                <option value="Pending">Pending</option>
                <option value="Cancelled">Cancelled</option>
              </select>
              <input type="date" className="txn-filter-date" value={filters.dateFrom} onChange={(e) => setFilters({...filters, dateFrom: e.target.value})} placeholder="From" title="Date From" />
              <input type="date" className="txn-filter-date" value={filters.dateTo} onChange={(e) => setFilters({...filters, dateTo: e.target.value})} placeholder="To" title="Date To" />
              <button className="txn-btn-reset" onClick={() => setFilters({ type: '', status: '', dateFrom: '', dateTo: '' })}>Reset</button>
            </div>
          </div>

          <div className="txn-table-wrapper">
            <table className="txn-table">
              <thead>
                <tr>
                  <th>TXN ID</th>
                  <th>DATE</th>
                  <th>TYPE</th>
                  <th>ITEM NAME</th>
                  <th>QTY</th>
                  <th>UNIT PRICE</th>
                  <th>TOTAL AMOUNT</th>
                  <th>STATUS</th>
                  <th>ACTIONS</th>
                </tr>
              </thead>
              <tbody>
                {transactions.length === 0 ? (
                  <tr><td colSpan="9" style={{ textAlign: 'center', color: '#999', padding: '40px' }}>{loading ? 'Loading...' : 'No transactions found'}</td></tr>
                ) : (
                  transactions.map(txn => (
                    <tr key={txn.id}>
                      <td className="txn-cell-id">{getTxnId(txn)}</td>
                      <td>{txn.date || 'N/A'}</td>
                      <td><span className={`txn-type-badge ${getTypeClass(txn.type)}`}>{txn.type || 'N/A'}</span></td>
                      <td className="txn-cell-name">{getTxnItem(txn)}</td>
                      <td>{txn.quantity || 0}</td>
                      <td className="txn-cell-price">&#8369;{parseFloat(txn.unit_price || 0).toLocaleString('en-PH', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</td>
                      <td className="txn-cell-price">&#8369;{getTxnAmount(txn).toLocaleString('en-PH', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</td>
                      <td><span className={`txn-status-badge ${getStatusClass(txn.status)}`}>{txn.status}</span></td>
                      <td>
                        <div className="txn-cell-actions">
                          <button className="txn-btn-view" onClick={() => setViewingTransaction(txn)}>View</button>
                          {txn.status !== 'Completed' && txn.status !== 'Cancelled' && (
                            <button className="txn-btn-edit" onClick={() => handleEdit(txn)}>Edit</button>
                          )}
                        </div>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>

          {/* Pagination */}
          {totalPages > 1 && (
            <div className="txn-pagination">
              <button disabled={currentPage === 1} onClick={() => setCurrentPage(currentPage - 1)}>Previous</button>
              {Array.from({ length: totalPages }, (_, i) => i + 1).map(page => (
                <button key={page} className={currentPage === page ? 'active' : ''} onClick={() => setCurrentPage(page)}>{page}</button>
              ))}
              <button disabled={currentPage === totalPages || totalPages === 0} onClick={() => setCurrentPage(currentPage + 1)}>Next</button>
            </div>
          )}
        </div>

        {/* View Modal */}
        {viewingTransaction && (
          <Modal isOpen={!!viewingTransaction} onClose={() => setViewingTransaction(null)} title="Transaction Details">
            <div className="txn-view-details">
              <div className="form-row">
                <div className="form-group"><label>Transaction ID</label><p>{getTxnId(viewingTransaction)}</p></div>
                <div className="form-group"><label>Date</label><p>{viewingTransaction.date || 'N/A'}</p></div>
              </div>
              <div className="form-row">
                <div className="form-group"><label>Type</label><p><span className={`txn-type-badge ${getTypeClass(viewingTransaction.type)}`}>{viewingTransaction.type}</span></p></div>
                <div className="form-group"><label>Status</label><p><span className={`txn-status-badge ${getStatusClass(viewingTransaction.status)}`}>{viewingTransaction.status}</span></p></div>
              </div>
              <div className="form-row">
                <div className="form-group"><label>Item Name</label><p>{getTxnItem(viewingTransaction)}</p></div>
                <div className="form-group"><label>Quantity</label><p>{viewingTransaction.quantity || 0}</p></div>
              </div>
              <div className="form-row">
                <div className="form-group"><label>Unit Price</label><p>&#8369;{parseFloat(viewingTransaction.unit_price || 0).toLocaleString('en-PH', { minimumFractionDigits: 2 })}</p></div>
                <div className="form-group"><label>Total Amount</label><p>&#8369;{getTxnAmount(viewingTransaction).toLocaleString('en-PH', { minimumFractionDigits: 2 })}</p></div>
              </div>
              {viewingTransaction.notes && (
                <div className="form-group"><label>Notes</label><p>{viewingTransaction.notes}</p></div>
              )}
              <div className="modal-footer">
                <button type="button" className="btn-cancel" onClick={() => setViewingTransaction(null)}>Close</button>
                {viewingTransaction.status !== 'Completed' && viewingTransaction.status !== 'Cancelled' && (
                  <button type="button" className="btn-save" onClick={() => { setViewingTransaction(null); handleEdit(viewingTransaction); }}>Edit</button>
                )}
              </div>
            </div>
          </Modal>
        )}

        {/* Add/Edit Modal */}
        <Modal isOpen={isModalOpen} onClose={() => setIsModalOpen(false)} title={editingTransaction ? 'Edit Transaction' : 'New Transaction'}>
          <form onSubmit={handleSubmit}>
            <div className="form-row">
              <div className="form-group">
                <label>Transaction ID</label>
                <input type="text" value={formData.transaction_id} onChange={(e) => setFormData({...formData, transaction_id: e.target.value})} placeholder="Auto-generated if empty" />
              </div>
              <div className="form-group">
                <label>Date *</label>
                <input type="date" value={formData.date} onChange={(e) => setFormData({...formData, date: e.target.value})} required />
              </div>
            </div>
            <div className="form-row">
              <div className="form-group">
                <label>Type *</label>
                <select value={formData.type} onChange={(e) => setFormData({...formData, type: e.target.value})} required>
                  <option value="">Select Type</option>
                  <option value="Sale">Sale (Stock Out)</option>
                  <option value="Purchase">Purchase (Stock In)</option>
                  <option value="Transfer">Transfer</option>
                  <option value="Restock">Restock (Stock In)</option>
                  <option value="Adjustment">Adjustment</option>
                </select>
              </div>
              <div className="form-group">
                <label>Status *</label>
                <select value={formData.status} onChange={(e) => setFormData({...formData, status: e.target.value})} required>
                  <option value="Pending">Pending</option>
                  <option value="Completed">Completed</option>
                  <option value="Cancelled">Cancelled</option>
                </select>
              </div>
            </div>
            <div className="form-group">
              <label>Item *</label>
              <select value={formData.item_name} onChange={handleItemSelect} required>
                <option value="">Select Item</option>
                {itemOptions.map(name => (
                  <option key={name} value={name}>{name}</option>
                ))}
              </select>
            </div>
            <div className="form-row">
              <div className="form-group">
                <label>Quantity *</label>
                <input type="number" min="1" value={formData.quantity} onChange={(e) => setFormData({...formData, quantity: e.target.value})} required />
              </div>
              <div className="form-group">
                <label>Unit Price (&#8369;) *</label>
                <input type="number" step="0.01" value={formData.unit_price} onChange={(e) => setFormData({...formData, unit_price: e.target.value})} required />
              </div>
            </div>
            <div className="form-group">
              <label>Total Amount (&#8369;)</label>
              <input type="number" step="0.01" value={formData.total_amount} readOnly className="txn-readonly" />
            </div>
            <div className="form-group">
              <label>Notes</label>
              <textarea rows="3" value={formData.notes} onChange={(e) => setFormData({...formData, notes: e.target.value})} placeholder="Add notes about this transaction..."></textarea>
            </div>

            {formData.type === 'Sale' && (
              <div className="txn-info-box txn-info-stockout">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                <span>This transaction will <strong>deduct stock</strong> from inventory when marked as Completed.</span>
              </div>
            )}
            {(formData.type === 'Purchase' || formData.type === 'Restock') && (
              <div className="txn-info-box txn-info-stockin">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                <span>This transaction will <strong>add stock</strong> to inventory when marked as Completed.</span>
              </div>
            )}

            <div className="modal-footer">
              <button type="button" className="btn-cancel" onClick={() => setIsModalOpen(false)}>Cancel</button>
              <button type="submit" className="btn-save" disabled={submitting}>
                {submitting ? 'Saving...' : (editingTransaction ? 'Update Transaction' : 'Create Transaction')}
              </button>
            </div>
          </form>
        </Modal>
      </div>
    </AdminLayout>
  );
};

export default TransactionManagement;
