<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\BarcodeScan;
use App\Models\Product;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class BarcodeScanController extends Controller
{
    use ApiResponse;

    public function index(Request $request)
    {
        try {
            $query = BarcodeScan::with(['user', 'product']);

            if ($request->filled('user_id')) {
                $query->where('user_id', $request->user_id);
            }
            if ($request->filled('product_id')) {
                $query->where('product_id', $request->product_id);
            }
            if ($request->filled('scan_mode')) {
                $query->where('scan_mode', $request->scan_mode);
            }

            $perPage = (int) $request->get('per_page', 50);
            $perPage = $perPage > 0 ? min($perPage, 200) : 50;

            return $this->paginated(
                $query->orderByDesc('scanned_at')->orderByDesc('id')->paginate($perPage),
                'Barcode scans retrieved successfully'
            );
        } catch (\Exception $e) {
            return $this->error('Failed to retrieve barcode scans: ' . $e->getMessage(), 500);
        }
    }

    public function store(Request $request)
    {
        try {
            $validated = $request->validate([
                'barcode'     => 'required|string|max:191',
                'product_id'  => 'required|integer|exists:products,product_id',
                'scan_mode'   => 'required|string|max:64',
                'scanned_at'  => 'nullable|date',
            ]);

            $product = Product::query()->where('product_id', $validated['product_id'])->first();
            $bc = trim($validated['barcode']);
            $codeMatch = $product && (
                (string) ($product->product_code ?? '') !== ''
                && strcasecmp((string) $product->product_code, $bc) === 0
            );
            $barcodeMatch = $product && (
                (string) ($product->barcode ?? '') !== ''
                && strcasecmp((string) $product->barcode, $bc) === 0
            );
            if (! $product || (! $codeMatch && ! $barcodeMatch)) {
                throw ValidationException::withMessages([
                    'barcode' => ['Barcode does not match the selected product (check model code or product barcode).'],
                ]);
            }

            $scan = BarcodeScan::create([
                'user_id'     => $request->user()->user_id,
                'barcode'     => $validated['barcode'],
                'product_id'  => $validated['product_id'],
                'scan_mode'   => $validated['scan_mode'],
                'scanned_at'  => $validated['scanned_at'] ?? now(),
            ]);

            return $this->success(
                $scan->load(['user', 'product']),
                'Barcode scan recorded successfully',
                201
            );
        } catch (ValidationException $e) {
            return $this->validationError($e->errors());
        } catch (\Exception $e) {
            return $this->error('Failed to record barcode scan: ' . $e->getMessage(), 500);
        }
    }
}
