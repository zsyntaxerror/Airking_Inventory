import React, { useState } from 'react';
import AdminLayout from '../components/AdminLayout';
import '../styles/approval_queue.css';

const ApprovalQueue = () => {
  const [activeTab, setActiveTab] = useState('purchase-orders');

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
    },
    {
      id: 2,
      po_number: 'PO-2025-5679',
      supplier: 'LG Electronics',
      amount: 434985,
      prepared_by: 'Sarah Johnson',
      date: '2025-11-29 11:30',
      status: 'pending',
    },
  ]);

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

  const handlePOAction = (id, action) => {
    setPurchaseOrders(prev =>
      prev.map(po =>
        po.id === id ? { ...po, status: action === 'approve' ? 'authorized' : 'rejected' } : po
      )
    );
  };

  const handleRestockAction = (id, action) => {
    setRestockRequests(prev =>
      prev.map(req =>
        req.id === id ? { ...req, status: action === 'approve' ? 'approved' : 'denied' } : req
      )
    );
  };

  return (
    <AdminLayout>
      <div className="aq-content">
        {/* Page Header */}
        <div className="aq-page-header">
          <h1>Approval Queue</h1>
          <p>Final authorization for POs, Restocks, and Branch Transfers</p>
        </div>

        {/* Tab Navigation */}
        <div className="aq-tabs">
          <button
            className={`aq-tab-btn ${activeTab === 'purchase-orders' ? 'active' : ''}`}
            onClick={() => setActiveTab('purchase-orders')}
          >
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
              <polyline points="14 2 14 8 20 8"></polyline>
            </svg>
            Purchase Orders
          </button>
          <button
            className={`aq-tab-btn ${activeTab === 'restock-requests' ? 'active' : ''}`}
            onClick={() => setActiveTab('restock-requests')}
          >
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <polyline points="23 4 23 10 17 10"></polyline>
              <polyline points="1 20 1 14 7 14"></polyline>
              <path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"></path>
            </svg>
            Restock Requests
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
                        <button className="aq-btn-reject" onClick={() => handlePOAction(po.id, 'reject')}>
                          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <circle cx="12" cy="12" r="10"></circle>
                            <line x1="15" y1="9" x2="9" y2="15"></line>
                            <line x1="9" y1="9" x2="15" y2="15"></line>
                          </svg>
                          REJECT
                        </button>
                        <button className="aq-btn-approve" onClick={() => handlePOAction(po.id, 'approve')}>
                          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                            <polyline points="22 4 12 14.01 9 11.01"></polyline>
                          </svg>
                          APPROVE
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
