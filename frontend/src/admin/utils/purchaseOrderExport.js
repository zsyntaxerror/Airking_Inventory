/**
 * Client-side export helpers for purchase orders (CSV ≈ Excel, HTML document, print / Save as PDF).
 */

const escapeHtml = (s) =>
  String(s ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');

const poLineRows = (po) => {
  const details = Array.isArray(po?.details) ? po.details : [];
  return details.map((d) => {
    const p = d.product || {};
    const name = p.product_name || p.name || `Product #${d.product_id ?? '—'}`;
    const qty = d.quantity_ordered ?? '—';
    const unit = d.unit_price ?? 0;
    const sub = d.subtotal ?? Number(qty) * Number(unit);
    return { name, productId: d.product_id, qty, unit, sub };
  });
};

export const buildPoCsv = (po) => {
  const num = po?.pc_number ?? po?.po_number ?? '';
  const supplier = po?.supplier?.supplier_name ?? po?.supplier?.name ?? '';
  const status = po?.status?.status_name ?? '';
  const date = po?.order_date ?? '';
  const lines = poLineRows(po);
  const rows = [
    ['Purchase Order', num],
    ['Supplier', supplier],
    ['Status', status],
    ['Order date', date],
    [],
    ['Product', 'Product ID', 'Qty ordered', 'Unit price', 'Subtotal'],
    ...lines.map((r) => [r.name, r.productId, r.qty, r.unit, r.sub]),
    [],
    ['Grand total', '', '', '', po?.grand_total ?? po?.total_amount ?? ''],
  ];
  return rows.map((cells) => cells.map((c) => `"${String(c ?? '').replace(/"/g, '""')}"`).join(',')).join('\r\n');
};

export const downloadPoCsv = (po, filenameBase = 'purchase-order') => {
  const csv = buildPoCsv(po);
  const blob = new Blob(['\ufeff', csv], { type: 'text/csv;charset=utf-8' });
  const a = document.createElement('a');
  a.href = URL.createObjectURL(blob);
  a.download = `${filenameBase}-${po?.pc_number ?? po?.po_number ?? 'export'}.csv`;
  a.click();
  URL.revokeObjectURL(a.href);
};

export const downloadPoHtmlDocument = (po, filenameBase = 'purchase-order') => {
  const num = escapeHtml(po?.pc_number ?? po?.po_number ?? '');
  const supplier = escapeHtml(po?.supplier?.supplier_name ?? po?.supplier?.name ?? '—');
  const loc = escapeHtml(po?.location?.location_name ?? po?.location?.name ?? '—');
  const status = escapeHtml(po?.status?.status_name ?? '—');
  const date = escapeHtml(po?.order_date ?? '—');
  const lines = poLineRows(po);
  const rowsHtml = lines
    .map(
      (r) =>
        `<tr><td>${escapeHtml(r.name)}</td><td>${escapeHtml(r.productId)}</td><td>${escapeHtml(r.qty)}</td><td>${escapeHtml(r.unit)}</td><td>${escapeHtml(r.sub)}</td></tr>`,
    )
    .join('');
  const total = escapeHtml(po?.grand_total ?? po?.total_amount ?? '');
  const html = `<!DOCTYPE html><html><head><meta charset="utf-8"><title>PO ${num}</title></head><body>
<h1>Purchase Order</h1>
<p><strong>Reference:</strong> ${num}<br><strong>Supplier:</strong> ${supplier}<br><strong>Location:</strong> ${loc}<br><strong>Status:</strong> ${status}<br><strong>Order date:</strong> ${date}</p>
<table border="1" cellpadding="6" cellspacing="0"><thead><tr><th>Product</th><th>Product ID</th><th>Qty</th><th>Unit</th><th>Subtotal</th></tr></thead><tbody>${rowsHtml}</tbody></table>
<p><strong>Total:</strong> ${total}</p>
</body></html>`;
  const blob = new Blob([html], { type: 'application/msword;charset=utf-8' });
  const a = document.createElement('a');
  a.href = URL.createObjectURL(blob);
  a.download = `${filenameBase}-${po?.pc_number ?? po?.po_number ?? 'export'}.doc`;
  a.click();
  URL.revokeObjectURL(a.href);
};

export const openPoPrintPdf = (po) => {
  const num = escapeHtml(po?.pc_number ?? po?.po_number ?? '');
  const supplier = escapeHtml(po?.supplier?.supplier_name ?? po?.supplier?.name ?? '—');
  const loc = escapeHtml(po?.location?.location_name ?? po?.location?.name ?? '—');
  const status = escapeHtml(po?.status?.status_name ?? '—');
  const date = escapeHtml(po?.order_date ?? '—');
  const lines = poLineRows(po);
  const rowsHtml = lines
    .map(
      (r) =>
        `<tr><td>${escapeHtml(r.name)}</td><td>${escapeHtml(r.productId)}</td><td style="text-align:right">${escapeHtml(r.qty)}</td><td style="text-align:right">${escapeHtml(r.unit)}</td><td style="text-align:right">${escapeHtml(r.sub)}</td></tr>`,
    )
    .join('');
  const total = escapeHtml(po?.grand_total ?? po?.total_amount ?? '');
  const w = window.open('', '_blank');
  if (!w) return;
  w.document.write(`<!DOCTYPE html><html><head><meta charset="utf-8"><title>PO ${num}</title>
<style>
body{font-family:system-ui,sans-serif;padding:24px;color:#111}
h1{font-size:20px}
.meta{margin:16px 0;line-height:1.6}
table{width:100%;border-collapse:collapse;font-size:13px}
th,td{border:1px solid #ccc;padding:8px;text-align:left}
th{background:#f3f4f6}
.total{margin-top:16px;font-weight:600}
@media print{body{padding:12px}}
</style></head><body>
<h1>Purchase Order</h1>
<div class="meta"><strong>Reference:</strong> ${num}<br>
<strong>Supplier:</strong> ${supplier}<br>
<strong>Ship to / location:</strong> ${loc}<br>
<strong>Status:</strong> ${status}<br>
<strong>Order date:</strong> ${date}</div>
<table><thead><tr><th>Product</th><th>ID</th><th style="text-align:right">Qty</th><th style="text-align:right">Unit</th><th style="text-align:right">Subtotal</th></tr></thead><tbody>${rowsHtml}</tbody></table>
<p class="total">Total: ${total}</p>
<p style="font-size:11px;color:#666;margin-top:32px">Use your browser Print dialog and choose &quot;Save as PDF&quot; to export a PDF.</p>
<script>window.onload=function(){window.focus();}</script>
</body></html>`);
  w.document.close();
  w.onload = () => {
    w.print();
  };
};
