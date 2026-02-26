<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Traits\ApiResponse;
use App\Models\PurchaseOrder;
use App\Models\PurchaseOrderDetail;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\DB;

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
            $validated = $request->validate([
                'supplier_id'             => 'required|exists:suppliers,id',
                'location_id'             => 'required|exists:locations,id',
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

            DB::beginTransaction();

            $po = PurchaseOrder::create(array_except($validated, ['details']));

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

            return $this->success($po->load(['supplier', 'location', 'details.product']), 'Purchase order created successfully', 201);
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

            $validated = $request->validate([
                'supplier_id'            => 'sometimes|exists:suppliers,id',
                'location_id'            => 'sometimes|exists:locations,id',
                'order_date'             => 'sometimes|date',
                'expected_delivery_date' => 'nullable|date',
                'total_amount'           => 'nullable|numeric|min:0',
                'grand_total'            => 'nullable|numeric|min:0',
                'status_id'              => 'nullable|exists:status_lookup,status_id',
                'approved_by'            => 'nullable|exists:users,user_id',
            ]);

            $po->update($validated);

            return $this->success($po->load(['supplier', 'location', 'details.product']), 'Purchase order updated successfully');
        } catch (ValidationException $e) {
            return $this->validationError($e->errors());
        } catch (\Exception $e) {
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
