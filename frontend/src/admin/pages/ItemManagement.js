import React, { useState, useEffect, useCallback, useRef } from 'react';
import AdminLayout from '../components/AdminLayout';
import Modal from '../components/Modal';
import { productsAPI, categoriesAPI, brandsAPI, unitsAPI, batchAPI } from '../services/api';
import { toast } from '../utils/toast';
import '../styles/dashboard_air.css';
import '../styles/item_management.css';

const ItemManagement = () => {
  const [items, setItems] = useState([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingItem, setEditingItem] = useState(null);
  const [viewingItem, setViewingItem] = useState(null);
  const [currentPage, setCurrentPage] = useState(1);
  const [pagination, setPagination] = useState({ total: 0, last_page: 1 });
  const [productType, setProductType] = useState('appliance'); // 'appliance' or 'consumable'
  const [activeTab, setActiveTab] = useState('all'); // 'all' | 'appliance' | 'consumable'
  const [typeCounts, setTypeCounts] = useState({ all: 0, appliance: 0, consumable: 0 });
  const [filterCategory, setFilterCategory] = useState('');
  const [filterBrand, setFilterBrand] = useState('');
  const rowsPerPage = 10;
  const debounceRef = useRef(null);

  const [categories, setCategories] = useState([]);
  const [brands, setBrands] = useState([]);
  const [units, setUnits] = useState([]);
  const [isAddCategoryOpen, setIsAddCategoryOpen] = useState(false);
  const [isAddBrandOpen, setIsAddBrandOpen] = useState(false);
  const [newCategoryName, setNewCategoryName] = useState('');
  const [newBrandName, setNewBrandName] = useState('');
  const [formData, setFormData] = useState({
    name: '',
    code: '',
    barcode: '',
    category_id: '',
    brand_id: '',
    unit_id: '',
    unit_price: '',
    cost_price: '',
    warranty_period_months: 0,
    status_id: '',
    variant: '',
    measurement: '',
    // Product-class fields
    capacity_rating: '',    // Appliance: 1HP | 1.5HP | 2HP | 2.5HP | 3HP | 5HP
    description: '',        // Consumable: descriptive attributes
    pieces_per_package: '', // Consumable: packaging quantity
  });

  const fetchLookups = useCallback(async () => {
    try {
      // Use batch API to fetch all lookups in a single request
      const batchRes = await batchAPI.get({ include: ['categories', 'brands', 'units'] });
      const batchData = batchRes?.data || {};

      setCategories(Array.isArray(batchData.categories?.data) ? batchData.categories.data : []);
      setBrands(Array.isArray(batchData.brands?.data) ? batchData.brands.data : []);
      setUnits(Array.isArray(batchData.units?.data) ? batchData.units.data : []);
    } catch (err) {
      console.error('Failed to fetch lookups via batch:', err);
      // Fallback to individual requests if batch fails
      try {
        const [catRes, brandRes, unitsRes] = await Promise.all([
          categoriesAPI.getAll(),
          brandsAPI.getAll(),
          unitsAPI.getAll(),
        ]);
        setCategories(Array.isArray(catRes?.data) ? catRes.data : []);
        setBrands(Array.isArray(brandRes?.data) ? brandRes.data : []);
        setUnits(Array.isArray(unitsRes?.data) ? unitsRes.data : []);
      } catch (fallbackErr) {
        console.error('Fallback fetch also failed:', fallbackErr);
      }
    }
  }, []);

  useEffect(() => {
    fetchLookups();
  }, [fetchLookups]);

  const fetchItems = useCallback(async (page = 1) => {
    try {
      setLoading(true);
      const params = { page, per_page: rowsPerPage };
      if (searchTerm) params.search = searchTerm;
      if (filterCategory) params.category_id = filterCategory;
      if (filterBrand) params.brand_id = filterBrand;
      if (activeTab !== 'all') params.product_type = activeTab;
      const res = await productsAPI.getAll(params);
      // Support both paginated ({ data, pagination/meta }) and flat array responses
      const list =
        Array.isArray(res?.data)
          ? res.data
          : Array.isArray(res)
            ? res
            : Array.isArray(res?.data?.data)
              ? res.data.data
              : [];
      setItems(list);
      setPagination(res?.pagination || res?.meta || { total: list.length, last_page: 1 });
      setError(null);
    } catch (err) {
      setError(err.message);
      setItems([]);
      console.error('Failed to fetch items:', err);
    } finally {
      setLoading(false);
    }
  }, [searchTerm, filterCategory, filterBrand, activeTab, rowsPerPage]);

  useEffect(() => {
    fetchItems(currentPage);
  }, [currentPage, fetchItems]);

  // Fetch per-type totals so all tab badges are always accurate
  useEffect(() => {
    const fetchTypeCounts = async () => {
      try {
        const shared = {};
        if (searchTerm) shared.search = searchTerm;
        if (filterCategory) shared.category_id = filterCategory;
        if (filterBrand) shared.brand_id = filterBrand;
        const [allRes, appRes, conRes] = await Promise.all([
          productsAPI.getAll({ ...shared, per_page: 1 }),
          productsAPI.getAll({ ...shared, per_page: 1, product_type: 'appliance' }),
          productsAPI.getAll({ ...shared, per_page: 1, product_type: 'consumable' }),
        ]);

        const getTotal = (res) => {
          if (!res) return 0;
          if (res.pagination?.total != null) return res.pagination.total;
          if (res.meta?.total != null) return res.meta.total;
          if (Array.isArray(res?.data)) return res.data.length;
          if (Array.isArray(res)) return res.length;
          if (Array.isArray(res?.data?.data)) return res.data.data.length;
          return 0;
        };

        setTypeCounts({
          all:        getTotal(allRes),
          appliance:  getTotal(appRes),
          consumable: getTotal(conRes),
        });
      } catch {}
    };
    fetchTypeCounts();
  }, [searchTerm, filterCategory, filterBrand]);

  useEffect(() => {
    if (debounceRef.current) clearTimeout(debounceRef.current);
    debounceRef.current = setTimeout(() => {
      setCurrentPage(1);
    }, 400);
    return () => clearTimeout(debounceRef.current);
  }, [searchTerm, filterCategory, filterBrand, activeTab]);

  const resetForm = () => {
    setFormData({
      name: '', code: '', barcode: '', category_id: '', brand_id: '', unit_id: '',
      unit_price: '', cost_price: '', warranty_period_months: 0, status_id: '',
      variant: '', measurement: '',
      capacity_rating: '', description: '', pieces_per_package: '',
    });
    setProductType('appliance');
  };

  const handleAdd = () => {
    setEditingItem(null);
    resetForm();
    setIsModalOpen(true);
  };

  const handleEdit = (item) => {
    setEditingItem(item);
    // Use the stored product_type field; fall back to legacy heuristic for
    // older records that pre-date the discriminator column.
    const storedType = item.product_type;
    const legacyIsConsumable =
      !storedType &&
      ((item.unit?.unit_name || '').toLowerCase() === 'roll' ||
        (item.category?.category_name || '').toLowerCase().includes('consumable') ||
        (item.category?.category_name || '').toLowerCase().includes('parts') ||
        (item.category?.category_name || '').toLowerCase().includes('installation'));
    const resolvedType = storedType || (legacyIsConsumable ? 'consumable' : 'appliance');
    setProductType(resolvedType);
    setFormData({
      name: item.product_name || item.name || '',
      code: item.product_code || item.code || '',
      barcode: item.barcode || '',
      category_id: item.category_id ?? item.category?.category_id ?? '',
      brand_id: item.brand_id ?? item.brand?.brand_id ?? '',
      unit_id: item.unit_id ?? item.unit?.unit_id ?? '',
      unit_price: item.unit_price ?? item.price ?? '',
      cost_price: item.cost_price ?? item.unit_price ?? item.price ?? '',
      warranty_period_months: item.warranty_period_months ?? 0,
      status_id: item.status_id ?? '',
      variant: item.variant || item.description || '',
      measurement: item.unit?.unit_name || 'Unit',
      // New product-class fields
      capacity_rating: item.capacity_rating || '',
      description: item.description || '',
      pieces_per_package: item.pieces_per_package ?? '',
    });
    setIsModalOpen(true);
  };

  const handleView = (item) => {
    setViewingItem(item);
  };

  const handleCreateCategory = async (e) => {
    e.preventDefault();
    const name = newCategoryName.trim();
    if (!name) return;
    try {
      const res = await categoriesAPI.create({ category_name: name });
      const created = res?.data || res;
      if (created) {
        setCategories((prev) => [...prev, created]);
        setFormData((prev) => ({
          ...prev,
          category_id: created.category_id ?? prev.category_id,
        }));
      }
      setNewCategoryName('');
      setIsAddCategoryOpen(false);
      toast.success('Category added.');
    } catch (err) {
      toast.error(err.message || 'Failed to add category');
    }
  };

  const handleCreateBrand = async (e) => {
    e.preventDefault();
    const name = newBrandName.trim();
    if (!name) return;
    try {
      const res = await brandsAPI.create({ brand_name: name });
      const created = res?.data || res;
      if (created) {
        setBrands((prev) => [...prev, created]);
        setFormData((prev) => ({
          ...prev,
          brand_id: created.brand_id ?? prev.brand_id,
        }));
      }
      setNewBrandName('');
      setIsAddBrandOpen(false);
      toast.success('Brand added.');
    } catch (err) {
      toast.error(err.message || 'Failed to add brand');
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const isAppliance = productType === 'appliance';
    if (isAppliance && isCapacityRequired() && !formData.capacity_rating) {
      toast.error('Capacity is required only for Aircon and Refrigerator categories.');
      return;
    }
    const payload = {
      product_code: formData.code || undefined, // omit so backend auto-generates for consumables
      product_name: formData.name,
      product_type: productType,
      // Appliance-specific
      capacity_rating: isAppliance ? (formData.capacity_rating || null) : null,
      variant: isAppliance ? (formData.variant || null) : null,
      // Consumable-specific
      description: !isAppliance ? (formData.description || null) : null,
      pieces_per_package: !isAppliance ? (Number(formData.pieces_per_package) || null) : null,
      // Shared
      barcode: formData.barcode || null,
      category_id: formData.category_id || null,
      brand_id: isAppliance ? (formData.brand_id || null) : null,
      unit_id: formData.unit_id || null,
      unit_price: Number(formData.unit_price) || 0,
      cost_price: Number(formData.cost_price) || Number(formData.unit_price) || 0,
      warranty_period_months: isAppliance ? (Number(formData.warranty_period_months) || 0) : 0,
      status_id: formData.status_id || null,
    };
    try {
      if (editingItem) {
        await productsAPI.update(editingItem.product_id ?? editingItem.id, payload);
        toast.success('Product updated successfully!');
      } else {
        await productsAPI.create(payload);
        toast.success('Product registered successfully!');
      }
      setIsModalOpen(false);
      fetchItems(currentPage);
    } catch (err) {
      toast.error(err.message || 'Failed to save product');
    }
  };

  const totalPages = pagination.last_page || 1;

  // Compute stats — use the stored product_type; fall back to heuristic for legacy rows
  const resolveType = (i) => {
    if (i.product_type) return i.product_type;
    const u = (i.unit?.unit_name || '').toLowerCase();
    const c = (i.category?.category_name || '').toLowerCase();
    return (u === 'roll' || u === 'box' || c.includes('consumable') || c.includes('parts') || c.includes('installation'))
      ? 'consumable' : 'appliance';
  };
  const categoryCount = [...new Set(items.map(i => i.category_id || i.category?.category_id).filter(Boolean))].length;

  const normalizeFilterValue = (value) => (value == null ? '' : String(value));

  const isCapacityRequired = () => {
    if (productType !== 'appliance') return false;
    const cat = categories.find(
      (c) => String(c.category_id) === String(formData.category_id || '')
    );
    if (!cat) return false;
    const name = (cat.category_name || '').toLowerCase();
    return name.includes('refrigerator') || name.includes('aircon') || name.includes('air conditioning');
  };

  // Filtered items (client-side safeguard; backend params are also applied)
  const filteredItems = items.filter(item => {
    if (
      filterCategory &&
      normalizeFilterValue(item.category_id ?? item.category?.category_id) !== normalizeFilterValue(filterCategory)
    ) return false;
    if (
      filterBrand &&
      normalizeFilterValue(item.brand_id ?? item.brand?.brand_id) !== normalizeFilterValue(filterBrand)
    ) return false;
    if (activeTab !== 'all' && resolveType(item) !== activeTab) return false;
    return true;
  });

  const getTypeBadge = (item) => {
    const type = resolveType(item);
    if (type === 'consumable') {
      return { label: 'CONSUMABLE', className: 'im-type-consumable' };
    }
    return { label: 'APPLIANCE', className: 'im-type-unit' };
  };

  return (
    <AdminLayout>
      <div className="im-page">
        {/* Page Header */}
        <div className="im-page-header">
          <div className="im-page-header-left">
            <h1>Product Management</h1>
            <p>Central repository for product specifications and material catalog</p>
          </div>
          <div className="im-page-header-right">
            <div className="im-header-filters">
              <select
                className="im-filter-select"
                value={filterCategory}
                onChange={(e) => {
                  setFilterCategory(e.target.value);
                  setCurrentPage(1);
                }}
              >
                <option value="">CATEGORY</option>
                {categories.map((c) => (
                  <option key={c.category_id} value={c.category_id}>{c.category_name}</option>
                ))}
              </select>
              <select
                className="im-filter-select"
                value={filterBrand}
                onChange={(e) => {
                  setFilterBrand(e.target.value);
                  setCurrentPage(1);
                }}
              >
                <option value="">BRAND</option>
                {brands.map((b) => (
                  <option key={b.brand_id} value={b.brand_id}>{b.brand_name}</option>
                ))}
              </select>
            </div>
            <button className="im-btn-create" onClick={handleAdd}>
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="16" height="16">
                <line x1="12" y1="5" x2="12" y2="19"></line>
                <line x1="5" y1="12" x2="19" y2="12"></line>
              </svg>
              ADD NEW PRODUCT
            </button>
          </div>
        </div>

        {/* Stats Cards */}
        <div className="im-stats-row">
          <div className="im-stat-card">
            <div className="im-stat-icon im-stat-icon-red">
              <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#dc2626" strokeWidth="2">
                <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path>
              </svg>
            </div>
            <div className="im-stat-info">
              <span className="im-stat-label">Total Products</span>
              <span className="im-stat-number">{typeCounts.all}</span>
            </div>
          </div>
          <div className="im-stat-card">
            <div className="im-stat-icon im-stat-icon-blue">
              <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#3b82f6" strokeWidth="2">
                <rect x="4" y="4" width="16" height="16" rx="2"></rect>
                <line x1="4" y1="12" x2="20" y2="12"></line>
              </svg>
            </div>
            <div className="im-stat-info">
              <span className="im-stat-label">Appliances</span>
              <span className="im-stat-number">{typeCounts.appliance}</span>
            </div>
          </div>
          <div className="im-stat-card">
            <div className="im-stat-icon im-stat-icon-green">
              <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#059669" strokeWidth="2">
                <circle cx="12" cy="12" r="3"></circle>
                <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33"></path>
              </svg>
            </div>
            <div className="im-stat-info">
              <span className="im-stat-label">Consumables</span>
              <span className="im-stat-number">{typeCounts.consumable}</span>
            </div>
          </div>
          <div className="im-stat-card">
            <div className="im-stat-icon im-stat-icon-orange">
              <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" strokeWidth="2">
                <path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path>
              </svg>
            </div>
            <div className="im-stat-info">
              <span className="im-stat-label">Categories</span>
              <span className="im-stat-number">{categoryCount}</span>
            </div>
          </div>
        </div>

        {/* Type Tabs */}
        <div className="im-tabs">
          <button
            className={`im-tab-btn ${activeTab === 'all' ? 'active' : ''}`}
            onClick={() => { setActiveTab('all'); setCurrentPage(1); }}
          >
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="14" height="14">
              <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
            </svg>
            All Products
            <span className="im-tab-count">{typeCounts.all}</span>
          </button>
          <button
            className={`im-tab-btn ${activeTab === 'appliance' ? 'active' : ''}`}
            onClick={() => { setActiveTab('appliance'); setCurrentPage(1); }}
          >
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="14" height="14">
              <rect x="4" y="4" width="16" height="16" rx="2" />
              <line x1="4" y1="12" x2="20" y2="12" />
            </svg>
            Appliances
            <span className="im-tab-count">{typeCounts.appliance}</span>
          </button>
          <button
            className={`im-tab-btn ${activeTab === 'consumable' ? 'active' : ''}`}
            onClick={() => { setActiveTab('consumable'); setCurrentPage(1); }}
          >
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="14" height="14">
              <circle cx="12" cy="12" r="3" />
              <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33" />
            </svg>
            Consumables
            <span className="im-tab-count">{typeCounts.consumable}</span>
          </button>
        </div>

        {/* Product Catalog Table */}
        <div className="im-table-card">
          <div className="im-table-top">
            <div className="im-table-title">
              <h3>Product Catalog</h3>
              <p>Complete list of all products and materials</p>
            </div>
          </div>

          <div className="im-search-row">
            <div className="im-search-input">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="16" height="16">
                <circle cx="11" cy="11" r="8"></circle>
                <path d="m21 21-4.35-4.35"></path>
              </svg>
              <input
                type="text"
                placeholder="Search specifications..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
              />
            </div>
          </div>

          {loading && <div className="im-loading">Loading products...</div>}
          {error && <div className="im-error">Error: {error}</div>}

          <div className="im-table-wrapper">
            <table className="im-table">
              <thead>
                <tr>
                  <th>{activeTab === 'consumable' ? 'NAME' : 'MODEL / NAME'}</th>
                  <th>{activeTab === 'consumable' ? 'DESCRIPTION' : activeTab === 'appliance' ? 'CAPACITY' : 'CAPACITY / DESCRIPTION'}</th>
                  <th>TYPE</th>
                  <th>BARCODE</th>
                  <th>UNIT PRICE</th>
                  <th>UNIT / PKG</th>
                  <th>ACTIONS</th>
                </tr>
              </thead>
              <tbody>
                {filteredItems.length === 0 ? (
                  <tr>
                    <td colSpan="7" style={{ textAlign: 'center', color: '#9ca3af', padding: '40px' }}>
                      {loading ? 'Loading...' : 'No products found'}
                    </td>
                  </tr>
                ) : (
                  filteredItems.map((item) => {
                    const typeBadge = getTypeBadge(item);
                    return (
                      <tr key={item.product_id ?? item.id}>
                        <td>
                          <div className="im-product-cell">
                            <span className="im-product-code">{item.product_code || item.code}</span>
                            <span className="im-product-name">{item.product_name || item.name}</span>
                            <div className="im-product-tags">
                              {item.category?.category_name && (
                                <span className="im-tag im-tag-category">{item.category.category_name}</span>
                              )}
                              {item.brand?.brand_name && (
                                <span className="im-tag im-tag-brand">{item.brand.brand_name}</span>
                              )}
                            </div>
                          </div>
                        </td>
                        <td className="im-cell-variant">
                          {resolveType(item) === 'appliance'
                            ? (
                                <>
                                  {item.capacity_rating
                                    ? <span className="im-capacity-badge">{item.capacity_rating}</span>
                                    : '—'}
                                  {item.variant && (
                                    <span className="im-variant-text">
                                      {typeof item.variant === 'string' ? ` • ${item.variant}` : ''}
                                    </span>
                                  )}
                                </>
                              )
                            : (item.description || '—')}
                        </td>
                        <td>
                          <span className={`im-type-badge ${typeBadge.className}`}>
                            {typeBadge.label}
                          </span>
                        </td>
                        <td className="im-cell-barcode">{item.barcode || '—'}</td>
                        <td className="im-cell-price">₱{Number(item.unit_price ?? item.price ?? 0).toLocaleString()}</td>
                        <td className="im-cell-measurement">{item.unit?.unit_name || 'UNIT'}</td>
                        <td>
                          <div className="im-cell-actions">
                            <button className="im-action-btn im-action-view" onClick={() => handleView(item)} title="View">
                              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="16" height="16">
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                <circle cx="12" cy="12" r="3"></circle>
                              </svg>
                            </button>
                            <button className="im-action-btn im-action-edit" onClick={() => handleEdit(item)} title="Edit">
                              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="16" height="16">
                                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                              </svg>
                            </button>
                          </div>
                        </td>
                      </tr>
                    );
                  })
                )}
              </tbody>
            </table>
          </div>

          {/* Pagination */}
          {totalPages > 1 && (
            <div className="im-pagination">
              <button
                className="im-page-btn"
                disabled={currentPage === 1}
                onClick={() => setCurrentPage(currentPage - 1)}
              >
                Previous
              </button>
              {Array.from({ length: totalPages }, (_, i) => i + 1).map((page) => (
                <button
                  key={page}
                  className={`im-page-btn ${currentPage === page ? 'im-page-btn-active' : ''}`}
                  onClick={() => setCurrentPage(page)}
                >
                  {page}
                </button>
              ))}
              <button
                className="im-page-btn"
                disabled={currentPage === totalPages}
                onClick={() => setCurrentPage(currentPage + 1)}
              >
                Next
              </button>
            </div>
          )}
        </div>
      </div>

      {/* View Modal */}
      {viewingItem && (
        <Modal isOpen={!!viewingItem} onClose={() => setViewingItem(null)} title="Product Details">
          <div className="im-view-details">
            {/* Type badge */}
            <div style={{ marginBottom: '12px' }}>
              <span className={`im-type-badge ${resolveType(viewingItem) === 'appliance' ? 'im-type-unit' : 'im-type-consumable'}`}>
                {resolveType(viewingItem) === 'appliance' ? 'APPLIANCE' : 'CONSUMABLE SUPPLY'}
              </span>
            </div>

            <div className="im-view-row">
              <div className="im-view-field">
                <label>{resolveType(viewingItem) === 'appliance' ? 'Product Name' : 'Supply Name'}</label>
                <p>{viewingItem.product_name || viewingItem.name}</p>
              </div>
              <div className="im-view-field">
                <label>Code / SKU</label>
                <p>{viewingItem.product_code || viewingItem.code}</p>
              </div>
            </div>

            {/* Appliance-specific fields */}
            {resolveType(viewingItem) === 'appliance' && (
              <>
                <div className="im-view-row">
                  <div className="im-view-field">
                    <label>Capacity Rating</label>
                    <p>{viewingItem.capacity_rating
                        ? <span className="im-capacity-badge">{viewingItem.capacity_rating}</span>
                        : '—'}</p>
                  </div>
                  <div className="im-view-field">
                    <label>Variant</label>
                    <p>{viewingItem.variant || '—'}</p>
                  </div>
                </div>
                <div className="im-view-row">
                  <div className="im-view-field">
                    <label>Warranty</label>
                    <p>{viewingItem.warranty_period_months
                        ? `${viewingItem.warranty_period_months} month(s)` : '—'}</p>
                  </div>
                </div>
              </>
            )}

            {/* Consumable-specific fields */}
            {resolveType(viewingItem) === 'consumable' && (
              <>
                {viewingItem.description && (
                  <div className="im-view-field">
                    <label>Description / Attributes</label>
                    <p>{viewingItem.description}</p>
                  </div>
                )}
                <div className="im-view-row">
                  <div className="im-view-field">
                    <label>Packaging Unit</label>
                    <p>{viewingItem.unit?.unit_name || '—'}</p>
                  </div>
                  <div className="im-view-field">
                    <label>Pieces per Package</label>
                    <p>{viewingItem.pieces_per_package ?? '—'}</p>
                  </div>
                </div>
              </>
            )}

            <div className="im-view-row">
              <div className="im-view-field">
                <label>Category</label>
                <p>{viewingItem.category?.category_name || '—'}</p>
              </div>
              <div className="im-view-field">
                <label>Brand</label>
                <p>{viewingItem.brand?.brand_name || '—'}</p>
              </div>
            </div>
            <div className="im-view-row">
              <div className="im-view-field">
                <label>Unit Price</label>
                <p>₱{Number(viewingItem.unit_price || 0).toLocaleString()}</p>
              </div>
              <div className="im-view-field">
                <label>Cost Price</label>
                <p>₱{Number(viewingItem.cost_price || 0).toLocaleString()}</p>
              </div>
            </div>
            <div className="im-view-row">
              <div className="im-view-field">
                <label>Barcode</label>
                <p>{viewingItem.barcode || '—'}</p>
              </div>
              <div className="im-view-field">
                <label>Status</label>
                <p>{viewingItem.status?.status_name || 'Active'}</p>
              </div>
            </div>

            <div className="im-modal-footer">
              <button type="button" className="im-modal-btn-cancel" onClick={() => setViewingItem(null)}>Close</button>
              <button type="button" className="im-modal-btn-confirm" onClick={() => { setViewingItem(null); handleEdit(viewingItem); }}>Edit</button>
            </div>
          </div>
        </Modal>
      )}

      {/* Add/Edit Product Modal */}
      <Modal isOpen={isModalOpen} onClose={() => setIsModalOpen(false)} title="">
        <div className="im-add-modal">
          {/* Modal Header */}
          <div className="im-add-modal-header">
            <div className="im-add-modal-icon">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="20" height="20">
                <line x1="12" y1="5" x2="12" y2="19"></line>
                <line x1="5" y1="12" x2="19" y2="12"></line>
              </svg>
            </div>
            <div>
              <h2 className="im-add-modal-title">
                {editingItem ? 'EDIT PRODUCT' : 'ADD NEW PRODUCT'}
              </h2>
              <p className="im-add-modal-subtitle">MASTER CATALOG REGISTRATION</p>
            </div>
          </div>

          {/* Product-class toggle */}
          <div className="im-type-toggle">
            <button
              className={`im-type-toggle-btn ${productType === 'appliance' ? 'active' : ''}`}
              onClick={() => setProductType('appliance')}
              type="button"
            >
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="16" height="16">
                <rect x="4" y="4" width="16" height="16" rx="2"></rect>
                <line x1="4" y1="12" x2="20" y2="12"></line>
              </svg>
              APPLIANCE
            </button>
            <button
              className={`im-type-toggle-btn ${productType === 'consumable' ? 'active' : ''}`}
              onClick={() => setProductType('consumable')}
              type="button"
            >
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="16" height="16">
                <circle cx="12" cy="12" r="3"></circle>
                <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33"></path>
              </svg>
              CONSUMABLE SUPPLY
            </button>
          </div>

          {/* Form */}
          <form onSubmit={handleSubmit} className="im-add-form">
            {productType === 'appliance' ? (
              /* ── APPLIANCE FORM ──────────────────────────────────────── */
              <>
                <div className="im-form-row">
                  <div className="im-form-field">
                    <label>MODEL CODE *</label>
                    <input
                      type="text"
                      value={formData.code}
                      onChange={(e) => setFormData({ ...formData, code: e.target.value })}
                      placeholder="e.g. AS-20-PRO"
                      required
                    />
                  </div>
                  <div className="im-form-field">
                    <label>CAPACITY RATING *</label>
                    <select
                      value={formData.capacity_rating}
                      onChange={(e) => setFormData({ ...formData, capacity_rating: e.target.value })}
                      required
                    >
                      <option value="">Select Capacity</option>
                      <option value="1HP">1HP</option>
                      <option value="1.5HP">1.5HP</option>
                      <option value="2HP">2HP</option>
                      <option value="2.5HP">2.5HP</option>
                      <option value="3HP">3HP</option>
                      <option value="5HP">5HP</option>
                    </select>
                  </div>
                </div>
                <div className="im-form-row">
                  <div className="im-form-field">
                    <label>CATEGORY</label>
                    <div className="im-inline-field">
                      <select
                        value={formData.category_id}
                        onChange={(e) => setFormData({ ...formData, category_id: e.target.value })}
                      >
                        <option value="">Select Category</option>
                        {categories.map((c) => (
                          <option key={c.category_id} value={c.category_id}>{c.category_name}</option>
                        ))}
                      </select>
                      <button
                        type="button"
                        className="im-inline-add-btn"
                        onClick={() => setIsAddCategoryOpen(true)}
                        title="Add new category"
                      >
                        +
                      </button>
                    </div>
                  </div>
                  <div className="im-form-field">
                    <label>BRAND</label>
                    <div className="im-inline-field">
                      <select
                        value={formData.brand_id}
                        onChange={(e) => setFormData({ ...formData, brand_id: e.target.value })}
                      >
                        <option value="">Select Brand</option>
                        {brands.map((b) => (
                          <option key={b.brand_id} value={b.brand_id}>{b.brand_name}</option>
                        ))}
                      </select>
                      <button
                        type="button"
                        className="im-inline-add-btn"
                        onClick={() => setIsAddBrandOpen(true)}
                        title="Add new brand"
                      >
                        +
                      </button>
                    </div>
                  </div>
                </div>
                <div className="im-form-row">
                  <div className="im-form-field">
                    <label>VARIANT</label>
                    <input
                      type="text"
                      value={formData.variant}
                      onChange={(e) => setFormData({ ...formData, variant: e.target.value })}
                      placeholder="e.g. Non-Inverter"
                    />
                  </div>
                </div>
                <div className="im-form-field">
                  <label>PRODUCT NAME *</label>
                  <input
                    type="text"
                    value={formData.name}
                    onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                    placeholder="e.g. Airking Split Type Aircon 1HP"
                    required
                  />
                </div>
                <div className="im-form-row">
                  <div className="im-form-field">
                    <label>UNIT</label>
                    <select
                      value={formData.unit_id}
                      onChange={(e) => setFormData({ ...formData, unit_id: e.target.value })}
                    >
                      <option value="">Select Unit</option>
                      {units.map((u) => (
                        <option key={u.unit_id} value={u.unit_id}>{u.unit_name}</option>
                      ))}
                    </select>
                  </div>
                  <div className="im-form-field">
                    <label>BARCODE</label>
                    <input
                      type="text"
                      value={formData.barcode}
                      onChange={(e) => setFormData({ ...formData, barcode: e.target.value })}
                      placeholder="Optional"
                    />
                  </div>
                </div>
                <div className="im-form-row">
                  <div className="im-form-field">
                    <label>UNIT PRICE (₱) *</label>
                    <input
                      type="number"
                      step="0.01"
                      value={formData.unit_price}
                      onChange={(e) => setFormData({ ...formData, unit_price: e.target.value })}
                      placeholder="0.00"
                      required
                    />
                  </div>
                  <div className="im-form-field">
                    <label>COST PRICE (₱)</label>
                    <input
                      type="number"
                      step="0.01"
                      value={formData.cost_price}
                      onChange={(e) => setFormData({ ...formData, cost_price: e.target.value })}
                      placeholder="0.00"
                    />
                  </div>
                </div>
              </>
            ) : (
              /* ── CONSUMABLE SUPPLY FORM ──────────────────────────────── */
              <>
                <div className="im-form-row">
                  <div className="im-form-field">
                    <label>CATEGORY</label>
                    <div className="im-inline-field">
                      <select
                        value={formData.category_id}
                        onChange={(e) => setFormData({ ...formData, category_id: e.target.value })}
                      >
                        <option value="">Select Category</option>
                        {categories.map((c) => (
                          <option key={c.category_id} value={c.category_id}>{c.category_name}</option>
                        ))}
                      </select>
                      <button
                        type="button"
                        className="im-inline-add-btn"
                        onClick={() => setIsAddCategoryOpen(true)}
                        title="Add new category"
                      >
                        +
                      </button>
                    </div>
                  </div>
                  <div className="im-form-field">
                    <label>PACKAGING UNIT</label>
                    <select
                      value={formData.unit_id}
                      onChange={(e) => setFormData({ ...formData, unit_id: e.target.value })}
                    >
                      <option value="">Select Unit</option>
                      {units.map((u) => (
                        <option key={u.unit_id} value={u.unit_id}>{u.unit_name}</option>
                      ))}
                    </select>
                  </div>
                </div>
                <div className="im-form-field">
                  <label>SUPPLY NAME *</label>
                  <input
                    type="text"
                    value={formData.name}
                    onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                    placeholder="e.g. AC Copper Pipe 1/4 inch"
                    required
                  />
                </div>
                <div className="im-form-field">
                  <label>DESCRIPTION / ATTRIBUTES</label>
                  <textarea
                    value={formData.description}
                    onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                    placeholder="e.g. Grade-A copper, 1/4 inch OD, suitable for R-410A systems"
                    rows={2}
                    style={{ resize: 'vertical' }}
                  />
                </div>
                <div className="im-form-row">
                  <div className="im-form-field">
                    <label>PIECES PER PACKAGE</label>
                    <input
                      type="number"
                      min="1"
                      value={formData.pieces_per_package}
                      onChange={(e) => setFormData({ ...formData, pieces_per_package: e.target.value })}
                      placeholder="e.g. 50"
                    />
                  </div>
                  <div className="im-form-field">
                    <label>BARCODE</label>
                    <input
                      type="text"
                      value={formData.barcode}
                      onChange={(e) => setFormData({ ...formData, barcode: e.target.value })}
                      placeholder="Optional"
                    />
                  </div>
                </div>
                <div className="im-form-row">
                  <div className="im-form-field">
                    <label>UNIT PRICE (₱) *</label>
                    <input
                      type="number"
                      step="0.01"
                      value={formData.unit_price}
                      onChange={(e) => setFormData({ ...formData, unit_price: e.target.value })}
                      placeholder="0.00"
                      required
                    />
                  </div>
                  <div className="im-form-field">
                    <label>COST PRICE (₱)</label>
                    <input
                      type="number"
                      step="0.01"
                      value={formData.cost_price}
                      onChange={(e) => setFormData({ ...formData, cost_price: e.target.value })}
                      placeholder="0.00"
                    />
                  </div>
                </div>
              </>
            )}

            {/* Modal Actions */}
            <div className="im-modal-footer">
              <button type="button" className="im-modal-btn-cancel" onClick={() => setIsModalOpen(false)}>
                CANCEL
              </button>
              <button type="submit" className="im-modal-btn-confirm">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="14" height="14">
                  <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path>
                </svg>
                {editingItem ? 'UPDATE PRODUCT' : 'REGISTER PRODUCT'}
              </button>
            </div>
          </form>
        </div>
      </Modal>

      {/* Quick Add Category */}
      {isAddCategoryOpen && (
        <Modal
          isOpen={isAddCategoryOpen}
          onClose={() => { setIsAddCategoryOpen(false); setNewCategoryName(''); }}
          title="Add Category"
        >
          <form onSubmit={handleCreateCategory} className="im-add-simple-form">
            <div className="im-form-field">
              <label>Category Name</label>
              <input
                type="text"
                value={newCategoryName}
                onChange={(e) => setNewCategoryName(e.target.value)}
                placeholder="e.g. Installation Materials"
                autoFocus
              />
            </div>
            <div className="im-modal-footer">
              <button
                type="button"
                className="im-modal-btn-cancel"
                onClick={() => { setIsAddCategoryOpen(false); setNewCategoryName(''); }}
              >
                CANCEL
              </button>
              <button type="submit" className="im-modal-btn-confirm">
                SAVE CATEGORY
              </button>
            </div>
          </form>
        </Modal>
      )}

      {/* Quick Add Brand */}
      {isAddBrandOpen && (
        <Modal
          isOpen={isAddBrandOpen}
          onClose={() => { setIsAddBrandOpen(false); setNewBrandName(''); }}
          title="Add Brand"
        >
          <form onSubmit={handleCreateBrand} className="im-add-simple-form">
            <div className="im-form-field">
              <label>Brand Name</label>
              <input
                type="text"
                value={newBrandName}
                onChange={(e) => setNewBrandName(e.target.value)}
                placeholder="e.g. AirKing"
                autoFocus
              />
            </div>
            <div className="im-modal-footer">
              <button
                type="button"
                className="im-modal-btn-cancel"
                onClick={() => { setIsAddBrandOpen(false); setNewBrandName(''); }}
              >
                CANCEL
              </button>
              <button type="submit" className="im-modal-btn-confirm">
                SAVE BRAND
              </button>
            </div>
          </form>
        </Modal>
      )}
    </AdminLayout>
  );
};

export default ItemManagement;
