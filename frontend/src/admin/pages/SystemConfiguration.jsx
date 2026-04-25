import React, { useEffect, useState } from 'react';
import AdminLayout from '../components/AdminLayout';
import { systemConfigAPI } from '../services/api';
import { toast } from '../utils/toast';
import '../styles/system_configuration.css';

const DEFAULT_SETTINGS = {
  companyName: 'Airking Air Conditioning',
  systemEmail: 'system@airking.com',
  timeZone: 'Asia/Manila',
  currency: 'PHP',
  reorderLevel: '20',
  safetyStock: '10',
  autoGenerateSKU: true,
  lowStockAlerts: true,
  twoFactorAuth: false,
  sessionTimeout: false,
  passwordExpiry: false,
  loginAttempts: true,
  emailNotifications: true,
  dailyReports: true,
  transactionAlerts: false,
  notificationRecipients: 'admin@airking.com, manager@airking.com',
};

const SystemConfiguration = () => {
  const [settings, setSettings] = useState(DEFAULT_SETTINGS);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    let mounted = true;
    const load = async () => {
      setLoading(true);
      try {
        const res = await systemConfigAPI.get();
        const payload = res?.data || {};
        if (!mounted) return;
        setSettings({
          ...DEFAULT_SETTINGS,
          ...payload,
          reorderLevel: String(payload?.reorderLevel ?? DEFAULT_SETTINGS.reorderLevel),
          safetyStock: String(payload?.safetyStock ?? DEFAULT_SETTINGS.safetyStock),
        });
      } catch (err) {
        if (!mounted) return;
        toast.error(err.message || 'Failed to load system configuration.');
      } finally {
        if (mounted) setLoading(false);
      }
    };
    load();
    return () => { mounted = false; };
  }, []);

  const handleChange = (field, value) => {
    setSettings(prev => ({ ...prev, [field]: value }));
  };

  const handleToggle = (field) => {
    setSettings(prev => ({ ...prev, [field]: !prev[field] }));
  };

  const handleResetDefaults = () => {
    setSettings(DEFAULT_SETTINGS);
  };

  const handleSave = async () => {
    setSaving(true);
    try {
      const payload = {
        ...settings,
        reorderLevel: Number(settings.reorderLevel || 0),
        safetyStock: Number(settings.safetyStock || 0),
      };
      await systemConfigAPI.update(payload);
      toast.success('Settings saved successfully!');
    } catch (err) {
      toast.error(err.message || 'Failed to save settings.');
    } finally {
      setSaving(false);
    }
  };

  return (
    <AdminLayout>
      <div className="sc-content">
        {/* Page Header */}
        <div className="sc-page-header">
          <h1>System Configuration</h1>
          <p>Manage system settings and operational parameters</p>
        </div>

        {/* Settings Grid */}
        {loading ? (
          <div className="sc-card"><div className="sc-card-body">Loading configuration...</div></div>
        ) : (
        <div className="sc-grid">
          {/* Left Column */}
          <div className="sc-column">
            {/* General Settings */}
            <div className="sc-card">
              <div className="sc-card-header">
                <h3>General Settings</h3>
                <p>Basic system configuration</p>
              </div>
              <div className="sc-card-body">
                <div className="sc-field">
                  <label>Company Name</label>
                  <input
                    type="text"
                    value={settings.companyName}
                    onChange={(e) => handleChange('companyName', e.target.value)}
                  />
                </div>
                <div className="sc-field">
                  <label>System Email</label>
                  <input
                    type="email"
                    value={settings.systemEmail}
                    onChange={(e) => handleChange('systemEmail', e.target.value)}
                  />
                </div>
                <div className="sc-field">
                  <label>Time Zone</label>
                  <select
                    value={settings.timeZone}
                    onChange={(e) => handleChange('timeZone', e.target.value)}
                  >
                    <option value="">Select Time Zone</option>
                    <option value="Asia/Manila">Asia/Manila (GMT+8)</option>
                    <option value="Asia/Singapore">Asia/Singapore (GMT+8)</option>
                    <option value="Asia/Tokyo">Asia/Tokyo (GMT+9)</option>
                    <option value="UTC">UTC (GMT+0)</option>
                  </select>
                </div>
                <div className="sc-field">
                  <label>Currency</label>
                  <select
                    value={settings.currency}
                    onChange={(e) => handleChange('currency', e.target.value)}
                  >
                    <option value="">Select Currency</option>
                    <option value="PHP">Philippine Peso (₱)</option>
                    <option value="USD">US Dollar ($)</option>
                    <option value="EUR">Euro (€)</option>
                  </select>
                </div>
              </div>
            </div>

            {/* Inventory Settings */}
            <div className="sc-card">
              <div className="sc-card-header">
                <h3>Inventory Settings</h3>
                <p>Stock and reorder configuration</p>
              </div>
              <div className="sc-card-body">
                <div className="sc-field">
                  <label>Default Reorder Level (%)</label>
                  <input
                    type="number"
                    value={settings.reorderLevel}
                    onChange={(e) => handleChange('reorderLevel', e.target.value)}
                  />
                </div>
                <div className="sc-field">
                  <label>Safety Stock (%)</label>
                  <input
                    type="number"
                    value={settings.safetyStock}
                    onChange={(e) => handleChange('safetyStock', e.target.value)}
                  />
                </div>
                <div className="sc-toggle-row">
                  <div className="sc-toggle-info">
                    <span className="sc-toggle-label">Auto-generate SKU</span>
                    <span className="sc-toggle-desc">Automatically create SKU codes</span>
                  </div>
                  <button
                    className={`sc-toggle ${settings.autoGenerateSKU ? 'active' : ''}`}
                    onClick={() => handleToggle('autoGenerateSKU')}
                  >
                    <span className="sc-toggle-knob"></span>
                  </button>
                </div>
                <div className="sc-toggle-row">
                  <div className="sc-toggle-info">
                    <span className="sc-toggle-label">Low Stock Alerts</span>
                    <span className="sc-toggle-desc">Email notifications for low stock</span>
                  </div>
                  <button
                    className={`sc-toggle ${settings.lowStockAlerts ? 'active' : ''}`}
                    onClick={() => handleToggle('lowStockAlerts')}
                  >
                    <span className="sc-toggle-knob"></span>
                  </button>
                </div>
              </div>
            </div>
          </div>

          {/* Right Column */}
          <div className="sc-column">
            {/* Security Settings */}
            <div className="sc-card">
              <div className="sc-card-header">
                <h3>Security Settings</h3>
                <p>Access control and authentication</p>
              </div>
              <div className="sc-card-body">
                <div className="sc-toggle-row">
                  <div className="sc-toggle-info">
                    <span className="sc-toggle-label">Two-Factor Authentication</span>
                    <span className="sc-toggle-desc">Require 2FA for all users</span>
                  </div>
                  <button
                    className={`sc-toggle ${settings.twoFactorAuth ? 'active' : ''}`}
                    onClick={() => handleToggle('twoFactorAuth')}
                  >
                    <span className="sc-toggle-knob"></span>
                  </button>
                </div>
                <div className="sc-toggle-row">
                  <div className="sc-toggle-info">
                    <span className="sc-toggle-label">Session Timeout</span>
                    <span className="sc-toggle-desc">Automatic logout after inactivity</span>
                  </div>
                  <button
                    className={`sc-toggle ${settings.sessionTimeout ? 'active' : ''}`}
                    onClick={() => handleToggle('sessionTimeout')}
                  >
                    <span className="sc-toggle-knob"></span>
                  </button>
                </div>
                <div className="sc-toggle-row">
                  <div className="sc-toggle-info">
                    <span className="sc-toggle-label">Password Expiry</span>
                    <span className="sc-toggle-desc">Force password change every</span>
                  </div>
                  <button
                    className={`sc-toggle ${settings.passwordExpiry ? 'active' : ''}`}
                    onClick={() => handleToggle('passwordExpiry')}
                  >
                    <span className="sc-toggle-knob"></span>
                  </button>
                </div>
                <div className="sc-toggle-row">
                  <div className="sc-toggle-info">
                    <span className="sc-toggle-label">Login Attempts</span>
                    <span className="sc-toggle-desc">Lock account after failed attempts</span>
                  </div>
                  <button
                    className={`sc-toggle dark ${settings.loginAttempts ? 'active' : ''}`}
                    onClick={() => handleToggle('loginAttempts')}
                  >
                    <span className="sc-toggle-knob"></span>
                  </button>
                </div>
              </div>
            </div>

            {/* Notification Settings */}
            <div className="sc-card">
              <div className="sc-card-header">
                <h3>Notification Settings</h3>
                <p>Email and alert configuration</p>
              </div>
              <div className="sc-card-body">
                <div className="sc-toggle-row">
                  <div className="sc-toggle-info">
                    <span className="sc-toggle-label">Email Notifications</span>
                    <span className="sc-toggle-desc">Send email alerts</span>
                  </div>
                  <button
                    className={`sc-toggle ${settings.emailNotifications ? 'active' : ''}`}
                    onClick={() => handleToggle('emailNotifications')}
                  >
                    <span className="sc-toggle-knob"></span>
                  </button>
                </div>
                <div className="sc-toggle-row">
                  <div className="sc-toggle-info">
                    <span className="sc-toggle-label">Daily Reports</span>
                    <span className="sc-toggle-desc">Automated daily summary</span>
                  </div>
                  <button
                    className={`sc-toggle ${settings.dailyReports ? 'active' : ''}`}
                    onClick={() => handleToggle('dailyReports')}
                  >
                    <span className="sc-toggle-knob"></span>
                  </button>
                </div>
                <div className="sc-toggle-row">
                  <div className="sc-toggle-info">
                    <span className="sc-toggle-label">Transaction Alerts</span>
                    <span className="sc-toggle-desc">Notify on large transactions</span>
                  </div>
                  <button
                    className={`sc-toggle ${settings.transactionAlerts ? 'active' : ''}`}
                    onClick={() => handleToggle('transactionAlerts')}
                  >
                    <span className="sc-toggle-knob"></span>
                  </button>
                </div>
                <div className="sc-field">
                  <label>Notification Recipients</label>
                  <input
                    type="text"
                    value={settings.notificationRecipients}
                    onChange={(e) => handleChange('notificationRecipients', e.target.value)}
                    placeholder="email1@example.com, email2@example.com"
                  />
                </div>
              </div>
            </div>
          </div>
        </div>
        )}

        {/* Footer Actions */}
        <div className="sc-footer">
          <button className="sc-btn-reset" onClick={handleResetDefaults}>Reset to Default</button>
          <button className="sc-btn-save" onClick={handleSave} disabled={loading || saving}>
            {saving ? 'Saving...' : 'Save All Changes'}
          </button>
        </div>
      </div>
    </AdminLayout>
  );
};

export default SystemConfiguration;
