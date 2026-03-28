// Use explicit API URL so requests hit Laravel. CORS allows localhost.
// Set REACT_APP_API_URL in .env if your backend runs on a different host/port.
const API_BASE_URL = (() => {
  const url = process.env.REACT_APP_API_URL || 'http://127.0.0.1:8000/api';
  return url.replace(/\/+$/, ''); // no trailing slash
})();

export const getApiBaseUrl = () => API_BASE_URL;

const TOKEN_KEY = 'token';

/**
 * Check if the backend API is reachable (no auth required). Use for connection troubleshooting.
 * @returns {Promise<{ ok: boolean, message?: string }>}
 */
export const checkApiHealth = async () => {
  try {
    const res = await fetch(API_BASE_URL, {
      method: 'GET',
      headers: { Accept: 'application/json' },
      mode: 'cors',
    });
    const text = await res.text();
    let data = {};
    try {
      data = text ? JSON.parse(text) : {};
    } catch (_) {
      data = { message: text || `Invalid response (${res.status})` };
    }
    if (res.ok && (data.message != null || data.version != null)) {
      return { ok: true, message: data.message };
    }
    return { ok: false, message: data.message || `Server returned ${res.status}` };
  } catch (e) {
    const msg = e.message === 'Failed to fetch'
      ? 'Cannot reach the server. Start the backend with: cd back-end && php artisan serve'
      : e.message;
    return { ok: false, message: msg };
  }
};

/* ======================
   TOKEN HELPERS
====================== */
export const getToken = () => localStorage.getItem(TOKEN_KEY);
export const setToken = (token) => localStorage.setItem(TOKEN_KEY, token);
export const removeToken = () => localStorage.removeItem(TOKEN_KEY);

/* ======================
   API REQUEST HELPER
====================== */
const apiRequest = async (endpoint, options = {}) => {
  const token = getToken();

  const headers = {
    Accept: 'application/json',
    'Content-Type': 'application/json',
    ...(options.headers || {}),
  };

  if (token) {
    headers.Authorization = `Bearer ${token}`;
  }

  const url = endpoint.startsWith('/') ? `${API_BASE_URL}${endpoint}` : `${API_BASE_URL}/${endpoint}`;
  const method = options.method || 'GET';
  console.log(`[API] ${method} ${url}`, options.body ? { body: options.body } : '');
  let response;
  try {
    response = await fetch(url, {
      ...options,
      headers,
    });
  } catch (networkError) {
    const msg =
      networkError.message === 'Failed to fetch'
        ? 'Cannot reach the server. Start the backend with: cd back-end && php artisan serve'
        : networkError.message;
    throw new Error(msg);
  }

  let data;
  try {
    const text = await response.text();
    if (!text || text.trim() === '') {
      data = { message: response.status === 404 ? 'Not found.' : 'Server error.' };
    } else {
      data = JSON.parse(text);
    }
  } catch (_) {
    const msg =
      response.status === 404
        ? 'Endpoint not found (404). Check the API URL and route.'
        : response.status >= 500
          ? `Server error (${response.status}). Try again later.`
          : `Server returned ${response.status} with non-JSON response.`;
    throw new Error(msg);
  }

  console.log(`[API] ${method} ${url} → ${response.status}`, response.ok ? 'OK' : { message: data.message, errors: data.errors });

  if (!response.ok) {
    const err = new Error(data.message || 'API request failed');
    err.status = response.status;
    err.errors = data.errors || null;
    throw err;
  }

  return data;
};

/* ======================
   AUTH API FIXED
====================== */
export const authAPI = {
  /** Math CAPTCHA challenge (no token). Call before login. */
  getLoginChallenge: async () => {
    return apiRequest('/login/challenge');
  },

  login: async (username, password, captchaToken, captchaAnswer) => {
    const data = await apiRequest('/login', {
      method: 'POST',
      body: JSON.stringify({
        username,
        password,
        captcha_token: captchaToken,
        captcha_answer: String(captchaAnswer ?? ''),
      }),
    });

    if (data.token) setToken(data.token);
    if (data.user) localStorage.setItem('user', JSON.stringify(data.user));
    return data;
  },

  logout: async () => {
    await apiRequest('/logout', { method: 'POST' });
    removeToken();
  },

  forgotPassword: async (username, email) => {
    return apiRequest('/forgot-password', {
      method: 'POST',
      body: JSON.stringify({ username, email }),
    });
  },

  getUser: async () => apiRequest('/user'),
};

/* ======================
   BATCH API (single request for multiple resources)
====================== */
export const batchAPI = {
  /**
   * @param {{ include: string[] }} params - e.g. { include: ['users', 'roles', 'branches'] }
   * @returns {Promise<{ data: Record<string, { success: boolean, data: any, pagination?: any }> }>}
   */
  get: async (params = {}) => {
    const include = Array.isArray(params.include) ? params.include : (params.include ? [params.include] : []);
    const query = include.length ? `?include=${include.join(',')}` : '';
    const res = await apiRequest(`/batch${query}`);
    return res;
  },
};

/* ======================
   DASHBOARD API
====================== */
export const dashboardAPI = {
  get: async () => apiRequest('/dashboard'),
  getLowStock: async () => apiRequest('/dashboard/low-stock'),
  getRecentMovements: async () => apiRequest('/dashboard/recent-movements'),
};

/* ======================
   AUDIT API
====================== */
export const auditAPI = {
  getTrail: async (params = {}) => {
    const query = new URLSearchParams(params).toString();
    return apiRequest(query ? `/audit-trail?${query}` : '/audit-trail');
  },
  getLog: async (params = {}) => {
    const query = new URLSearchParams(params).toString();
    return apiRequest(query ? `/audit-log?${query}` : '/audit-log');
  },
};

/* ======================
   LOCATIONS API (ERD — replaces branches & warehouses)
====================== */
export const locationsAPI = {
  getAll: async (params = {}) => {
    const query = new URLSearchParams(params).toString();
    return apiRequest(query ? `/locations?${query}` : '/locations');
  },
  getById: async (id) => apiRequest(`/locations/${id}`),
  create: async (data) =>
    apiRequest('/locations', { method: 'POST', body: JSON.stringify(data) }),
  update: async (id, data) =>
    apiRequest(`/locations/${id}`, { method: 'PUT', body: JSON.stringify(data) }),
  delete: async (id) =>
    apiRequest(`/locations/${id}`, { method: 'DELETE' }),
};

/* Branches API */
export const branchesAPI = {
  getAll: async (params = {}) => {
    const query = new URLSearchParams(params).toString();
    return apiRequest(query ? `/branches?${query}` : '/branches');
  },
  getById: async (id) => apiRequest(`/branches/${id}`),
};

/* Legacy alias */
export const warehousesAPI = locationsAPI;

/* ======================
   ITEMS API
====================== */
export const itemsAPI = {
  getAll: async (params = {}) => {
    const query = new URLSearchParams(params).toString();
    return apiRequest(query ? `/items?${query}` : '/items');
  },
  getById: async (id) => apiRequest(`/items/${id}`),
  create: async (data) =>
    apiRequest('/items', {
      method: 'POST',
      body: JSON.stringify(data),
    }),
  update: async (id, data) =>
    apiRequest(`/items/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    }),
  delete: async (id) =>
    apiRequest(`/items/${id}`, { method: 'DELETE' }),
};

/* ======================
   INVENTORY API
====================== */
export const inventoryAPI = {
  getAll: async (params = {}) => {
    const query = new URLSearchParams(params).toString();
    return apiRequest(query ? `/inventory?${query}` : '/inventory');
  },
  getById: async (id) => apiRequest(`/inventory/${id}`),
  create: async (data) =>
    apiRequest('/inventory', {
      method: 'POST',
      body: JSON.stringify(data),
    }),
  update: async (id, data) =>
    apiRequest(`/inventory/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    }),
  delete: async (id) =>
    apiRequest(`/inventory/${id}`, { method: 'DELETE' }),
  /** Exact match on `barcode` or `product_code` (InventoryController::scanBarcode). */
  scanBarcode: async (barcode, locationId) =>
    apiRequest('/inventory/scan-barcode', {
      method: 'POST',
      body: JSON.stringify({
        barcode: String(barcode || '').trim(),
        ...(locationId != null && String(locationId) !== ''
          ? { location_id: locationId }
          : {}),
      }),
    }),
};

/* ======================
   CUSTOMERS API (POS)
====================== */
export const customersAPI = {
  getAll: async (params = {}) => {
    const query = new URLSearchParams(params).toString();
    return apiRequest(query ? `/customers?${query}` : '/customers');
  },
  search: async (q) => {
    const query = new URLSearchParams({ q }).toString();
    return apiRequest(`/customers/search?${query}`);
  },
  getById: async (id) => apiRequest(`/customers/${id}`),
  create: async (data) =>
    apiRequest('/customers', {
      method: 'POST',
      body: JSON.stringify(data),
    }),
  update: async (id, data) =>
    apiRequest(`/customers/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    }),
  delete: async (id) =>
    apiRequest(`/customers/${id}`, { method: 'DELETE' }),
};

/* ======================
   SALES API (ERD — replaces transactions)
====================== */
export const salesAPI = {
  getAll: async (params = {}) => {
    const query = new URLSearchParams(params).toString();
    return apiRequest(query ? `/sales?${query}` : '/sales');
  },
  getById: async (id) => apiRequest(`/sales/${id}`),
  create: async (data) =>
    apiRequest('/sales', { method: 'POST', body: JSON.stringify(data) }),
  update: async (id, data) =>
    apiRequest(`/sales/${id}`, { method: 'PUT', body: JSON.stringify(data) }),
  delete: async (id) =>
    apiRequest(`/sales/${id}`, { method: 'DELETE' }),
};

/* Legacy alias → /sales */
export const transactionsAPI = salesAPI;

/* ======================
   PURCHASE ORDERS API
====================== */
export const purchaseOrdersAPI = {
  getAll: async (params = {}) => {
    const query = new URLSearchParams(params).toString();
    return apiRequest(query ? `/purchase-orders?${query}` : '/purchase-orders');
  },
  getById: async (id) => apiRequest(`/purchase-orders/${id}`),
  create: async (data) =>
    apiRequest('/purchase-orders', { method: 'POST', body: JSON.stringify(data) }),
  update: async (id, data) =>
    apiRequest(`/purchase-orders/${id}`, { method: 'PUT', body: JSON.stringify(data) }),
  delete: async (id) =>
    apiRequest(`/purchase-orders/${id}`, { method: 'DELETE' }),
};

/* ======================
   RECEIVINGS API
====================== */
export const receivingsAPI = {
  getAll: async (params = {}) => {
    const query = new URLSearchParams(params).toString();
    return apiRequest(query ? `/receivings?${query}` : '/receivings');
  },
  getById: async (id) => apiRequest(`/receivings/${id}`),
  create: async (data) =>
    apiRequest('/receivings', { method: 'POST', body: JSON.stringify(data) }),
  update: async (id, data) =>
    apiRequest(`/receivings/${id}`, { method: 'PUT', body: JSON.stringify(data) }),
  delete: async (id) =>
    apiRequest(`/receivings/${id}`, { method: 'DELETE' }),
};

/* ======================
   ISSUANCES API
====================== */
export const issuancesAPI = {
  getAll: async (params = {}) => {
    const query = new URLSearchParams(params).toString();
    return apiRequest(query ? `/issuances?${query}` : '/issuances');
  },
  getById: async (id) => apiRequest(`/issuances/${id}`),
  create: async (data) =>
    apiRequest('/issuances', { method: 'POST', body: JSON.stringify(data) }),
  update: async (id, data) =>
    apiRequest(`/issuances/${id}`, { method: 'PUT', body: JSON.stringify(data) }),
  delete: async (id) =>
    apiRequest(`/issuances/${id}`, { method: 'DELETE' }),
};

/* ======================
   ADJUSTMENTS API
====================== */
export const adjustmentsAPI = {
  getAll: async (params = {}) => {
    const query = new URLSearchParams(params).toString();
    return apiRequest(query ? `/adjustments?${query}` : '/adjustments');
  },
  getById: async (id) => apiRequest(`/adjustments/${id}`),
  create: async (data) =>
    apiRequest('/adjustments', { method: 'POST', body: JSON.stringify(data) }),
  update: async (id, data) =>
    apiRequest(`/adjustments/${id}`, { method: 'PUT', body: JSON.stringify(data) }),
  delete: async (id) =>
    apiRequest(`/adjustments/${id}`, { method: 'DELETE' }),
};

/* ======================
   TRANSFERS API
====================== */
export const transfersAPI = {
  getAll: async (params = {}) => {
    const query = new URLSearchParams(params).toString();
    return apiRequest(query ? `/transfers?${query}` : '/transfers');
  },
  getById: async (id) => apiRequest(`/transfers/${id}`),
  create: async (data) =>
    apiRequest('/transfers', { method: 'POST', body: JSON.stringify(data) }),
  update: async (id, data) =>
    apiRequest(`/transfers/${id}`, { method: 'PUT', body: JSON.stringify(data) }),
  receive: async (id, data) =>
    apiRequest(`/transfers/${id}/receive`, { method: 'POST', body: JSON.stringify(data ?? {}) }),
  delete: async (id) =>
    apiRequest(`/transfers/${id}`, { method: 'DELETE' }),
};

/* ======================
   PURCHASE RETURNS API
====================== */
export const purchaseReturnsAPI = {
  getAll: async (params = {}) => {
    const query = new URLSearchParams(params).toString();
    return apiRequest(query ? `/purchase-returns?${query}` : '/purchase-returns');
  },
  getById: async (id) => apiRequest(`/purchase-returns/${id}`),
  create: async (data) =>
    apiRequest('/purchase-returns', { method: 'POST', body: JSON.stringify(data) }),
  update: async (id, data) =>
    apiRequest(`/purchase-returns/${id}`, { method: 'PUT', body: JSON.stringify(data) }),
  delete: async (id) =>
    apiRequest(`/purchase-returns/${id}`, { method: 'DELETE' }),
};

/* ======================
   DELIVERY RECEIPTS API
====================== */
export const deliveryReceiptsAPI = {
  getAll: async (params = {}) => {
    const query = new URLSearchParams(params).toString();
    return apiRequest(query ? `/delivery-receipts?${query}` : '/delivery-receipts');
  },
  getById: async (id) => apiRequest(`/delivery-receipts/${id}`),
  create: async (data) =>
    apiRequest('/delivery-receipts', { method: 'POST', body: JSON.stringify(data) }),
  update: async (id, data) =>
    apiRequest(`/delivery-receipts/${id}`, { method: 'PUT', body: JSON.stringify(data) }),
  delete: async (id) =>
    apiRequest(`/delivery-receipts/${id}`, { method: 'DELETE' }),
};

/* ======================
   WARRANTY CLAIMS API (not in ERD — returns empty gracefully)
====================== */
const _emptyPage = { success: true, data: [], pagination: { total: 0, last_page: 1, per_page: 10, current_page: 1 } };
export const warrantyClaimsAPI = {
  getAll: async () => _emptyPage,
  getById: async () => null,
  create: async () => { throw new Error('Warranty claims are not available in this version.'); },
  update: async () => { throw new Error('Warranty claims are not available in this version.'); },
  delete: async () => { throw new Error('Warranty claims are not available in this version.'); },
};

/* ======================
   CATEGORIES API
====================== */
export const categoriesAPI = {
  getAll: async () => apiRequest('/categories'),
  getPerformance: async () => apiRequest('/categories/performance'),
  getArchived: async () => apiRequest('/categories/archived'),
  create: async (data) =>
    apiRequest('/categories', { method: 'POST', body: JSON.stringify(data) }),
  update: async (id, data) =>
    apiRequest(`/categories/${id}`, { method: 'PUT', body: JSON.stringify(data) }),
  delete: async (id) => apiRequest(`/categories/${id}`, { method: 'DELETE' }),
  restore: async (id) => apiRequest(`/categories/${id}/restore`, { method: 'POST' }),
};

/* ======================
   UNITS API
====================== */
export const unitsAPI = {
  getAll: async (params = {}) => {
    const query = new URLSearchParams(params).toString();
    return apiRequest(query ? `/units?${query}` : '/units');
  },
  getById: async (id) => apiRequest(`/units/${id}`),
  create: async (data) =>
    apiRequest('/units', { method: 'POST', body: JSON.stringify(data) }),
  update: async (id, data) =>
    apiRequest(`/units/${id}`, { method: 'PUT', body: JSON.stringify(data) }),
  delete: async (id) => apiRequest(`/units/${id}`, { method: 'DELETE' }),
};

/* ======================
   BRANDS API
====================== */
export const brandsAPI = {
  getAll: async () => apiRequest('/brands'),
  getArchived: async () => apiRequest('/brands/archived'),
  create: async (data) =>
    apiRequest('/brands', { method: 'POST', body: JSON.stringify(data) }),
  update: async (id, data) =>
    apiRequest(`/brands/${id}`, { method: 'PUT', body: JSON.stringify(data) }),
  delete: async (id) => apiRequest(`/brands/${id}`, { method: 'DELETE' }),
  restore: async (id) => apiRequest(`/brands/${id}/restore`, { method: 'POST' }),
};

/* ======================
   STATUS LOOKUP API
====================== */
export const statusAPI = {
  getAll: async (params = {}) => {
    const query = new URLSearchParams(params).toString();
    return apiRequest(query ? `/status-lookup?${query}` : '/status-lookup');
  },
  getById: async (id) => apiRequest(`/status-lookup/${id}`),
  create: async (data) =>
    apiRequest('/status-lookup', { method: 'POST', body: JSON.stringify(data) }),
  update: async (id, data) =>
    apiRequest(`/status-lookup/${id}`, { method: 'PUT', body: JSON.stringify(data) }),
  delete: async (id) => apiRequest(`/status-lookup/${id}`, { method: 'DELETE' }),
};

/* ======================
   SUPPLIERS API
====================== */
export const suppliersAPI = {
  getAll: async (params = {}) => {
    const query = new URLSearchParams(params).toString();
    return apiRequest(query ? `/suppliers?${query}` : '/suppliers');
  },
  getById: async (id) => apiRequest(`/suppliers/${id}`),
  create: async (data) =>
    apiRequest('/suppliers', { method: 'POST', body: JSON.stringify(data) }),
  update: async (id, data) =>
    apiRequest(`/suppliers/${id}`, { method: 'PUT', body: JSON.stringify(data) }),
  delete: async (id) => apiRequest(`/suppliers/${id}`, { method: 'DELETE' }),
  getProducts: async (id) => apiRequest(`/suppliers/${id}/products`),
  addProduct: async (id, data) =>
    apiRequest(`/suppliers/${id}/products`, { method: 'POST', body: JSON.stringify(data) }),
  updateProduct: async (id, supplierProdId, data) =>
    apiRequest(`/suppliers/${id}/products/${supplierProdId}`, { method: 'PUT', body: JSON.stringify(data) }),
  removeProduct: async (id, productId) =>
    apiRequest(`/suppliers/${id}/products/${productId}`, { method: 'DELETE' }),
};

/* ======================
   ROLES API
====================== */
export const rolesAPI = {
  getAll: async (params = {}) => {
    const query = new URLSearchParams(params).toString();
    return apiRequest(query ? `/roles?${query}` : '/roles');
  },
  getById: async (id) => apiRequest(`/roles/${id}`),
  create: async (data) =>
    apiRequest('/roles', { method: 'POST', body: JSON.stringify(data) }),
  update: async (id, data) =>
    apiRequest(`/roles/${id}`, { method: 'PUT', body: JSON.stringify(data) }),
  delete: async (id) => apiRequest(`/roles/${id}`, { method: 'DELETE' }),
};

/* ======================
   PRODUCTS API (ERD)
====================== */
export const productsAPI = {
  getAll: async (params = {}) => {
    const query = new URLSearchParams(params).toString();
    return apiRequest(query ? `/products?${query}` : '/products');
  },
  getById: async (id) => apiRequest(`/products/${id}`),
  create: async (data) =>
    apiRequest('/products', {
      method: 'POST',
      body: JSON.stringify(data),
    }),
  update: async (id, data) =>
    apiRequest(`/products/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    }),
  delete: async (id) =>
    apiRequest(`/products/${id}`, { method: 'DELETE' }),
};

/* ======================
   USERS API
====================== */
export const usersAPI = {
  getAll: async (params = {}) => {
    const query = new URLSearchParams(params).toString();
    return apiRequest(query ? `/users?${query}` : '/users');
  },
  getById: async (id) => apiRequest(`/users/${id}`),
  create: async (data) =>
    apiRequest('/users', {
      method: 'POST',
      body: JSON.stringify(data),
    }),
  update: async (id, data) =>
    apiRequest(`/users/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    }),
  updateStatus: async (id, statusId) =>
    apiRequest(`/users/${id}/status`, {
      method: 'PUT',
      body: JSON.stringify({ status_id: statusId }),
    }),
  delete: async (id) =>
    apiRequest(`/users/${id}`, { method: 'DELETE' }),
};

/* ======================
   PROFIT LOSS API
====================== */
export const profitLossAPI = {
  getAll: async (params = {}) => {
    const query = new URLSearchParams(params).toString();
    return apiRequest(query ? `/profit-loss?${query}` : '/profit-loss');
  },
  getById: async (id) => apiRequest(`/profit-loss/${id}`),
  create: async (data) =>
    apiRequest('/profit-loss', { method: 'POST', body: JSON.stringify(data) }),
  update: async (id, data) =>
    apiRequest(`/profit-loss/${id}`, { method: 'PUT', body: JSON.stringify(data) }),
  delete: async (id) => apiRequest(`/profit-loss/${id}`, { method: 'DELETE' }),
};

/* ======================
   MODEL LOOKUP API
====================== */
export const modelsAPI = {
  getAll: async (params = {}) => {
    const query = new URLSearchParams(params).toString();
    return apiRequest(query ? `/models?${query}` : '/models');
  },
  getById: async (id) => apiRequest(`/models/${id}`),
  create: async (data) =>
    apiRequest('/models', { method: 'POST', body: JSON.stringify(data) }),
  update: async (id, data) =>
    apiRequest(`/models/${id}`, { method: 'PUT', body: JSON.stringify(data) }),
  delete: async (id) => apiRequest(`/models/${id}`, { method: 'DELETE' }),
};

/* ======================
   BARCODE SCAN API
====================== */
export const barcodeScanAPI = {
  getAll: async (params = {}) => {
    const query = new URLSearchParams(params).toString();
    return apiRequest(query ? `/barcode-scans?${query}` : '/barcode-scans');
  },
  create: async (data) =>
    apiRequest('/barcode-scans', { method: 'POST', body: JSON.stringify(data) }),
};
