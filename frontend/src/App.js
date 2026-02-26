import { Suspense, lazy } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from './admin/context/AuthContext';
import './App.css';

// Core
const Login = lazy(() => import('./admin/pages/Login'));
const Dashboard = lazy(() => import('./admin/pages/Dashboard'));

// System Setup
const UserManagement = lazy(() => import('./admin/pages/UserManagement'));
const BranchManagement = lazy(() => import('./admin/pages/BranchManagement'));
const WarehouseManagement = lazy(() => import('./admin/pages/WarehouseManagement'));
const RolePermissions = lazy(() => import('./admin/pages/RolePermissions'));
const CategoryBrandManagement = lazy(() => import('./admin/pages/CategoryBrandManagement'));

// Procurement
const ItemManagement = lazy(() => import('./admin/pages/ItemManagement'));
const SupplierNetwork = lazy(() => import('./admin/pages/SupplierNetwork'));
const PurchaseOrderManagement = lazy(() => import('./admin/pages/PurchaseOrderManagement'));
const ReceivingManagement = lazy(() => import('./admin/pages/ReceivingManagement'));

// Inventory
const InventoryManagement = lazy(() => import('./admin/pages/InventoryManagement'));
const StockTransferManagement = lazy(() => import('./admin/pages/StockTransferManagement'));
const IssuanceManagement = lazy(() => import('./admin/pages/IssuanceManagement'));
const AdjustmentManagement = lazy(() => import('./admin/pages/AdjustmentManagement'));

// Sales & Logistics
const BarcodeScan = lazy(() => import('./admin/pages/BarcodeScan'));
const CustomerManagement = lazy(() => import('./admin/pages/CustomerManagement'));
const TransactionManagement = lazy(() => import('./admin/pages/TransactionManagement'));
const DeliveryReceiptManagement = lazy(() => import('./admin/pages/DeliveryReceiptManagement'));
const PurchaseReturnManagement = lazy(() => import('./admin/pages/PurchaseReturnManagement'));

// Reports & Monitoring
const AnalyticsDashboard = lazy(() => import('./admin/pages/AnalyticsDashboard'));
const SystemReports = lazy(() => import('./admin/pages/SystemReports'));
const AuditTrail = lazy(() => import('./admin/pages/AuditTrail'));
const ProfitLossManagement = lazy(() => import('./admin/pages/ProfitLossManagement'));

// Legacy / other pages
const ApprovalQueue = lazy(() => import('./admin/pages/ApprovalQueue'));
const SystemConfiguration = lazy(() => import('./admin/pages/SystemConfiguration'));
const ArchiveManagement = lazy(() => import('./admin/pages/ArchiveManagement'));
const PORecommendation = lazy(() => import('./admin/pages/PORecommendation'));
const ComplianceReview = lazy(() => import('./admin/pages/ComplianceReview'));
const AlertsNotices = lazy(() => import('./admin/pages/AlertsNotices'));
const WarrantyManagement = lazy(() => import('./admin/pages/WarrantyManagement'));

function App() {
  return (
    <AuthProvider>
    <Router>
      <Suspense fallback={<div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh', color: '#6b7280' }}>Loading...</div>}>
        <Routes>
          <Route path="/" element={<Navigate to="/admin/login" replace />} />
          <Route path="/admin" element={<Navigate to="/admin/login" replace />} />
          <Route path="/admin/login" element={<Login />} />

          {/* Dashboard */}
          <Route path="/admin/dashboard" element={<Dashboard />} />

          {/* System Setup */}
          <Route path="/admin/users" element={<UserManagement />} />
          <Route path="/admin/branches" element={<BranchManagement />} />
          <Route path="/admin/warehouses" element={<WarehouseManagement />} />
          <Route path="/admin/roles" element={<RolePermissions />} />
          <Route path="/admin/categories" element={<CategoryBrandManagement />} />

          {/* Procurement */}
          <Route path="/admin/items" element={<ItemManagement />} />
          <Route path="/admin/suppliers" element={<SupplierNetwork />} />
          <Route path="/admin/purchase-orders" element={<PORecommendation />} />
          <Route path="/admin/receivings" element={<ReceivingManagement />} />

          {/* Inventory */}
          <Route path="/admin/inventory" element={<InventoryManagement />} />
          <Route path="/admin/transfers" element={<StockTransferManagement />} />
          <Route path="/admin/issuances" element={<IssuanceManagement />} />
          <Route path="/admin/adjustments" element={<AdjustmentManagement />} />

          {/* Sales & Logistics */}
          <Route path="/admin/scan" element={<BarcodeScan />} />
          <Route path="/admin/customers" element={<CustomerManagement />} />
          <Route path="/admin/transactions" element={<TransactionManagement />} />
          <Route path="/admin/delivery-receipts" element={<DeliveryReceiptManagement />} />
          <Route path="/admin/purchase-returns" element={<PurchaseReturnManagement />} />

          {/* Reports & Monitoring */}
          <Route path="/admin/analytics" element={<AnalyticsDashboard />} />
          <Route path="/admin/reports" element={<SystemReports />} />
          <Route path="/admin/audit" element={<AuditTrail />} />
          <Route path="/admin/profit-loss" element={<ProfitLossManagement />} />

          {/* Legacy routes */}
          <Route path="/admin/approval-queue" element={<ApprovalQueue />} />
          <Route path="/admin/config" element={<SystemConfiguration />} />
          <Route path="/admin/archive" element={<ArchiveManagement />} />
          <Route path="/admin/po-recommendations" element={<PORecommendation />} />
          <Route path="/admin/compliance" element={<ComplianceReview />} />
          <Route path="/admin/notifications" element={<AlertsNotices />} />
          <Route path="/admin/warranty" element={<WarrantyManagement />} />
        </Routes>
      </Suspense>
    </Router>
    </AuthProvider>
  );
}

export default App;
