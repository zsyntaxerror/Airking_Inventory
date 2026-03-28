<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Traits\ApiResponse;
use App\Models\PurchaseOrder;
use App\Models\PurchaseOrderDetail;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Arr;
use Illuminate\Validation\Rule;

class PurchaseOrderController extends Controller
{
    use ApiResponse;

    public function index(Request $request)
    {
        try {
            $query = PurchaseOrder::with(['supplier', 'location', 'createdBy', 'approvedBy', 'status']);

            if ($request->has('supplier_id')) {
                $query->where('supplier_id', $request->supplier_id);
            }
            if ($request->has('location_id')) {
                $query->where('location_id', $request->location_id);
            }
            if ($request->has('status_id')) {
                $query->where('status_id', $request->status_id);
            }
            if ($request->has('search')) {
                $query->where('pc_number', 'like', '%' . $request->search . '%');
            }

            $perPage = $request->get('per_page', 20);
            return $this->paginated($query->orderBy('created_at', 'desc')->paginate($perPage), 'Purchase orders retrieved successfully');
        } catch (\Exception $e) {
            return $this->error('Failed to retrieve purchase orders: ' . $e->getMessage(), 500);
        }
    }

    public function store(Request $request)
    {
        try {
            // Normalize Draft PO Creator payload to ERD-aligned PO fields.
            // Frontend currently sends:
            // - reference_no, po_date, branch_id, items[{ quantity, unit_cost, total }]
            // While this controller expects:
            // - pc_number, order_date, location_id, details[{ quantity_ordered, unit_price, subtotal }]
            $payload = $request->all();
            if (empty($payload['pc_number']) && !empty($payload['po_number'])) {
                $payload['pc_number'] = $payload['po_number'];
            }
            if (empty($payload['pc_number']) && !empty($payload['reference_no'])) {
                $payload['pc_number'] = $payload['reference_no'];
            }
            if (empty($payload['order_date']) && !empty($payload['po_date'])) {
                $payload['order_date'] = $payload['po_date'];
            }
            if (empty($payload['location_id']) && !empty($payload['branch_id'])) {
                // Draft PO uses branch/location selector; map directly.
                $payload['location_id'] = $payload['branch_id'];
            }
            if (empty($payload['details']) && !empty($payload['items']) && is_array($payload['items'])) {
                $payload['details'] = array_map(function ($item) {
                    return [
                        'product_id' => $item['product_id'] ?? null,
                        'quantity_ordered' => $item['quantity'] ?? $item['qty'] ?? null,
                        'unit_price' => $item['unit_price'] ?? $item['unit_cost'] ?? null,
                        'subtotal' => $item['subtotal'] ?? $item['total'] ?? null,
                    ];
                }, $payload['items']);
            }

            $request->replace($payload);

            $validated = $request->validate([
                'supplier_id'             => 'required|exists:suppliers,supplier_id',
                'location_id'             => 'required|exists:locations,location_id',
                'pc_number'               => 'required|string|max:50|unique:purchase_orders,pc_number',
                'order_date'              => 'required|date',
                'expected_delivery_date'  => 'nullable|date',
                'total_amount'            => 'nullable|numeric|min:0',
                'grand_total'             => 'nullable|numeric|min:0',
                'status_id'               => 'nullable|exists:status_lookup,status_id',
                'created_by'              => 'nullable|exists:users,user_id',
                'approved_by'             => 'nullable|exists:users,user_id',
                'details'                 => 'required|array|min:1',
                'details.*.product_id'    => 'required|exists:products,product_id',
                'details.*.quantity_ordered' => 'required|integer|min:1',
                'details.*.unit_price'    => 'required|numeric|min:0',
                'details.*.subtotal'      => 'nullable|numeric|min:0',
            ]);

            // Always attribute creation to the authenticated user when present
            if ($request->user()) {
                $validated['created_by'] = $request->user()->user_id;
            }

            DB::beginTransaction();

            $po = PurchaseOrder::create(Arr::except($validated, ['details']));

            $totalAmount = 0;
            foreach ($validated['details'] as $detail) {
                if (!isset($detail['subtotal'])) {
                    $detail['subtotal'] = $detail['quantity_ordered'] * $detail['unit_price'];
                }
                $po->details()->create($detail);
                $totalAmount += $detail['subtotal'];
            }

            // Auto-set total amounts if not explicitly provided
            if (!isset($validated['total_amount'])) {
                $po->update(['total_amount' => $totalAmount, 'grand_total' => $totalAmount]);
            }

            DB::commit();

            return $this->success($po->load(['supplier', 'location', 'createdBy', 'approvedBy', 'status', 'details.product']), 'Purchase order created successfully', 201);
        } catch (ValidationException $e) {
            return $this->validationError($e->errors());
        } catch (\Exception $e) {
            DB::rollBack();
            return $this->error('Failed to create purchase order: ' . $e->getMessage(), 500);
        }
    }

    public function show($id)
    {
        try {
            $po = PurchaseOrder::with(['supplier', 'location', 'createdBy', 'approvedBy', 'status', 'details.product', 'receivings', 'purchaseReturns'])->findOrFail($id);
            return $this->success($po, 'Purchase order retrieved successfully');
        } catch (\Exception $e) {
            return $this->error('Purchase order not found', 404);
        }
    }

    public function update(Request $request, $id)
    {
        try {
            $po = PurchaseOrder::findOrFail($id);

            $payload = $request->all();
            if (empty($payload['pc_number']) && !empty($payload['po_number'])) {
                $payload['pc_number'] = $payload['po_number'];
            }
            $request->replace($payload);

            $validated = $request->validate([
                'supplier_id'            => 'sometimes|exists:suppliers,supplier_id',
                'location_id'            => 'sometimes|exists:locations,location_id',
                'pc_number'              => ['sometimes', 'string', 'max:50', Rule::unique('purchase_orders', 'pc_number')->ignore($po->po_id, 'po_id')],
                'order_date'             => 'sometimes|date',
                'expected_delivery_date' => 'nullable|date',
                'total_amount'           => 'nullable|numeric|min:0',
                'grand_total'            => 'nullable|numeric|min:0',
                'status_id'              => 'nullable|exists:status_lookup,status_id',
                'approved_by'            => 'nullable|exists:users,user_id',
                'details'                => 'sometimes|array|min:1',
                'details.*.product_id'   => 'required_with:details|exists:products,product_id',
                'details.*.quantity_ordered' => 'required_with:details|integer|min:1',
                'details.*.unit_price'   => 'required_with:details|numeric|min:0',
                'details.*.subtotal'     => 'nullable|numeric|min:0',
            ]);

            DB::beginTransaction();

            $header = Arr::except($validated, ['details']);
            if (!empty($header)) {
                $po->update($header);
            }

            if (isset($validated['details'])) {
                $po->details()->delete();
                $totalAmount = 0;
                foreach ($validated['details'] as $detail) {
                    if (!isset($detail['subtotal'])) {
                        $detail['subtotal'] = $detail['quantity_ordered'] * $detail['unit_price'];
                    }
                    $po->details()->create($detail);
                    $totalAmount += $detail['subtotal'];
                }
                $po->update([
                    'total_amount' => $totalAmount,
                    'grand_total'  => $validated['grand_total'] ?? $totalAmount,
                ]);
            }

            DB::commit();

            return $this->success(
                $po->fresh()->load(['supplier', 'location', 'createdBy', 'approvedBy', 'status', 'details.product']),
                'Purchase order updated successfully'
            );
        } catch (ValidationException $e) {
            DB::rollBack();
            return $this->validationError($e->errors());
        } catch (\Exception $e) {
            DB::rollBack();
            return $this->error('Failed to update purchase order: ' . $e->getMessage(), 500);
        }
    }

    public function destroy($id)
    {
        try {
            $po = PurchaseOrder::findOrFail($id);
            $po->delete();
            return $this->success(null, 'Purchase order deleted successfully');
        } catch (\Exception $e) {
            return $this->error('Failed to delete purchase order: ' . $e->getMessage(), 500);
        }
    }
}
