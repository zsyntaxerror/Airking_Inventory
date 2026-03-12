/**
 * Role-Based Access Control helpers
 * Role names come from the DB seeder: admin, inventory_analyst, branch_manager, warehouse_personnel, auditor
 */

export const ROLES = {
  ADMIN: 'admin',
  INVENTORY_ANALYST: 'inventory_analyst',
  BRANCH_MANAGER: 'branch_manager',
  WAREHOUSE_PERSONNEL: 'warehouse_personnel',
  AUDITOR: 'auditor',
};

/** Normalize whatever the API returns into a known key */
export const getRoleKey = (user) => {
  const raw = user?.role?.role_name || user?.role || '';
  const normalized = raw.toLowerCase().trim();
  const found = Object.values(ROLES).find((r) => r === normalized);
  return found || ROLES.ADMIN; // fallback to admin (unrestricted) if unknown
};

export const ROLE_META = {
  [ROLES.ADMIN]: {
    label: 'System Administrator',
    accent: '#dc2626',        // red (existing brand)
    dashboardTitle: 'System Dashboard',
    dashboardSubtitle: 'System-wide statistics and overall health monitoring.',
  },
  [ROLES.INVENTORY_ANALYST]: {
    label: 'Inventory Analyst',
    accent: '#7c3aed',        // purple
    dashboardTitle: 'Inventory Analytics',
    dashboardSubtitle: 'Real-time inventory performance, stock valuation, and trend analysis.',
  },
  [ROLES.BRANCH_MANAGER]: {
    label: 'Branch Manager',
    accent: '#059669',        // green
    dashboardTitle: 'Branch Dashboard',
    dashboardSubtitle: 'Monitor branch-level operations, transactions, and inventory.',
  },
  [ROLES.WAREHOUSE_PERSONNEL]: {
    label: 'Warehouse Personnel',
    accent: '#2563eb',        // blue
    dashboardTitle: 'Warehouse Operations',
    dashboardSubtitle: 'Daily tasks, receiving, transfers, and assigned inventory at a glance.',
  },
  [ROLES.AUDITOR]: {
    label: 'Auditor',
    accent: '#d97706',        // amber/orange
    dashboardTitle: 'Audit Dashboard',
    dashboardSubtitle: 'System audit logs, user activity, and compliance monitoring.',
  },
};

/**
 * Role-specific sidebar menus.
 * Each item: { name, path, icon }
 * Admin uses the full menuSections array in AdminLayout directly.
 */
export const ROLE_MENUS = {
  [ROLES.ADMIN]: null, // null = show all sections (handled in AdminLayout)

  [ROLES.INVENTORY_ANALYST]: [
    {
      label: 'INVENTORY',
      items: [
        { name: 'Dashboard', path: '/admin/dashboard', icon: 'dashboard' },
        { name: 'Inventory Monitoring', path: '/admin/inventory', icon: 'inventory' },
        { name: 'Restocking Recommendation', path: '/admin/purchase-orders', icon: 'restocking' },
        { name: 'Inventory Valuation', path: '/admin/profit-loss', icon: 'profitloss' },
        { name: 'Issue Inventory', path: '/admin/issuances', icon: 'issuance' },
      ],
    },
    {
      label: 'REPORTS',
      items: [
        { name: 'Transactions', path: '/admin/transactions', icon: 'transactions' },
        { name: 'System Reports', path: '/admin/reports', icon: 'reports' },
        { name: 'Audit Trail', path: '/admin/audit', icon: 'audit' },
      ],
    },
  ],

  [ROLES.AUDITOR]: [
    {
      label: 'AUDIT & COMPLIANCE',
      items: [
        { name: 'Dashboard', path: '/admin/dashboard', icon: 'dashboard' },
        { name: 'Audit Trail', path: '/admin/audit', icon: 'audit' },
        { name: 'Transaction Logs', path: '/admin/transactions', icon: 'transactions' },
      ],
    },
    {
      label: 'REPORTS',
      items: [
        { name: 'Inventory Reports', path: '/admin/inventory', icon: 'inventory' },
        { name: 'System Reports', path: '/admin/reports', icon: 'reports' },
      ],
    },
  ],

  [ROLES.BRANCH_MANAGER]: [
    {
      label: 'BRANCH OPERATIONS',
      items: [
        { name: 'Dashboard', path: '/admin/dashboard', icon: 'dashboard' },
        { name: 'Branch Inventory', path: '/admin/inventory', icon: 'inventory' },
        { name: 'Transfer Requests', path: '/admin/transfers', icon: 'transfer' },
        { name: 'Issue Inventory', path: '/admin/issuances', icon: 'issuance' },
      ],
    },
    {
      label: 'SALES & REPORTS',
      items: [
        { name: 'Transactions', path: '/admin/transactions', icon: 'transactions' },
        { name: 'Branch Reports', path: '/admin/reports', icon: 'reports' },
        { name: 'Audit Trail', path: '/admin/audit', icon: 'audit' },
      ],
    },
  ],

  [ROLES.WAREHOUSE_PERSONNEL]: [
    {
      label: 'WAREHOUSE TASKS',
      items: [
        { name: 'Dashboard', path: '/admin/dashboard', icon: 'dashboard' },
        { name: 'Scan Barcode', path: '/admin/scan', icon: 'barcode' },
        { name: 'Receive Inventory', path: '/admin/receivings', icon: 'receiving' },
        { name: 'Issue Inventory', path: '/admin/issuances', icon: 'issuance' },
        { name: 'Process Transfer', path: '/admin/transfers', icon: 'transfer' },
        { name: 'Assigned Inventory', path: '/admin/inventory', icon: 'inventory' },
      ],
    },
  ],
};
