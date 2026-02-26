import React, { useState } from 'react';
import AdminLayout from '../components/AdminLayout';
import '../styles/dashboard_air.css';
import '../styles/audit_trail.css';

const AuditTrail = () => {
  const [searchTerm, setSearchTerm] = useState('');

  const logs = [
    {
      id: 1, timestamp: '2025-12-01 10:30', operator: 'Emily Davis', operatorRole: 'MHIP-001',
      module: 'SALES', action: 'Create Sale', location: 'Main Warehouse', ip: '192.168.1.45', verified: true,
    },
    {
      id: 2, timestamp: '2025-12-01 09:15', operator: 'Sarah Johnson', operatorRole: 'AUL-007',
      module: 'INVENTORY', action: 'Adjust Inventory', location: 'Head Office', ip: '192.168.1.22', verified: true,
    },
    {
      id: 3, timestamp: '2025-11-30 16:45', operator: 'Mike Chen', operatorRole: 'MHP-001',
      module: 'TRANSFER', action: 'Create Transfer', location: 'Main Warehouse', ip: '192.168.1.30', verified: true,
    },
    {
      id: 4, timestamp: '2025-11-30 14:20', operator: 'Robert Wilson', operatorRole: 'AUD-001',
      module: 'AUDIT TRAIL', action: 'View Report', location: 'Head Office', ip: '192.168.1.25', verified: true,
    },
  ];

  const getModuleClass = (module) => {
    if (module === 'SALES') return 'at-module-sales';
    if (module === 'INVENTORY') return 'at-module-inventory';
    if (module === 'TRANSFER') return 'at-module-transfer';
    if (module === 'AUDIT TRAIL') return 'at-module-audit';
    return '';
  };

  const filteredLogs = logs.filter((log) => {
    if (!searchTerm) return true;
    const q = searchTerm.toLowerCase();
    return log.operator.toLowerCase().includes(q) ||
      log.action.toLowerCase().includes(q) ||
      log.module.toLowerCase().includes(q);
  });

  return (
    <AdminLayout>
      <div className="at-page">
        {/* Header */}
        <div className="at-page-header">
          <h1 className="at-page-title">Audit Trail</h1>
          <p className="at-page-subtitle">Comprehensive historical record of all system interactions</p>
        </div>

        {/* Search */}
        <div className="at-search-row">
          <div className="at-search-input">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="16" height="16">
              <circle cx="11" cy="11" r="8"></circle>
              <path d="m21 21-4.35-4.35"></path>
            </svg>
            <input
              type="text"
              placeholder="Search by user, action, or details..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
            />
          </div>
        </div>

        {/* Logs Table */}
        <div className="at-table-card">
          <div className="at-table-top">
            <h3>Activity Logs ({filteredLogs.length})</h3>
          </div>

          <div className="at-table-wrapper">
            <table className="at-table">
              <thead>
                <tr>
                  <th>TIMESTAMP</th>
                  <th>OPERATOR</th>
                  <th>MODULE / ACTION</th>
                  <th>LOCATION / IP</th>
                  <th>VERIFICATION</th>
                </tr>
              </thead>
              <tbody>
                {filteredLogs.map((log) => (
                  <tr key={log.id}>
                    <td className="at-cell-timestamp">{log.timestamp}</td>
                    <td>
                      <div className="at-operator-cell">
                        <span className="at-operator-name">{log.operator}</span>
                        <span className="at-operator-role">{log.operatorRole}</span>
                      </div>
                    </td>
                    <td>
                      <div className="at-module-cell">
                        <span className={`at-module-badge ${getModuleClass(log.module)}`}>{log.module}</span>
                        <span className="at-action-text">{log.action}</span>
                      </div>
                    </td>
                    <td className="at-cell-location">
                      {log.location} &bull; {log.ip}
                    </td>
                    <td>
                      {log.verified && (
                        <div className="at-verified-icon">
                          <svg viewBox="0 0 24 24" fill="none" stroke="#059669" strokeWidth="2.5" width="20" height="20">
                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                            <polyline points="22 4 12 14.01 9 11.01"></polyline>
                          </svg>
                        </div>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </AdminLayout>
  );
};

export default AuditTrail;
