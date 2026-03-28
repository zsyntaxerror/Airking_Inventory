import { useState, useEffect, useCallback, useMemo, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import AdminLayout from '../components/AdminLayout';
import { BrowserMultiFormatReader, DecodeHintType, BarcodeFormat } from '@zxing/library';
import {
  itemsAPI, productsAPI, inventoryAPI, categoriesAPI, brandsAPI, modelsAPI,
  receivingsAPI, issuancesAPI, transfersAPI, adjustmentsAPI, barcodeScanAPI, locationsAPI, purchaseOrdersAPI,
} from '../services/api';
import { toast } from '../utils/toast';
import { useAuth } from '../context/AuthContext';
import { getApprovalQueuePurchaseOrders, APPROVAL_QUEUE_STORAGE_KEY } from '../utils/approvalNotifications';
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

/** List Carmen-named showrooms first in the transfer destination dropdown */
const sortLocationsCarmenFirst = (list) => {
  const arr = [...(list || [])];
  arr.sort((a, b) => {
    const na = String(a.location_name || a.name || '').toLowerCase();
    const nb = String(b.location_name || b.name || '').toLowerCase();
    const score = (n) => (n.includes('carmen') ? 0 : 1);
    const diff = score(na) - score(nb);
    if (diff !== 0) return diff;
    return na.localeCompare(nb);
  });
  return arr;
};

const findCarmenLocationId = (list) => {
  const hit = (list || []).find((l) => {
    const n = String(l.location_name || l.name || '').toLowerCase();
    return n.includes('carmen');
  });
  if (!hit) return '';
  return String(hit.id ?? hit.location_id ?? '');
};

const inventoryRowLocationId = (row) =>
  row?.location_id ?? row?.location?.location_id ?? '';

/**
 * Pick stock row for the selected warehouse/location.
 * If locationId is set but there is no row for that location, returns null (do not show another site's qty).
 * If locationId is empty, prefer a warehouse row, else first row.
 */
const pickInventoryForLocation = (rows, locationId) => {
  if (!Array.isArray(rows) || rows.length === 0) return null;
  if (locationId) {
    const hit = rows.find((r) => String(inventoryRowLocationId(r)) === String(locationId));
    return hit || null;
  }
  const wh = rows.find((r) => String(r?.location?.location_type || '').toLowerCase() === 'warehouse');
  return wh || rows[0];
};

const startOfLocalDay = (value) => {
  const d = new Date(value);
  if (Number.isNaN(d.getTime())) return null;
  d.setHours(0, 0, 0, 0);
  return d.getTime();
};

/**
 * Block Receive PO when status is not approved-like or before expected_delivery_date (API POs).
 * Local Approval Queue POs are not listed here until they exist in the API as purchase_orders rows.
 */
const getReceivePoBlockReason = (po) => {
  if (!po) return 'Selected purchase order was not found.';
  const statusName = String(po.status?.status_name ?? po.status_name ?? '').toLowerCase();
  if (statusName && /reject|cancel|void|denied|closed/.test(statusName)) {
    return 'This purchase order cannot be used for receiving.';
  }
  if (
    statusName
    && /pending|draft|awaiting|submitted/.test(statusName)
    && !/author|approv|complete|active|received|confirmed/.test(statusName)
  ) {
    return 'This PO is not approved yet. Approve it (or set status to authorized) before receiving.';
  }
  const rawExp = po.expected_delivery_date;
  if (!rawExp) return null;
  const expMs = startOfLocalDay(rawExp);
  const todayMs = startOfLocalDay(new Date());
  if (expMs == null || todayMs == null) return null;
  if (todayMs < expMs) {
    const days = Math.ceil((expMs - todayMs) / 86400000);
    const label = new Date(expMs).toLocaleDateString('en-PH', { year: 'numeric', month: 'short', day: 'numeric' });
    return `Receiving is blocked until the expected arrival date (${label}, in ${days} day(s)).`;
  }
  return null;
};

/** Merge API PO list with locally synced approved POs (so Receive PO shows them even if GET lags or misses a row). */
const mergeSyncedLocalPurchaseOrders = (apiRows) => {
  const list = Array.isArray(apiRows) ? [...apiRows] : [];
  const byId = new Map(
    list
      .map((r) => [String(r.po_id ?? r.id ?? ''), r])
      .filter(([k]) => k && k !== 'undefined'),
  );
  try {
    getApprovalQueuePurchaseOrders().forEach((p) => {
      const st = String(p.status || '').toLowerCase();
      if (st !== 'authorized' || !p.synced_to_api) return;
      const bid = p.backend_po_id ?? p.po_id;
      if (bid == null || bid === '') return;
      const sid = String(bid);
      if (byId.has(sid)) return;
      byId.set(sid, {
        po_id: Number(bid),
        po_number: p.po_number,
        expected_delivery_date: p.expected_delivery_date ?? null,
        status: { status_name: 'Authorized' },
        supplier: typeof p.supplier === 'string' ? { supplier_name: p.supplier } : (p.supplier || null),
      });
    });
  } catch {
    /* ignore */
  }
  return Array.from(byId.values());
};

const BarcodeScan = () => {
  const navigate = useNavigate();
  const { user: _user } = useAuth();
  const scannedByName = useMemo(() => {
    const currentUser = _user || {};
    if (currentUser.first_name) {
      return `${currentUser.first_name} ${currentUser.last_name || ''}`.trim();
    }
    return currentUser.username || 'System Administrator';
  }, [_user]);

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
  const [lastDecoded, setLastDecoded] = useState('');

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
  const [locations, setLocations] = useState([]);
  const [purchaseOrders, setPurchaseOrders] = useState([]);
  const [txSubmitting, setTxSubmitting] = useState(false);
  const [txLogs, setTxLogs] = useState([]);
  const [transferSubmode, setTransferSubmode] = useState('out'); // 'out' = ship from warehouse, 'in' = receive at showroom
  const [inTransitTransfers, setInTransitTransfers] = useState([]);
  const [txForm, setTxForm] = useState({
    quantity: 1,
    condition: 'Good',
    location_id: '',
    to_location_id: '',
    pc_id: '',
    adjustment_direction: 'deduct',
    ship_transfer_first: true,
    pending_transfer_id: '',
  });

  /** Product IDs allowed for the currently selected PO (Receive PO only). */
  const [receivePoProductIds, setReceivePoProductIds] = useState([]);
  const [receivePoLinesLoading, setReceivePoLinesLoading] = useState(false);

  const transferDestinationLocations = useMemo(
    () => sortLocationsCarmenFirst(locations),
    [locations],
  );

  const loadPurchaseOrders = useCallback(() => {
    purchaseOrdersAPI
      .getAll({ per_page: 500 })
      .then((r) => {
        const rows = Array.isArray(r.data) ? r.data : [];
        setPurchaseOrders(mergeSyncedLocalPurchaseOrders(rows));
      })
      .catch(() => {
        setPurchaseOrders(mergeSyncedLocalPurchaseOrders([]));
      });
  }, []);

  /* ── refs ── */
  const videoRef      = useRef(null);
  const readerRef     = useRef(null);   // BrowserMultiFormatReader instance
  const inputRef      = useRef(null);
  const lastCodeRef   = useRef('');
  const lastTimeRef   = useRef(0);
  const handleScanRef = useRef(null);

  /* ── load filter data ── */
  useEffect(() => {
    categoriesAPI.getAll().then((r) => setCategories(Array.isArray(r.data) ? r.data : [])).catch(() => {});
    brandsAPI.getAll().then((r)     => setBrands(Array.isArray(r.data) ? r.data : [])).catch(() => {});
    modelsAPI.getAll({ per_page: 200 }).then((r) => setModels(Array.isArray(r.data) ? r.data : [])).catch(() => {});
    locationsAPI.getAll({ per_page: 500 }).then((r) => setLocations(Array.isArray(r.data) ? r.data : [])).catch(() => {});
  }, []);

  useEffect(() => {
    loadPurchaseOrders();
    const onApproval = () => loadPurchaseOrders();
    window.addEventListener('approval-notifications-updated', onApproval);
    const onStorage = (e) => {
      if (e.key === APPROVAL_QUEUE_STORAGE_KEY) loadPurchaseOrders();
    };
    window.addEventListener('storage', onStorage);
    return () => {
      window.removeEventListener('approval-notifications-updated', onApproval);
      window.removeEventListener('storage', onStorage);
    };
  }, [loadPurchaseOrders]);

  const effectiveModeKey = (scanMode || MODES[modeIndex])?.key;
  useEffect(() => {
    if (effectiveModeKey !== 'receive-po') return;
    loadPurchaseOrders();
  }, [effectiveModeKey, loadPurchaseOrders]);

  /* Load PO line items so scans can be restricted to products on that PO only. */
  useEffect(() => {
    if (scanMode?.key !== 'receive-po' || !txForm.pc_id) {
      setReceivePoProductIds([]);
      setReceivePoLinesLoading(false);
      return;
    }
    let cancelled = false;
    setReceivePoLinesLoading(true);
    setReceivePoProductIds([]);
    purchaseOrdersAPI
      .getById(txForm.pc_id)
      .then((res) => {
        const po = res?.data;
        const details = Array.isArray(po?.details) ? po.details : [];
        const ids = [
          ...new Set(
            details
              .map((d) => Number(d.product_id))
              .filter((n) => Number.isFinite(n) && n > 0),
          ),
        ];
        if (!cancelled) setReceivePoProductIds(ids);
      })
      .catch(() => {
        if (!cancelled) {
          setReceivePoProductIds([]);
          toast.error('Could not load line items for this PO. Re-select the PO or check your connection.');
        }
      })
      .finally(() => {
        if (!cancelled) setReceivePoLinesLoading(false);
      });
    return () => {
      cancelled = true;
    };
  }, [scanMode?.key, txForm.pc_id]);

  /* Changing PO clears the current scan so the UI does not show a product from the wrong batch. */
  useEffect(() => {
    if (scanMode?.key !== 'receive-po') return;
    setScanResult(null);
    setBarcodeInput('');
  }, [txForm.pc_id, scanMode?.key]);

  /* Default transfer destination to Carmen Showroom when available */
  useEffect(() => {
    const mode = scanMode || MODES[modeIndex];
    if (!mode || mode.key !== 'transfer') return;
    if (!locations.length || txForm.to_location_id) return;
    const carmenId = findCarmenLocationId(locations);
    if (carmenId) setTxForm((p) => ({ ...p, to_location_id: carmenId }));
  }, [locations, scanMode, modeIndex, txForm.to_location_id]);

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
    const code = String(barcode || '').replace(/\s+/g, '').trim();
    if (!code) return;
    setBarcodeInput(code);
    setScanning(true);
    try {
      const modeEarly = scanMode || MODES[modeIndex];
      if (modeEarly?.key === 'receive-po') {
        if (!txForm.pc_id) {
          toast.error('Select a Purchase Order before scanning.');
          return;
        }
        if (!txForm.location_id) {
          toast.error('Select a location before scanning.');
          return;
        }
        if (receivePoLinesLoading) {
          toast.error('Loading PO line items — try again in a moment.');
          return;
        }
        if (receivePoProductIds.length === 0) {
          toast.error('This PO has no line items loaded. Re-select the PO or pick another order.');
          return;
        }
      }

      const toEan13From12 = (v) => {
        if (!/^\d{12}$/.test(v)) return null;
        const sum = v.split('').map(Number).reduce((acc, d, idx) => acc + (idx % 2 === 0 ? d : d * 3), 0);
        const checksum = (10 - (sum % 10)) % 10;
        return `${v}${checksum}`;
      };
      const candidates = Array.from(new Set([
        code,
        code.toUpperCase(),
        code.replace(/[^0-9A-Za-z]/g, ''),
        code.replace(/\D/g, ''),
        toEan13From12(code.replace(/\D/g, '')),
      ].filter(Boolean)));
      const normalizedSet = new Set(candidates.map((v) => String(v).toUpperCase()));
      const exactMatch = (row) => {
        const bc = String(row?.barcode ?? '').trim().toUpperCase();
        const pc = String(row?.product_code ?? '').trim().toUpperCase();
        return normalizedSet.has(bc) || normalizedSet.has(pc);
      };
      const applyLocalFilters = (row) => {
        if (activeType !== 'all' && (row?.product_type || '').toLowerCase() !== String(activeType).toLowerCase()) return false;
        if (filterCategory && String(row?.category_id ?? row?.category?.category_id ?? '') !== String(filterCategory)) return false;
        if (filterBrand && String(row?.brand_id ?? row?.brand?.brand_id ?? '') !== String(filterBrand)) return false;
        if (filterModel && String(row?.model_id ?? row?.model?.model_id ?? row?.model?.id ?? '') !== String(filterModel)) return false;
        return true;
      };

      let item = null;
      let preloadedInventoryRows = null;

      // 1) Backend exact match (barcode OR product_code) — avoids LIKE/pagination misses.
      try {
        const locForScan =
          (scanMode || MODES[modeIndex])?.key === 'transfer' && transferSubmode === 'in'
            ? txForm.to_location_id
            : txForm.location_id;
        const scanRes = await inventoryAPI.scanBarcode(code, locForScan || undefined);
        const payload = scanRes?.data;
        if (payload?.product) {
          item = payload.product;
          preloadedInventoryRows = Array.isArray(payload.inventory) ? payload.inventory : [];
        }
      } catch {
        /* 404 / network — fall through to search */
      }

      // 2) Products search + exact match on barcode or product_code
      if (!item) {
        const strictParams = { search: candidates[0], per_page: 50 };
        if (activeType !== 'all') strictParams.product_type = activeType;
        if (filterCategory) strictParams.category_id = filterCategory;
        if (filterBrand) strictParams.brand_id = filterBrand;
        if (filterModel) strictParams.model_id = filterModel;

        const strictRes = await productsAPI.getAll(strictParams);
        let strictItems = Array.isArray(strictRes.data) ? strictRes.data : [];
        item = strictItems.find((row) => exactMatch(row) && applyLocalFilters(row));

        if (!item) {
          const wideRes = await productsAPI.getAll({ search: candidates[0], per_page: 100 });
          const wideItems = Array.isArray(wideRes.data) ? wideRes.data : [];
          item = wideItems.find(exactMatch);
        }

        if (!item) {
          const legacyRes = await itemsAPI.getAll({ search: candidates[0], per_page: 100 });
          const legacyItems = Array.isArray(legacyRes.data) ? legacyRes.data : [];
          item = legacyItems.find(exactMatch);
        }
      }

      if (!item) {
        toast.error(`No item found for barcode: ${code}`);
        return;
      }

      const modeAfterItem = scanMode || MODES[modeIndex];
      if (modeAfterItem?.key === 'receive-po') {
        const pid = Number(item.product_id ?? item.id);
        if (!Number.isFinite(pid) || pid <= 0) {
          toast.error('Invalid product on this scan. Try another barcode.');
          return;
        }
        if (!receivePoProductIds.includes(pid)) {
          toast.error(
            'This product is not on the selected Purchase Order. Only items listed on that PO can be scanned for receiving.',
          );
          return;
        }
      }

      let inventoryRows = [];
      let inventory = null;
      try {
        if (preloadedInventoryRows && preloadedInventoryRows.length) {
          inventoryRows = preloadedInventoryRows;
        } else {
          const invRes = await inventoryAPI.getAll({ product_id: item.product_id ?? item.id, per_page: 500 });
          inventoryRows = Array.isArray(invRes.data) ? invRes.data : [];
        }
        const modeForPick = scanMode || MODES[modeIndex];
        const locForPick =
          modeForPick?.key === 'transfer' && transferSubmode === 'in'
            ? txForm.to_location_id
            : txForm.location_id;
        inventory = pickInventoryForLocation(inventoryRows, locForPick)
          || pickInventoryForLocation(inventoryRows, txForm.location_id)
          || pickInventoryForLocation(inventoryRows, '');
      } catch {}

      const mode   = scanMode || MODES[modeIndex];
      const result = {
        item,
        inventory,
        inventoryRows,
        barcode:   code,
        mode:      mode.apiLabel,
        modeKey:   mode.key,
        scannedAt: new Date().toLocaleString(),
        scannedBy: scannedByName,
      };

      setScanResult(result);
      setTxLogs([]);
      setScanHistory((prev) => {
        const next = [result, ...prev.slice(0, 49)];
        try { localStorage.setItem('bs_scan_history', JSON.stringify(next)); } catch {}
        return next;
      });
      setBarcodeInput(code);
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
  }, [
    activeType,
    filterCategory,
    filterBrand,
    filterModel,
    modeIndex,
    scanMode,
    scannedByName,
    txForm.location_id,
    txForm.to_location_id,
    txForm.pc_id,
    transferSubmode,
    receivePoProductIds,
    receivePoLinesLoading,
  ]);

  useEffect(() => { handleScanRef.current = handleScan; }, [handleScan]);

  /* ── camera ──
     ZXing's decodeFromConstraints resolves to undefined — there is no .stop() handle.
     Use reader.reset() to stop tracks and the decode loop. Keep the <video> visible
     while starting so videoWidth/height are non-zero (display:none breaks decoding on many browsers).
  ── */
  const stopReaderAndTracks = () => {
    try {
      readerRef.current?.reset();
    } catch {
      /* ignore */
    }
    readerRef.current = null;
  };

  const startCamera = async () => {
    setCameraError('');
    const videoEl = videoRef.current;
    if (!videoEl) {
      setCameraError('Camera preview not ready. Close and re-open this screen, then try again.');
      return;
    }

    stopReaderAndTracks();
    setCameraActive(true);
    await new Promise((r) => setTimeout(r, 50));

    const hints = new Map();
    hints.set(DecodeHintType.TRY_HARDER, true);
    hints.set(DecodeHintType.POSSIBLE_FORMATS, [
      BarcodeFormat.QR_CODE,
      BarcodeFormat.EAN_13,
      BarcodeFormat.EAN_8,
      BarcodeFormat.UPC_A,
      BarcodeFormat.UPC_E,
      BarcodeFormat.CODE_128,
      BarcodeFormat.CODE_39,
      BarcodeFormat.ITF,
    ]);

    const decodeCallback = (result /* , err */) => {
      if (!result) return;
      const code = String(result.getText() || '').replace(/\s+/g, '').trim();
      const now = Date.now();
      if (code !== lastCodeRef.current || now - lastTimeRef.current > 3000) {
        lastCodeRef.current = code;
        lastTimeRef.current = now;
        setLastDecoded(code);
        handleScanRef.current?.(code);
      }
    };

    const tryDecode = async (constraints) => {
      try {
        readerRef.current?.reset();
      } catch {
        /* ignore */
      }
      const reader = new BrowserMultiFormatReader(hints, 500);
      readerRef.current = reader;
      return reader.decodeFromConstraints(
        { audio: false, video: constraints },
        videoEl,
        decodeCallback
      );
    };

    try {
      try {
        await tryDecode({
          facingMode: { ideal: 'environment' },
          width: { ideal: 1280 },
          height: { ideal: 720 },
        });
      } catch (firstErr) {
        // Laptops / desktops often lack "environment" camera — fall back to any camera.
        try {
          await tryDecode({ width: { ideal: 1280 }, height: { ideal: 720 } });
        } catch {
          await tryDecode(true);
        }
      }
    } catch (e) {
      stopReaderAndTracks();
      setCameraActive(false);
      const msg = e?.message || String(e);
      setCameraError(
        /denied|NotAllowed|Permission/i.test(msg)
          ? 'Camera blocked or denied. Allow camera for this site, or use a USB scanner / type the code and press Enter.'
          : `Camera error: ${msg}. Use manual entry or USB scanner.`
      );
    }
  };

  const stopCamera = () => {
    stopReaderAndTracks();
    setCameraActive(false);
  };

  useEffect(() => () => {
    try {
      readerRef.current?.reset();
    } catch {
      /* ignore */
    }
    readerRef.current = null;
  }, []);

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
  const qty = (inv) => {
    if (!inv) return null;
    if (inv.quantity_on_hand != null && inv.quantity_on_hand !== '') return Number(inv.quantity_on_hand);
    if (inv.available_quantity != null && inv.available_quantity !== '') return Number(inv.available_quantity);
    return inv?.quantity ?? inv?.qty ?? null;
  };

  const availableAtLocation = (inv) => {
    if (!inv) return 0;
    const a = inv.available_quantity;
    const q = inv.quantity_on_hand;
    if (a != null && a !== '') return Math.max(0, Number(a));
    if (q != null && q !== '') return Math.max(0, Number(q));
    return Math.max(0, Number(inv.quantity ?? inv.qty ?? 0));
  };
  const price  = (item) => Number(item?.unit_price ?? item?.price ?? 0);
  const branch    = (inv) => inv?.branch?.branch_name ?? inv?.branch_name ?? null;
  const warehouse = (inv) => inv?.warehouse?.warehouse_name ?? inv?.location?.location_name ?? inv?.location_name ?? null;
  const locCode   = (inv) => inv?.location_code ?? inv?.shelf_code ?? inv?.aisle ?? null;
  const stockSt   = (inv) => inv?.status?.status_name ?? inv?.stock_status ?? null;
  const isLow     = (inv) => (stockSt(inv) || '').toLowerCase().includes('low');
  const getLocationId = (inv) => inv?.location_id ?? inv?.location?.id ?? inv?.location?.location_id ?? '';
  const getLocationName = useCallback((locationId) => {
    const hit = locations.find((l) => String(l.id ?? l.location_id) === String(locationId));
    return hit?.location_name || hit?.name || '—';
  }, [locations]);

  useEffect(() => {
    if (!scanResult) return;
    const inv = scanResult.inventory;
    const inferredLocation = inv ? getLocationId(inv) : '';
    setTxForm((prev) => ({
      ...prev,
      quantity: 1,
      condition: 'Good',
      location_id: inferredLocation ? String(inferredLocation) : (prev.location_id || ''),
      to_location_id: scanResult.modeKey === 'transfer' ? prev.to_location_id : '',
      pending_transfer_id: scanResult.modeKey === 'transfer' ? prev.pending_transfer_id : '',
      ship_transfer_first: scanResult.modeKey === 'transfer' ? prev.ship_transfer_first : true,
      pc_id: prev.pc_id || '',
      adjustment_direction: 'deduct',
    }));
  }, [scanResult]);

  const currentModeKey = (scanMode || MODES[modeIndex])?.key;

  useEffect(() => {
    if (currentModeKey !== 'transfer') {
      setTransferSubmode('out');
      return;
    }
    transfersAPI.getAll({ per_page: 100 }).then((r) => {
      setInTransitTransfers(Array.isArray(r?.data) ? r.data : []);
    }).catch(() => setInTransitTransfers([]));
  }, [currentModeKey]);

  const transfersToReceive = useMemo(() => {
    if (!txForm.to_location_id) return [];
    return inTransitTransfers.filter(
      (t) => t.status?.status_name === 'In Transit' && String(t.to_location_id) === String(txForm.to_location_id),
    );
  }, [inTransitTransfers, txForm.to_location_id]);

  /* When FROM LOCATION changes, show stock for that row (or null if no record there) */
  useEffect(() => {
    if (!scanResult?.inventoryRows?.length || !txForm.location_id) return;
    const picked = pickInventoryForLocation(scanResult.inventoryRows, txForm.location_id);
    setScanResult((prev) => {
      if (!prev) return prev;
      const same = String(prev.inventory?.inventory_id || '') === String(picked?.inventory_id || '');
      if (same) return prev;
      return { ...prev, inventory: picked };
    });
  }, [txForm.location_id, scanResult?.inventoryRows]);

  const refreshCurrentResult = useCallback(async () => {
    if (!scanResult?.item) return;
    try {
      const invRes = await inventoryAPI.getAll({
        product_id: scanResult.item.product_id ?? scanResult.item.id,
        per_page: 500,
      });
      const invList = Array.isArray(invRes.data) ? invRes.data : [];
      const latestInventory = pickInventoryForLocation(invList, txForm.location_id)
        || pickInventoryForLocation(invList, '');
      setScanResult((prev) => (prev ? { ...prev, inventory: latestInventory, inventoryRows: invList } : prev));
      setScanHistory((prev) => prev.map((h) => (
        h.barcode === scanResult.barcode && h.scannedAt === scanResult.scannedAt
          ? { ...h, inventory: latestInventory, inventoryRows: invList }
          : h
      )));
    } catch {}
  }, [scanResult, txForm.location_id]);

  const executeModeAction = useCallback(async () => {
    if (!scanResult?.item) return;
    const mode = scanMode || MODES[modeIndex];
    const productId = scanResult.item.product_id ?? scanResult.item.id;
    const qtyNum = Math.max(1, Number(txForm.quantity) || 1);
    const today = new Date().toISOString().slice(0, 10);
    const locationId = txForm.location_id || String(getLocationId(scanResult.inventory) || '');

    if (!productId) {
      toast.error('No product selected from scan result.');
      return;
    }

    const available = availableAtLocation(scanResult.inventory);
    const isTransferIn = mode.key === 'transfer' && transferSubmode === 'in';
    if ((mode.key === 'issue-out' || (mode.key === 'transfer' && !isTransferIn))) {
      if (!scanResult.inventory) {
        toast.error('No inventory record for this product at the selected location. Receive stock first or pick another location.');
        return;
      }
      if (available < qtyNum) {
        toast.error(`Insufficient stock at this location. Available: ${available}, requested: ${qtyNum}.`);
        return;
      }
    }

    setTxSubmitting(true);
    try {
      if (mode.key === 'receive-po') {
        if (!txForm.pc_id) {
          toast.error('Select a Purchase Order for Receive PO.');
          return;
        }
        if (!locationId) {
          toast.error('Select a location for Receive PO.');
          return;
        }
        const selectedPo = purchaseOrders.find((p) => String(p.po_id ?? p.id) === String(txForm.pc_id));
        const blockReason = getReceivePoBlockReason(selectedPo);
        if (blockReason) {
          toast.error(blockReason);
          return;
        }
        const linePid = Number(productId);
        if (!receivePoProductIds.includes(linePid)) {
          toast.error('This product is not on the selected Purchase Order.');
          return;
        }
        const res = await receivingsAPI.create({
          pc_id: txForm.pc_id,
          location_id: locationId,
          receiving_number: `RCV-${Date.now()}`,
          receiving_date: today,
          total_quantity_damaged: 0,
          details: [
            {
              product_id: productId,
              quantity_amount: qtyNum,
              condition: txForm.condition || 'Good',
            },
          ],
        });
        toast.success('Receive PO posted successfully.');
        setTxLogs((prev) => [{
          id: Date.now(),
          mode: mode.label,
          ref: res?.data?.receiving_number || res?.receiving_number || 'Posted',
          barcode: scanResult.barcode,
          qty: qtyNum,
          location: getLocationName(locationId),
          at: new Date().toLocaleTimeString(),
        }, ...prev].slice(0, 8));
      } else if (mode.key === 'issue-out') {
        if (!locationId) {
          toast.error('Select a location for Issue Out.');
          return;
        }
        const res = await issuancesAPI.create({
          location_id: locationId,
          issuance_date: today,
          issuance_type: 'Operations',
          purpose: `Inventory Operation scan (${scanResult.barcode})`,
          details: [
            {
              product_id: productId,
              quantity_issued: qtyNum,
              condition_issued: txForm.condition || 'Good',
            },
          ],
        });
        toast.success('Issue Out posted successfully.');
        setTxLogs((prev) => [{
          id: Date.now(),
          mode: mode.label,
          ref: res?.data?.issuance_number || res?.issuance_number || 'Posted',
          barcode: scanResult.barcode,
          qty: qtyNum,
          location: getLocationName(locationId),
          at: new Date().toLocaleTimeString(),
        }, ...prev].slice(0, 8));
      } else if (mode.key === 'transfer' && isTransferIn) {
        if (!txForm.to_location_id) {
          toast.error('Select the showroom (destination) where stock is arriving.');
          return;
        }
        if (!txForm.pending_transfer_id) {
          toast.error('Select the in-transit transfer to receive against.');
          return;
        }
        const res = await transfersAPI.receive(txForm.pending_transfer_id, {
          barcode: scanResult.barcode,
          quantity: qtyNum,
        });
        toast.success('Showroom receipt recorded — destination stock updated.');
        setTxLogs((prev) => [{
          id: Date.now(),
          mode: `${mode.label} (IN)`,
          ref: res?.data?.transfer_number || res?.data?.transfer_id || 'Received',
          barcode: scanResult.barcode,
          qty: qtyNum,
          location: getLocationName(txForm.to_location_id),
          at: new Date().toLocaleTimeString(),
        }, ...prev].slice(0, 8));
        try {
          const trRes = await transfersAPI.getAll({ per_page: 100 });
          setInTransitTransfers(Array.isArray(trRes?.data) ? trRes.data : []);
        } catch { /* ignore */ }
      } else if (mode.key === 'transfer') {
        if (!locationId) {
          toast.error('Select source location.');
          return;
        }
        if (!txForm.to_location_id) {
          toast.error('Select destination showroom/location.');
          return;
        }
        if (String(locationId) === String(txForm.to_location_id)) {
          toast.error('From and To locations must be different.');
          return;
        }
        const res = await transfersAPI.create({
          from_location_id: locationId,
          to_location_id: txForm.to_location_id,
          transfer_number: `TR-${Date.now()}`,
          transfer_date: today,
          ship_only: !!txForm.ship_transfer_first,
          details: [
            {
              product_id: productId,
              quantity_transferred: qtyNum,
            },
          ],
        });
        toast.success(txForm.ship_transfer_first
          ? 'Transfer shipped — showroom must scan to receive stock at destination.'
          : 'Transfer posted successfully.');
        setTxLogs((prev) => [{
          id: Date.now(),
          mode: mode.label,
          ref: res?.data?.transfer_number || res?.transfer_number || 'Posted',
          barcode: scanResult.barcode,
          qty: qtyNum,
          location: `${getLocationName(locationId)} -> ${getLocationName(txForm.to_location_id)}`,
          at: new Date().toLocaleTimeString(),
        }, ...prev].slice(0, 8));
      } else if (mode.key === 'adjust') {
        if (!locationId) {
          toast.error('Select a location for adjustment.');
          return;
        }
        const addQty = txForm.adjustment_direction === 'add' ? qtyNum : 0;
        const deductQty = txForm.adjustment_direction === 'deduct' ? qtyNum : 0;
        const res = await adjustmentsAPI.create({
          location_id: locationId,
          adjustment_number: `ADJ-${Date.now()}`,
          adjustment_date: today,
          adjustment_type: txForm.adjustment_direction === 'add' ? 'Found Stock' : 'Stock Count',
          adjusted_by: scannedByName,
          details: [
            {
              product_id: productId,
              add_quantity: addQty,
              deduct_quantity: deductQty,
            },
          ],
        });
        toast.success('Adjustment posted successfully.');
        setTxLogs((prev) => [{
          id: Date.now(),
          mode: mode.label,
          ref: res?.data?.adjustment_number || res?.adjustment_number || 'Posted',
          barcode: scanResult.barcode,
          qty: qtyNum,
          location: getLocationName(locationId),
          at: new Date().toLocaleTimeString(),
        }, ...prev].slice(0, 8));
      }
      await refreshCurrentResult();
    } catch (err) {
      toast.error(err.message || 'Failed to execute inventory action.');
    } finally {
      setTxSubmitting(false);
    }
  }, [scanResult, scanMode, modeIndex, txForm, scannedByName, getLocationName, refreshCurrentResult, transferSubmode, purchaseOrders, receivePoProductIds]);

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

  const receivePoSetupGrid = (
    <div className="bs-action-grid">
      <div className="bs-filter-col">
        <label>QUANTITY</label>
        <input
          type="number"
          min="1"
          value={txForm.quantity}
          onChange={(e) => setTxForm((p) => ({ ...p, quantity: e.target.value }))}
        />
      </div>
      <div className="bs-filter-col">
        <label>CONDITION</label>
        <select
          value={txForm.condition}
          onChange={(e) => setTxForm((p) => ({ ...p, condition: e.target.value }))}
        >
          {['Good', 'Fair', 'Damaged', 'Defective'].map((c) => <option key={c} value={c}>{c}</option>)}
        </select>
      </div>
      <div className="bs-filter-col">
        <label>LOCATION</label>
        <select
          value={txForm.location_id}
          onChange={(e) => setTxForm((p) => ({ ...p, location_id: e.target.value }))}
        >
          <option value="">Select</option>
          {locations.map((l) => (
            <option key={l.id ?? l.location_id} value={l.id ?? l.location_id}>
              {l.location_name || l.name}
            </option>
          ))}
        </select>
      </div>
      <div className="bs-filter-col">
        <label>PURCHASE ORDER</label>
        <select
          value={txForm.pc_id}
          onChange={(e) => setTxForm((p) => ({ ...p, pc_id: e.target.value }))}
        >
          <option value="">Select PO</option>
          {purchaseOrders.map((po) => (
            <option key={po.po_id ?? po.id} value={po.po_id ?? po.id}>{po.po_number}</option>
          ))}
        </select>
      </div>
    </div>
  );

  /* ─────────────────────────────────────────────
     RENDER: HOME VIEW
  ───────────────────────────────────────────── */
  if (scanMode === null) {
    return (
      <AdminLayout>
        <div className="bs-page">
          <div className="bs-page-header">
            <h1>Inventory Operation</h1>
            <p>Scan barcode or QR code to view item details and perform inventory lookups</p>
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
            <h1>Inventory Operation</h1>
            <p>Scan barcode or QR code to view item details and perform inventory lookups</p>
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
              <span className="bs-cam-modesub">SCANNING BARCODE / QR</span>
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

        {currentModeKey === 'receive-po' && (
          <div className="bs-action-card" style={{ marginTop: 0, marginBottom: 20 }}>
            <div className="bs-action-head">
              <span className="bs-action-title">Receive PO — setup</span>
              <span className="bs-action-sub">
                Piliin muna ang purchase order at location; pagkatapos mag-scan ng barcode sa ibaba.
                {receivePoLinesLoading && ' (Naglo-load ang line items ng PO…)'}
                {!receivePoLinesLoading && txForm.pc_id && receivePoProductIds.length > 0
                  && ` Tanging ${receivePoProductIds.length} product(s) sa PO na ito ang tatanggapin ng scan.`}
              </span>
            </div>
            {receivePoSetupGrid}
          </div>
        )}

        {/* ── barcode input ── */}
        <div className="bs-input-section">
          <p className="bs-input-title">Barcode / QR Scanner</p>
          <p className="bs-input-sub">Enter or scan a product barcode or QR code</p>
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
              placeholder="Scan barcode or QR code..."
              value={barcodeInput}
              onChange={(e) => setBarcodeInput(e.target.value)}
              autoComplete="off"
              onKeyDown={(e) => {
                if (e.key !== 'Enter') return;
                e.preventDefault();
                // USB scanners send Enter before React state catches the last digits — read DOM value.
                const raw = (e.currentTarget?.value ?? barcodeInput ?? '').trim();
                if (raw) handleScan(raw);
              }}
              disabled={scanning}
              autoFocus
            />
            {scanning && <span className="bs-spin"/>}
          </div>
          {lastDecoded && <p className="bs-lastdecoded">Last decoded: {lastDecoded}</p>}
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

        {currentModeKey === 'transfer' && (
          <div style={{ margin: '12px 0', padding: '14px 16px', background: '#fff7ed', borderRadius: 10, border: '1px solid #fed7aa' }}>
            <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', marginBottom: 10 }}>
              <button
                type="button"
                className={`bs-type-btn${transferSubmode === 'out' ? ' active' : ''}`}
                onClick={() => setTransferSubmode('out')}
              >
                TRANSFER OUT
              </button>
              <button
                type="button"
                className={`bs-type-btn${transferSubmode === 'in' ? ' active' : ''}`}
                onClick={() => setTransferSubmode('in')}
              >
                TRANSFER IN (showroom)
              </button>
            </div>
            <p style={{ margin: 0, fontSize: 13, color: '#9a3412', lineHeight: 1.45 }}>
              {transferSubmode === 'out'
                ? 'Ship from warehouse. Use “Ship first” so stock only appears at the showroom after someone scans to receive here.'
                : 'Truck arrived? Pick your showroom and the in-transit transfer, then scan each barcode to add stock at this location.'}
            </p>
            <button type="button" className="btn-link" style={{ padding: 0, marginTop: 10, fontSize: 13 }} onClick={() => navigate('/admin/transfer-scan')}>
              Open full checklist (print DR) →
            </button>
          </div>
        )}

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
          const mode = scanMode || MODES[modeIndex];
          const isTransferMode = scanResult.modeKey === 'transfer';
          const destinationShowroomName = isTransferMode && txForm.to_location_id
            ? getLocationName(txForm.to_location_id)
            : '';
          const fromLocationName = isTransferMode && txForm.location_id
            ? getLocationName(txForm.location_id)
            : '';
          return (
            <div className="bs-result-wrap">
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
                        <span className="bs-rv">
                          {isTransferMode
                            ? (destinationShowroomName || '—')
                            : (branch(scanResult.inventory) || '—')}
                        </span>
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
                        <span className="bs-rv">
                          {isTransferMode && fromLocationName
                            ? fromLocationName
                            : (warehouse(scanResult.inventory) || '—')}
                        </span>
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
            <div className="bs-action-card">
              <div className="bs-action-head">
                <span className="bs-action-title">Mode Action: {mode.label}</span>
                <span className="bs-action-sub">
                  {mode.key === 'receive-po'
                    ? 'PO at location ay nasa setup sa itaas. I-post ang transaksyon gamit ang na-scan na item.'
                    : 'Post transaction using scanned barcode'}
                </span>
              </div>
              {mode.key !== 'receive-po' ? (
              <div className="bs-action-grid">
                <div className="bs-filter-col">
                  <label>QUANTITY</label>
                  <input
                    type="number"
                    min="1"
                    value={txForm.quantity}
                    onChange={(e) => setTxForm((p) => ({ ...p, quantity: e.target.value }))}
                  />
                </div>
                {(mode.key === 'issue-out') && (
                  <div className="bs-filter-col">
                    <label>CONDITION</label>
                    <select
                      value={txForm.condition}
                      onChange={(e) => setTxForm((p) => ({ ...p, condition: e.target.value }))}
                    >
                      {['Good', 'Fair', 'Damaged', 'Defective'].map((c) => <option key={c} value={c}>{c}</option>)}
                    </select>
                  </div>
                )}
                {(mode.key === 'issue-out' || mode.key === 'adjust') && (
                  <div className="bs-filter-col">
                    <label>LOCATION</label>
                    <select
                      value={txForm.location_id}
                      onChange={(e) => setTxForm((p) => ({ ...p, location_id: e.target.value }))}
                    >
                      <option value="">Select</option>
                      {locations.map((l) => (
                        <option key={l.id ?? l.location_id} value={l.id ?? l.location_id}>
                          {l.location_name || l.name}
                        </option>
                      ))}
                    </select>
                  </div>
                )}
                {mode.key === 'transfer' && transferSubmode === 'out' && (
                  <div className="bs-filter-col">
                    <label>FROM LOCATION (warehouse)</label>
                    <select
                      value={txForm.location_id}
                      onChange={(e) => setTxForm((p) => ({ ...p, location_id: e.target.value }))}
                    >
                      <option value="">Select</option>
                      {locations.map((l) => (
                        <option key={l.id ?? l.location_id} value={l.id ?? l.location_id}>
                          {l.location_name || l.name}
                        </option>
                      ))}
                    </select>
                  </div>
                )}
                {mode.key === 'transfer' && (
                  <div className="bs-filter-col">
                    <label>{transferSubmode === 'in' ? 'SHOWROOM (receiving here)' : 'TO SHOWROOM / LOCATION'}</label>
                    <select
                      value={txForm.to_location_id}
                      onChange={(e) => setTxForm((p) => ({ ...p, to_location_id: e.target.value, pending_transfer_id: '' }))}
                    >
                      <option value="">Select showroom / location</option>
                      {transferDestinationLocations.map((l) => (
                        <option key={l.id ?? l.location_id} value={l.id ?? l.location_id}>
                          {l.location_name || l.name}
                        </option>
                      ))}
                    </select>
                  </div>
                )}
                {mode.key === 'transfer' && transferSubmode === 'in' && (
                  <div className="bs-filter-col" style={{ gridColumn: '1 / -1' }}>
                    <label>IN-TRANSIT TRANSFER #</label>
                    <select
                      value={txForm.pending_transfer_id}
                      onChange={(e) => setTxForm((p) => ({ ...p, pending_transfer_id: e.target.value }))}
                    >
                      <option value="">Select transfer (In Transit)</option>
                      {transfersToReceive.map((t) => (
                        <option key={t.transfer_id} value={t.transfer_id}>
                          {t.transfer_number} — {t.from_location?.location_name || '—'} → {t.to_location?.location_name || '—'}
                        </option>
                      ))}
                    </select>
                    {transfersToReceive.length === 0 && txForm.to_location_id && (
                      <p style={{ margin: '6px 0 0', fontSize: 12, color: '#b45309' }}>No in-transit transfers for this showroom. Create one using Transfer OUT (with Ship first) or Stock Transfer.</p>
                    )}
                  </div>
                )}
                {mode.key === 'transfer' && transferSubmode === 'out' && (
                  <div className="bs-filter-col" style={{ gridColumn: '1 / -1' }}>
                    <label style={{ display: 'flex', alignItems: 'center', gap: 8, cursor: 'pointer', fontWeight: 500 }}>
                      <input
                        type="checkbox"
                        checked={!!txForm.ship_transfer_first}
                        onChange={(e) => setTxForm((p) => ({ ...p, ship_transfer_first: e.target.checked }))}
                      />
                      Ship first — showroom must scan to receive (recommended)
                    </label>
                  </div>
                )}
                {mode.key === 'adjust' && (
                  <div className="bs-filter-col">
                    <label>ADJUSTMENT DIRECTION</label>
                    <select
                      value={txForm.adjustment_direction}
                      onChange={(e) => setTxForm((p) => ({ ...p, adjustment_direction: e.target.value }))}
                    >
                      <option value="deduct">Deduct (wrong scan / overcount)</option>
                      <option value="add">Add (missing stock / undercount)</option>
                    </select>
                  </div>
                )}
                {(mode.key === 'issue-out' || (mode.key === 'transfer' && transferSubmode === 'out')) && (
                  <div className="bs-filter-col" style={{ gridColumn: '1 / -1' }}>
                    <p style={{ margin: 0, fontSize: 13, color: '#475569' }}>
                      Available at selected location:{' '}
                      <strong style={{ color: '#0f172a' }}>
                        {scanResult.inventory ? availableAtLocation(scanResult.inventory) : '—'}
                      </strong>
                      {scanResult.inventory ? ' units (issue/transfer cannot exceed this)' : ' — select a location with stock'}
                    </p>
                  </div>
                )}
                {mode.key === 'transfer' && transferSubmode === 'in' && (
                  <div className="bs-filter-col" style={{ gridColumn: '1 / -1' }}>
                    <p style={{ margin: 0, fontSize: 13, color: '#475569' }}>
                      Receiving matches the scanned barcode to this transfer line. If qty at showroom is still 0, receipt will add stock.
                    </p>
                  </div>
                )}
              </div>
              ) : null}
              <div className="bs-action-footer">
                <button type="button" className="bs-action-btn" onClick={executeModeAction} disabled={txSubmitting}>
                  {txSubmitting
                    ? 'Processing...'
                    : (mode.key === 'transfer' && transferSubmode === 'in' ? 'Record showroom receipt' : `Execute ${mode.label}`)}
                </button>
              </div>
              {txLogs.length > 0 && (
                <div className="bs-tx-log">
                  <span className="bs-tx-title">Transaction Success Log</span>
                  <div className="bs-tx-list">
                    {txLogs.map((log) => (
                      <div key={log.id} className="bs-tx-item">
                        <span className="bs-tx-main">{log.mode} · {log.ref}</span>
                        <span className="bs-tx-sub">{log.at} · Qty {log.qty} · {log.location}</span>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </div>
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
