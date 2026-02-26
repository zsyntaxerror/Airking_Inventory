import { useState, useEffect, useCallback, useRef } from 'react';
import AdminLayout from '../components/AdminLayout';
import { BrowserMultiFormatReader } from '@zxing/browser';
import {
  itemsAPI, inventoryAPI, categoriesAPI, brandsAPI, modelsAPI,
  receivingsAPI, issuancesAPI, transfersAPI, barcodeScanAPI,
} from '../services/api';
import { toast } from '../utils/toast';
import { useAuth } from '../context/AuthContext';
import '../styles/barcode_scan.css';

/* ─── mode config ─────────────────────────────────── */
const MODES = [
  {
    key: 'receive-po',
    label: 'Receive PO',
    apiLabel: 'RECEIVE PO',
    color: '#10b981',
    bg: '#ecfdf5',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="28" height="28">
        <path d="M5 12h14"/><path d="m12 19-7-7 7-7"/>
      </svg>
    ),
  },
  {
    key: 'issue-out',
    label: 'Issue Out',
    apiLabel: 'ISSUE OUT',
    color: '#3b82f6',
    bg: '#eff6ff',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="28" height="28">
        <path d="M5 12h14"/><path d="m12 5 7 7-7 7"/>
      </svg>
    ),
  },
  {
    key: 'transfer',
    label: 'Transfer',
    apiLabel: 'TRANSFER',
    color: '#f59e0b',
    bg: '#fffbeb',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="28" height="28">
        <path d="M17 3l4 4-4 4"/><path d="M3 7h18"/>
        <path d="M7 21l-4-4 4-4"/><path d="M21 17H3"/>
      </svg>
    ),
  },
  {
    key: 'adjust',
    label: 'Adjust',
    apiLabel: 'ADJUST',
    color: '#ef4444',
    bg: '#fef2f2',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="28" height="28">
        <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
        <line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/>
      </svg>
    ),
  },
];

/* ─── recent movement label helper ───────────────── */
const movementColor = (type = '') => {
  const t = type.toLowerCase();
  if (t.includes('receiv') || t.includes('receive')) return '#10b981';
  if (t.includes('issue') || t.includes('sale'))     return '#3b82f6';
  if (t.includes('transfer'))                         return '#f59e0b';
  if (t.includes('adjust'))                           return '#ef4444';
  return '#6b7280';
};

const BarcodeScan = () => {
  const { user: _user } = useAuth();
  const currentUser = _user || {};

  /* ── view state ── */
  const [scanMode, setScanMode]     = useState(null); // null = home, or MODES[i]
  const [modeIndex, setModeIndex]   = useState(0);

  /* ── scan state ── */
  const [barcodeInput, setBarcodeInput] = useState('');
  const [scanResult,   setScanResult]   = useState(null);
  const [scanning,     setScanning]     = useState(false);
  const [scanHistory,  setScanHistory]  = useState(() => {
    try {
      const saved = localStorage.getItem('bs_scan_history');
      return saved ? JSON.parse(saved) : [];
    } catch { return []; }
  });

  /* ── camera ── */
  const [cameraActive, setCameraActive] = useState(false);
  const [cameraError,  setCameraError]  = useState('');

  /* ── filters ── */
  const [categories,     setCategories]     = useState([]);
  const [brands,         setBrands]         = useState([]);
  const [models,         setModels]         = useState([]);
  const [filterCategory, setFilterCategory] = useState('');
  const [filterBrand,    setFilterBrand]    = useState('');
  const [filterModel,    setFilterModel]    = useState('');
  const [activeType,     setActiveType]     = useState('appliance');

  /* ── home page data ── */
  const [recentMovement, setRecentMovement] = useState([]);

  /* ── refs ── */
  const videoRef      = useRef(null);
  const readerRef     = useRef(null);   // BrowserMultiFormatReader instance
  const controlsRef   = useRef(null);   // ZXing scanning controls (.stop())
  const inputRef      = useRef(null);
  const lastCodeRef   = useRef('');
  const lastTimeRef   = useRef(0);
  const handleScanRef = useRef(null);

  /* ── load filter data ── */
  useEffect(() => {
    categoriesAPI.getAll().then((r) => setCategories(Array.isArray(r.data) ? r.data : [])).catch(() => {});
    brandsAPI.getAll().then((r)     => setBrands(Array.isArray(r.data) ? r.data : [])).catch(() => {});
    modelsAPI.getAll({ per_page: 200 }).then((r) => setModels(Array.isArray(r.data) ? r.data : [])).catch(() => {});
  }, []);

  /* ── load recent movement for home page ── */
  useEffect(() => {
    if (scanMode !== null) return;
    const load = async () => {
      try {
        const [recRes, issRes, trRes] = await Promise.allSettled([
          receivingsAPI.getAll({ per_page: 3, sort: 'desc' }),
          issuancesAPI.getAll({ per_page: 3, sort: 'desc' }),
          transfersAPI.getAll({ per_page: 3, sort: 'desc' }),
        ]);
        const all = [];
        const extract = (res, type) => {
          if (res.status === 'fulfilled') {
            const items = Array.isArray(res.value?.data) ? res.value.data : [];
            items.forEach((item) => all.push({ ...item, _type: type }));
          }
        };
        extract(recRes, 'RECEIVE');
        extract(issRes, 'ISSUE');
        extract(trRes,  'TRANSFER');
        all.sort((a, b) => {
          const da = new Date(b.created_at || b.transaction_date || 0);
          const db = new Date(a.created_at || a.transaction_date || 0);
          return da - db;
        });
        setRecentMovement(all.slice(0, 5));
      } catch {}
    };
    load();
  }, [scanMode]);

  /* ── scan handler ── */
  const handleScan = useCallback(async (barcode) => {
    const code = (barcode || '').trim();
    if (!code) return;
    setScanning(true);
    try {
      const params = { barcode: code };
      if (activeType !== 'all')  params.product_type = activeType;
      if (filterCategory)        params.category_id  = filterCategory;
      if (filterBrand)           params.brand_id     = filterBrand;
      if (filterModel)           params.model_id     = filterModel;

      const itemRes = await itemsAPI.getAll(params);
      const items   = Array.isArray(itemRes.data) ? itemRes.data : [];

      if (items.length === 0) {
        toast.error(`No item found for barcode: ${code}`);
        return;
      }

      const item = items[0];

      let inventory = null;
      try {
        const invRes  = await inventoryAPI.getAll({ product_id: item.product_id ?? item.id, per_page: 1 });
        const invList = Array.isArray(invRes.data) ? invRes.data : [];
        if (invList.length > 0) inventory = invList[0];
      } catch {}

      const mode   = scanMode || MODES[modeIndex];
      const result = {
        item,
        inventory,
        barcode:   code,
        mode:      mode.apiLabel,
        modeKey:   mode.key,
        scannedAt: new Date().toLocaleString(),
        scannedBy: currentUser.first_name
          ? `${currentUser.first_name} ${currentUser.last_name || ''}`.trim()
          : (currentUser.username || 'System Administrator'),
      };

      setScanResult(result);
      setScanHistory((prev) => {
        const next = [result, ...prev.slice(0, 49)];
        try { localStorage.setItem('bs_scan_history', JSON.stringify(next)); } catch {}
        return next;
      });
      setBarcodeInput('');
      setTimeout(() => inputRef.current?.focus(), 50);

      /* ── save to DB (graceful fallback) ── */
      try {
        await barcodeScanAPI.create({
          barcode:    code,
          product_id: item.product_id ?? item.id,
          scan_mode:  mode.key,
          scanned_at: new Date().toISOString(),
        });
      } catch {}

    } catch (err) {
      toast.error(err.message || 'Scan failed');
    } finally {
      setScanning(false);
    }
  }, [activeType, filterCategory, filterBrand, filterModel, modeIndex, scanMode, currentUser]);

  useEffect(() => { handleScanRef.current = handleScan; }, [handleScan]);

  /* ── camera ── */
  const startCamera = async () => {
    setCameraError('');
    try {
      readerRef.current = new BrowserMultiFormatReader();
      const controls = await readerRef.current.decodeFromVideoDevice(
        undefined,           // use default camera
        videoRef.current,
        (result, err) => {
          if (result) {
            const code = result.getText();
            const now  = Date.now();
            if (code !== lastCodeRef.current || now - lastTimeRef.current > 3000) {
              lastCodeRef.current = code;
              lastTimeRef.current = now;
              handleScanRef.current?.(code);
            }
          }
        }
      );
      controlsRef.current = controls;
      setCameraActive(true);
    } catch {
      setCameraError('Camera access denied. Use manual entry.');
    }
  };

  const stopCamera = () => {
    controlsRef.current?.stop();
    controlsRef.current = null;
    readerRef.current   = null;
    setCameraActive(false);
  };

  useEffect(() => () => { controlsRef.current?.stop(); }, []);

  /* ── select a mode and enter scan view ── */
  const selectMode = (mode, idx) => {
    setScanMode(mode);
    setModeIndex(idx);
    setScanResult(null);
    setBarcodeInput('');
    setTimeout(() => inputRef.current?.focus(), 100);
  };

  const exitScanMode = () => {
    stopCamera();
    setScanMode(null);
    setScanResult(null);
    setBarcodeInput('');
  };

  /* ── helpers ── */
  const qty    = (inv) => inv?.quantity ?? inv?.qty ?? null;
  const price  = (item) => Number(item?.unit_price ?? item?.price ?? 0);
  const branch    = (inv) => inv?.branch?.branch_name ?? inv?.branch_name ?? null;
  const warehouse = (inv) => inv?.warehouse?.warehouse_name ?? inv?.location?.location_name ?? inv?.location_name ?? null;
  const locCode   = (inv) => inv?.location_code ?? inv?.shelf_code ?? inv?.aisle ?? null;
  const stockSt   = (inv) => inv?.status?.status_name ?? inv?.stock_status ?? null;
  const isLow     = (inv) => (stockSt(inv) || '').toLowerCase().includes('low');

  /* ── mode-aware field labels ── */
  const getModeLabels = (modeKey) => {
    switch (modeKey) {
      case 'receive-po': return { branch: 'Receiving Branch', warehouse: 'Destination Warehouse', location: 'Storage Location' };
      case 'transfer':   return { branch: 'Destination (Showroom)', warehouse: 'From Warehouse',       location: 'Transfer Location' };
      case 'issue-out':  return { branch: 'Issued To (Branch)',     warehouse: 'From Warehouse',       location: 'Current Location' };
      case 'adjust':
      default:           return { branch: 'Branch',                 warehouse: 'Warehouse',            location: 'Location' };
    }
  };

  /* ─────────────────────────────────────────────
     RENDER: HOME VIEW
  ───────────────────────────────────────────── */
  if (scanMode === null) {
    return (
      <AdminLayout>
        <div className="bs-page">
          <div className="bs-page-header">
            <h1>Scan Barcode</h1>
            <p>Scan product barcodes to view item details and perform lookups</p>
          </div>

          {/* ── mode action cards ── */}
          <div className="bs-mode-cards">
            {MODES.map((m, idx) => (
              <button
                key={m.key}
                className="bs-mode-card"
                style={{ '--mc': m.color, '--mc-bg': m.bg }}
                onClick={() => selectMode(m, idx)}
                type="button"
              >
                <span className="bs-mc-icon" style={{ color: m.color }}>{m.icon}</span>
                <span className="bs-mc-label">{m.label}</span>
              </button>
            ))}
          </div>

          {/* ── scan history ── */}
          {scanHistory.length > 0 && (
            <div className="bs-home-card">
              <div className="bs-home-card-head">
                <span className="bs-home-card-title">Scan History</span>
                <span className="bs-home-card-sub">Recent scans</span>
              </div>
              <div className="bs-history-list">
                {scanHistory.map((h, i) => {
                  const hMode = MODES.find(m => m.key === h.modeKey);
                  return (
                    <div key={i} className="bs-history-item" onClick={() => { selectMode(hMode || MODES[0], MODES.findIndex(m => m.key === h.modeKey) || 0); setScanResult(h); }}>
                      <div className="bs-hi-left">
                        <span className="bs-hi-name">{h.item.product_name || h.item.name}</span>
                        <span className="bs-hi-code">{h.barcode}</span>
                        <span className="bs-hi-time">{h.scannedAt}</span>
                      </div>
                      <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'flex-end', gap: 4 }}>
                        <span style={{
                          fontSize: '0.6rem', fontWeight: 700, letterSpacing: '0.05em',
                          color: hMode?.color || '#6b7280',
                          background: hMode?.bg || '#f3f4f6',
                          padding: '2px 8px', borderRadius: 4, whiteSpace: 'nowrap',
                        }}>
                          {h.mode}
                        </span>
                        {h.inventory && (
                          <span className={`bs-status-chip${isLow(h.inventory) ? ' low' : ''}`}>
                            {stockSt(h.inventory) || 'In Stock'}
                          </span>
                        )}
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          )}

          {/* ── recent movement ── */}
          {recentMovement.length > 0 && (
            <div className="bs-home-card">
              <div className="bs-home-card-head">
                <span className="bs-home-card-title">Recent Movement</span>
                <button className="bs-viewall" type="button">VIEW ALL</button>
              </div>
              <div className="bs-movement-list">
                {recentMovement.map((m, i) => {
                  const ref = m.receiving_code || m.issuance_code || m.transfer_code || m.reference_number || `#${m.id || i}`;
                  const label = `${m._type} ${ref}`.trim();
                  const when  = m.created_at
                    ? new Date(m.created_at).toLocaleString()
                    : m.transaction_date || '';
                  return (
                    <div key={i} className="bs-movement-item">
                      <span className="bs-movement-dot" style={{ background: movementColor(m._type) }} />
                      <div className="bs-movement-info">
                        <span className="bs-movement-label">{label}</span>
                        {when && <span className="bs-movement-time">{when}</span>}
                      </div>
                      <span className="bs-success-chip">Success</span>
                    </div>
                  );
                })}
              </div>
            </div>
          )}
        </div>
      </AdminLayout>
    );
  }

  /* ─────────────────────────────────────────────
     RENDER: SCAN VIEW
  ───────────────────────────────────────────── */
  return (
    <AdminLayout>
      <div className="bs-page">
        <div className="bs-page-header" style={{ display: 'flex', alignItems: 'flex-start', gap: 12 }}>
          <button className="bs-topback-btn" onClick={exitScanMode} type="button">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="15" height="15"><polyline points="15 18 9 12 15 6"/></svg>
            Back
          </button>
          <div>
            <h1>Scan Barcode</h1>
            <p>Scan product barcodes to view item details and perform lookups</p>
          </div>
        </div>

        {/* ── camera box ── */}
        <div className="bs-camera-box">
          {/* mode bar inside camera */}
          <div className="bs-cam-modebar">
            <button className="bs-cam-arrow" onClick={() => { const ni = (modeIndex - 1 + MODES.length) % MODES.length; setModeIndex(ni); setScanMode(MODES[ni]); }} type="button">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" width="14" height="14"><polyline points="15 18 9 12 15 6"/></svg>
            </button>
            <div className="bs-cam-modename">
              <span>{MODES[modeIndex].label.toUpperCase()}</span>
              <span className="bs-cam-modesub">SCANNING BARCODES</span>
            </div>
            <button className="bs-cam-arrow" onClick={() => { const ni = (modeIndex + 1) % MODES.length; setModeIndex(ni); setScanMode(MODES[ni]); }} type="button">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" width="14" height="14"><polyline points="9 18 15 12 9 6"/></svg>
            </button>
          </div>

          {/* video always in DOM so ZXing can access videoRef before camera starts */}
          <video
            ref={videoRef}
            className="bs-video"
            autoPlay
            muted
            playsInline
            style={{ display: cameraActive ? 'block' : 'none' }}
          />
          {!cameraActive && (
            <div className="bs-cam-idle">
              <div className="bs-cam-icon-wrap">
                <svg viewBox="0 0 24 24" fill="none" stroke="rgba(255,255,255,0.6)" strokeWidth="1.5" width="38" height="38">
                  <path d="M23 7l-7 5 7 5V7z"/>
                  <rect x="1" y="5" width="15" height="14" rx="2" ry="2"/>
                </svg>
              </div>
            </div>
          )}

          {/* corner brackets */}
          <div className="bs-bracket bs-tl"/><div className="bs-bracket bs-tr"/>
          <div className="bs-bracket bs-bl"/><div className="bs-bracket bs-br"/>

          {/* scan line */}
          {cameraActive && <div className="bs-scan-line"/>}

          {/* camera error */}
          {cameraError && <p className="bs-cam-err">{cameraError}</p>}

          {/* camera button */}
          {cameraActive
            ? <button className="bs-cam-btn bs-cam-stop" onClick={stopCamera} type="button">Stop Camera</button>
            : <button className="bs-cam-btn bs-cam-start" onClick={startCamera} type="button">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="14" height="14">
                  <path d="M23 7l-7 5 7 5V7z"/><rect x="1" y="5" width="15" height="14" rx="2" ry="2"/>
                </svg>
                Start Camera
              </button>
          }

          {/* back button */}
          <button className="bs-back-btn" onClick={exitScanMode} type="button">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="14" height="14"><polyline points="15 18 9 12 15 6"/></svg>
            Back
          </button>
        </div>

        {/* ── barcode input ── */}
        <div className="bs-input-section">
          <p className="bs-input-title">Barcode Scanner</p>
          <p className="bs-input-sub">Enter or scan a product barcode</p>
          <div className="bs-input-row">
            <div className="bs-input-icon">
              <svg viewBox="0 0 24 24" fill="none" stroke="#9ca3af" strokeWidth="1.5" width="16" height="16">
                <rect x="3" y="5" width="3" height="14" rx="1"/><rect x="8" y="5" width="1.5" height="14" rx="0.5"/>
                <rect x="11" y="5" width="3" height="14" rx="1"/><rect x="16" y="5" width="1.5" height="14" rx="0.5"/>
                <rect x="19" y="5" width="2" height="14" rx="1"/>
              </svg>
            </div>
            <input
              ref={inputRef}
              type="text"
              className="bs-barcode-input"
              placeholder="Scan serial number..."
              value={barcodeInput}
              onChange={(e) => setBarcodeInput(e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && handleScan(barcodeInput)}
              disabled={scanning}
              autoFocus
            />
            {scanning && <span className="bs-spin"/>}
          </div>
        </div>

        {/* ── type tabs ── */}
        <div className="bs-type-row">
          <button className={`bs-type-btn${activeType === 'appliance' ? ' active' : ''}`} onClick={() => setActiveType('appliance')} type="button">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="13" height="13"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg>
            UNIT / APPLIANCE
          </button>
          <button className={`bs-type-btn${activeType === 'consumable' ? ' active' : ''}`} onClick={() => setActiveType('consumable')} type="button">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" width="13" height="13"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
            PART / CONSUMABLE
          </button>
        </div>

        {/* ── filter dropdowns ── */}
        <div className="bs-filters">
          <div className="bs-filter-col">
            <label>CATEGORY</label>
            <select value={filterCategory} onChange={(e) => setFilterCategory(e.target.value)}>
              <option value="">All</option>
              {categories.map((c) => <option key={c.category_id} value={c.category_id}>{c.category_name}</option>)}
            </select>
          </div>
          <div className="bs-filter-col">
            <label>BRAND</label>
            <select value={filterBrand} onChange={(e) => setFilterBrand(e.target.value)}>
              <option value="">All</option>
              {brands.map((b) => <option key={b.brand_id} value={b.brand_id}>{b.brand_name}</option>)}
            </select>
          </div>
          <div className="bs-filter-col">
            <label>MODEL CODE</label>
            <select value={filterModel} onChange={(e) => setFilterModel(e.target.value)}>
              <option value="">All</option>
              {models.map((m) => <option key={m.model_id ?? m.id} value={m.model_id ?? m.id}>{m.model_name ?? m.name}</option>)}
            </select>
          </div>
        </div>

        {/* ── scan result card ── */}
        {scanResult && (() => {
          const lbl = getModeLabels(scanResult.modeKey);
          return (
            <div className="bs-result-card">
              <div className="bs-result-head">
                <div className="bs-check-circle">
                  <svg viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="3" width="13" height="13"><polyline points="20 6 9 17 4 12"/></svg>
                </div>
                <h3 className="bs-result-name">{scanResult.item.product_name || scanResult.item.name}</h3>
              </div>
              <div className="bs-result-grid">
                {/* Left column */}
                <div className="bs-result-col">
                  <div className="bs-result-cell">
                    <span className="bs-rk">SKU</span>
                    <span className="bs-rv">{scanResult.item.product_code || scanResult.item.code || '—'}</span>
                  </div>
                  <div className="bs-result-cell">
                    <span className="bs-rk">Category</span>
                    <span className="bs-rv">{scanResult.item.category?.category_name || '—'}</span>
                  </div>
                  {scanResult.inventory && (
                    <>
                      <div className="bs-result-cell">
                        <span className="bs-rk">{lbl.branch}</span>
                        <span className="bs-rv">{branch(scanResult.inventory) || '—'}</span>
                      </div>
                      <div className="bs-result-cell">
                        <span className="bs-rk">{lbl.location}</span>
                        <span className="bs-rv">{locCode(scanResult.inventory) || '—'}</span>
                      </div>
                      <div className="bs-result-cell">
                        <span className="bs-rk">Unit Price</span>
                        <span className="bs-rv">₱{price(scanResult.item).toLocaleString()}</span>
                      </div>
                      <div className="bs-result-cell">
                        <span className="bs-rk">Status</span>
                        <span className={`bs-status-chip${isLow(scanResult.inventory) ? ' low' : ''}`}>
                          {stockSt(scanResult.inventory) || 'In Stock'}
                        </span>
                      </div>
                    </>
                  )}
                </div>
                {/* Right column */}
                <div className="bs-result-col">
                  <div className="bs-result-cell">
                    <span className="bs-rk">Barcode</span>
                    <span className="bs-rv bs-mono">{scanResult.barcode}</span>
                  </div>
                  <div className="bs-result-cell">
                    <span className="bs-rk">Brand</span>
                    <span className="bs-rv">{scanResult.item.brand?.brand_name || '—'}</span>
                  </div>
                  {scanResult.inventory && (
                    <>
                      <div className="bs-result-cell">
                        <span className="bs-rk">{lbl.warehouse}</span>
                        <span className="bs-rv">{warehouse(scanResult.inventory) || '—'}</span>
                      </div>
                      <div className="bs-result-cell">
                        <span className="bs-rk">Quantity</span>
                        <span className="bs-rv">{qty(scanResult.inventory) !== null ? `${qty(scanResult.inventory)} units` : '—'}</span>
                      </div>
                      <div className="bs-result-cell">
                        <span className="bs-rk">Total Value</span>
                        <span className="bs-rv">₱{((qty(scanResult.inventory) ?? 0) * price(scanResult.item)).toLocaleString()}</span>
                      </div>
                      <div className="bs-result-cell">
                        <span className="bs-rk">Item Type</span>
                        <span className="bs-rv" style={{ textTransform: 'capitalize' }}>{scanResult.item.product_type || '—'}</span>
                      </div>
                    </>
                  )}
                </div>
              </div>
              <p className="bs-timestamp">
                Scanned at {scanResult.scannedAt} — By: {scanResult.scannedBy}
              </p>
            </div>
          );
        })()}

        {/* ── session scan history (scan view) ── */}
        {scanHistory.length > 0 && (
          <div className="bs-home-card" style={{ marginTop: 16 }}>
            <div className="bs-home-card-head">
              <span className="bs-home-card-title">Session History</span>
              <span className="bs-home-card-sub">{scanHistory.length} scan{scanHistory.length !== 1 ? 's' : ''} this session</span>
            </div>
            <div className="bs-history-list">
              {scanHistory.map((h, i) => (
                <div
                  key={i}
                  className="bs-history-item"
                  onClick={() => setScanResult(h)}
                  style={{ opacity: scanResult?.barcode === h.barcode && scanResult?.scannedAt === h.scannedAt ? 1 : 0.75 }}
                >
                  <div className="bs-hi-left">
                    <span className="bs-hi-name">{h.item.product_name || h.item.name}</span>
                    <span className="bs-hi-code">{h.barcode}</span>
                    <span className="bs-hi-time">{h.scannedAt}</span>
                  </div>
                  <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'flex-end', gap: 4 }}>
                    <span style={{ fontSize: '0.6rem', fontWeight: 700, color: MODES.find(m => m.key === h.modeKey)?.color || '#6b7280', letterSpacing: '0.04em' }}>
                      {h.mode}
                    </span>
                    <span className={`bs-status-chip${isLow(h.inventory) ? ' low' : ''}`}>
                      {h.inventory ? (stockSt(h.inventory) || 'In Stock') : '—'}
                    </span>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}
      </div>
    </AdminLayout>
  );
};

export default BarcodeScan;
