<?php

namespace App\Support;

use App\Models\PurchaseOrder;
use App\Models\Receiving;
use App\Models\StatusLookup;

class PurchaseOrderWorkflow
{
    public static function statusIdForPurchaseOrder(string $normalizedLabel): ?int
    {
        $q = StatusLookup::query()->where('status_category', 'purchase_order');
        $needle = strtolower($normalizedLabel);

        if ($needle === 'pending') {
            return (clone $q)->whereRaw('LOWER(status_name) LIKE ?', ['%pending%'])->value('status_id');
        }
        if ($needle === 'authorized' || $needle === 'approved') {
            $id = (clone $q)->whereRaw('LOWER(status_name) LIKE ?', ['%authori%'])->value('status_id');
            if ($id) {
                return $id;
            }

            return (clone $q)->whereRaw('LOWER(status_name) LIKE ?', ['%approved%'])->value('status_id');
        }
        if ($needle === 'rejected') {
            return (clone $q)->whereRaw('LOWER(status_name) LIKE ?', ['%reject%'])->value('status_id');
        }
        if ($needle === 'partial') {
            return (clone $q)->whereRaw('LOWER(status_name) LIKE ?', ['%partial%'])->value('status_id');
        }
        if ($needle === 'fulfilled') {
            return (clone $q)->whereRaw('LOWER(status_name) LIKE ?', ['%fulfill%'])
                ->whereRaw('LOWER(status_name) NOT LIKE ?', ['%partial%'])
                ->value('status_id');
        }

        return null;
    }

    /**
     * After receivings are posted, set PO to Partially Fulfilled or Fulfilled when applicable.
     */
    public static function refreshFulfillmentStatus(int $poId): void
    {
        $po = PurchaseOrder::with('details')->find($poId);
        if (!$po || $po->details->isEmpty()) {
            return;
        }

        $status = $po->relationLoaded('status') ? $po->status : $po->status()->first();
        $name = strtolower($status->status_name ?? '');

        if (str_contains($name, 'pending') || str_contains($name, 'reject')) {
            return;
        }

        if (!str_contains($name, 'authori') && !str_contains($name, 'approved')
            && !str_contains($name, 'partial') && !str_contains($name, 'fulfill')) {
            return;
        }

        $receivedByPoDetail = [];
        $receivedByProduct = [];

        $receivings = Receiving::where('pc_id', $poId)->with('details')->get();
        foreach ($receivings as $receiving) {
            foreach ($receiving->details as $d) {
                $qty = (int) $d->quantity_amount;
                if ($d->po_detail_id) {
                    $receivedByPoDetail[$d->po_detail_id] = ($receivedByPoDetail[$d->po_detail_id] ?? 0) + $qty;
                } else {
                    $pid = (int) $d->product_id;
                    $receivedByProduct[$pid] = ($receivedByProduct[$pid] ?? 0) + $qty;
                }
            }
        }

        $productPool = $receivedByProduct;
        $allComplete = true;
        $anyProgress = false;

        foreach ($po->details as $line) {
            $recv = $receivedByPoDetail[$line->po_detail_id] ?? 0;
            if ($recv === 0) {
                $pid = (int) $line->product_id;
                $avail = $productPool[$pid] ?? 0;
                $recv = min((int) $line->quantity_ordered, $avail);
                $productPool[$pid] = $avail - $recv;
            }
            if ($recv > 0) {
                $anyProgress = true;
            }
            if ($recv < (int) $line->quantity_ordered) {
                $allComplete = false;
            }
        }

        $partialId = self::statusIdForPurchaseOrder('partial');
        $fulfilledId = self::statusIdForPurchaseOrder('fulfilled');

        if ($allComplete && $anyProgress && $fulfilledId) {
            $po->update(['status_id' => $fulfilledId]);

            return;
        }

        if ($anyProgress && !$allComplete && $partialId) {
            $po->update(['status_id' => $partialId]);
        }
    }
}
