import React, { useState, useEffect } from 'react';
import AdminLayout from '../components/AdminLayout';
import { inventoryAPI, batchAPI } from '../services/api';
import { toast } from '../utils/toast';
import '../styles/dashboard_air.css';
import '../styles/alerts_notices.css';

const AlertsNotices = () => {
  const [lowStockItems, setLowStockItems] = useState([]);
  const [pendingApprovals, setPendingApprovals] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        const res = await batchAPI.get({ include: ['inventory'] });
        const data = res?.data ?? {};
        const inventory = Array.isArray(data.inventory?.data) ? data.inventory.data : [];

        // Filter low stock items (current_stock <= reorder_level)
        const lowStock = inventory
          .filter(item => item.current_stock <= item.reorder_level && item.current_stock > 0)
          .slice(0, 10);
        setLowStockItems(lowStock);
      } catch (err) {
        console.error('Failed to fetch alerts data:', err);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  // Sample pending approvals (will be replaced with API data)
  const sampleApprovals = [
    { id: 1, type: 'Restock Request', description: 'Airking Inverter Aircon 2HP', details: 'Qty: 5' },
    { id: 2, type: 'Price Adjustment', description: 'Samsung 55" 4K Smart TV', details: 'New Price: P28,500' },
  ];

  const approvals = pendingApprovals.length > 0 ? pendingApprovals : sampleApprovals;

  const handleApprove = (id) => {
    toast.info('Approval functionality will be connected to the backend.');
  };

  const handleReject = (id) => {
    toast.info('Rejection functionality will be connected to the backend.');
  };

  return (
    <AdminLayout>
      <div className="an-page">
        {/* Header */}
        <div className="an-page-header">
          <h1 className="an-page-title">Notifications</h1>
          <p className="an-page-subtitle">System alerts for low stock, exceptions, and approvals</p>
        </div>

        {/* Low Stock Alerts */}
        <div className="an-card">
          <div className="an-card-header">
            <h3 className="an-card-title">Low Stock Alerts</h3>
            <p className="an-card-subtitle">
              {loading ? 'Loading...' : `${lowStockItems.length} items need attention`}
            </p>
          </div>

          <div className="an-alert-list">
            {lowStockItems.length === 0 && !loading ? (
              <div className="an-empty">No low stock alerts at this time</div>
            ) : (
              lowStockItems.map((item, idx) => (
                <div className="an-alert-item" key={item.id || idx}>
                  <div className="an-alert-left">
                    <span className="an-alert-name">{item.item_name || item.product_name || 'Unknown Item'}</span>
                    <span className="an-alert-location">
                      {item.branch_name || item.branch || 'N/A'} &bull; {item.warehouse_name || item.warehouse || 'Storage'}
                    </span>
                  </div>
                  <div className="an-alert-right">
                    <span className="an-alert-units">{item.current_stock} units</span>
                    <span className="an-alert-reorder">Reorder: {item.reorder_level}</span>
                  </div>
                </div>
              ))
            )}
          </div>
        </div>

        {/* Pending Approvals */}
        <div className="an-card">
          <div className="an-card-header">
            <h3 className="an-card-title">Pending Approvals</h3>
            <p className="an-card-subtitle">Actions requiring approval</p>
          </div>

          <div className="an-approval-list">
            {approvals.length === 0 ? (
              <div className="an-empty">No pending approvals</div>
            ) : (
              approvals.map((item) => (
                <div className="an-approval-item" key={item.id}>
                  <div className="an-approval-left">
                    <span className="an-approval-title">{item.type} - {item.description}</span>
                    <span className="an-approval-detail">&bull; {item.details}</span>
                  </div>
                  <div className="an-approval-actions">
                    <button className="an-btn-approve" onClick={() => handleApprove(item.id)}>Approve</button>
                    <button className="an-btn-reject" onClick={() => handleReject(item.id)}>Reject</button>
                  </div>
                </div>
              ))
            )}
          </div>
        </div>
      </div>
    </AdminLayout>
  );
};

export default AlertsNotices;
