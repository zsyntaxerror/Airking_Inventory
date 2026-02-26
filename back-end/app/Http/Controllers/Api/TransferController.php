<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Traits\ApiResponse;
use App\Models\Transfer;
use App\Models\TransferDetail;
use App\Models\TblTransferTracking;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\DB;

class TransferController extends Controller
{
    use ApiResponse;

    public function index(Request $request)
    {
        try {
            $query = Transfer::with(['fromLocation', 'toLocation', 'requestedBy', 'approvedBy', 'receivedBy', 'status']);

            if ($request->has('from_location_id')) {
                $query->where('from_location_id', $request->from_location_id);
            }
            if ($request->has('to_location_id')) {
                $query->where('to_location_id', $request->to_location_id);
            }
            if ($request->has('status_id')) {
                $query->where('status_id', $request->status_id);
            }
            if ($request->has('search')) {
                $query->where('transfer_number', 'like', '%' . $request->search . '%');
            }

            $perPage = $request->get('per_page', 20);
            return $this->paginated($query->orderBy('created_at', 'desc')->paginate($perPage), 'Transfers retrieved successfully');
        } catch (\Exception $e) {
            return $this->error('Failed to retrieve transfers: ' . $e->getMessage(), 500);
        }
    }

    public function store(Request $request)
    {
        try {
            $validated = $request->validate([
                'from_location_id'            => 'required|exists:locations,id',
                'to_location_id'              => 'required|different:from_location_id|exists:locations,id',
                'transfer_number'             => 'required|string|max:50|unique:transfers,transfer_number',
                'transfer_date'               => 'required|date',
                'requested_by'                => 'nullable|exists:users,user_id',
                'approved_by'                 => 'nullable|exists:users,user_id',
                'received_by'                 => 'nullable|exists:users,user_id',
                'status_id'                   => 'nullable|exists:status_lookup,status_id',
                'details'                     => 'required|array|min:1',
                'details.*.product_id'        => 'required|exists:products,product_id',
                'details.*.quantity_transferred' => 'required|integer|min:1',
            ]);

            DB::beginTransaction();

            $transfer = Transfer::create(array_except($validated, ['details']));

            $total = 0;
            foreach ($validated['details'] as $detail) {
                $transfer->details()->create($detail);
                $total += $detail['quantity_transferred'];
            }

            $transfer->update(['total_quantity_transferred' => $total]);

            DB::commit();

            return $this->success($transfer->load(['fromLocation', 'toLocation', 'details.product']), 'Transfer created successfully', 201);
        } catch (ValidationException $e) {
            return $this->validationError($e->errors());
        } catch (\Exception $e) {
            DB::rollBack();
            return $this->error('Failed to create transfer: ' . $e->getMessage(), 500);
        }
    }

    public function show($id)
    {
        try {
            $transfer = Transfer::with(['fromLocation', 'toLocation', 'requestedBy', 'approvedBy', 'receivedBy', 'status', 'details.product', 'transferTracking'])->findOrFail($id);
            return $this->success($transfer, 'Transfer retrieved successfully');
        } catch (\Exception $e) {
            return $this->error('Transfer not found', 404);
        }
    }

    public function update(Request $request, $id)
    {
        try {
            $transfer = Transfer::findOrFail($id);

            $validated = $request->validate([
                'transfer_date'   => 'sometimes|date',
                'requested_by'    => 'nullable|exists:users,user_id',
                'approved_by'     => 'nullable|exists:users,user_id',
                'received_by'     => 'nullable|exists:users,user_id',
                'status_id'       => 'nullable|exists:status_lookup,status_id',
            ]);

            $transfer->update($validated);

            return $this->success($transfer->load(['fromLocation', 'toLocation', 'details.product']), 'Transfer updated successfully');
        } catch (ValidationException $e) {
            return $this->validationError($e->errors());
        } catch (\Exception $e) {
            return $this->error('Failed to update transfer: ' . $e->getMessage(), 500);
        }
    }

    public function destroy($id)
    {
        try {
            $transfer = Transfer::findOrFail($id);
            $transfer->delete();
            return $this->success(null, 'Transfer deleted successfully');
        } catch (\Exception $e) {
            return $this->error('Failed to delete transfer: ' . $e->getMessage(), 500);
        }
    }

    public function addTracking(Request $request, $id)
    {
        try {
            $transfer = Transfer::findOrFail($id);

            $validated = $request->validate([
                'location_id' => 'nullable|exists:locations,id',
                'status_note' => 'required|string|max:255',
                'recorded_at' => 'nullable|date',
                'recorded_by' => 'nullable|exists:users,user_id',
            ]);

            $validated['transfer_id'] = $transfer->transfer_id;
            if (!isset($validated['recorded_at'])) {
                $validated['recorded_at'] = now();
            }

            $tracking = TblTransferTracking::create($validated);

            return $this->success($tracking, 'Transfer tracking added successfully', 201);
        } catch (ValidationException $e) {
            return $this->validationError($e->errors());
        } catch (\Exception $e) {
            return $this->error('Failed to add tracking: ' . $e->getMessage(), 500);
        }
    }
}
