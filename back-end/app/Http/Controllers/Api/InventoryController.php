<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Traits\ApiResponse;
use App\Models\Inventory;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class InventoryController extends Controller
{
    use ApiResponse;

    public function index(Request $request)
    {
        $query = Inventory::with(['product', 'location']);

        if ($request->has('search')) {
            $search = $request->search;
            $query->whereHas('product', function ($q) use ($search) {
                $q->where('product_name', 'like', "%{$search}%")
                  ->orWhere('product_code', 'like', "%{$search}%");
            });
        }

        if ($request->has('location_id')) {
            $query->where('location_id', $request->location_id);
        }

        if ($request->has('category')) {
            $query->whereHas('product', function ($q) use ($request) {
                $q->whereHas('category', fn($c) => $c->where('category_name', $request->category));
            });
        }

        if ($request->has('low_stock') && $request->low_stock) {
            $query->whereColumn('quantity_on_hand', '<=', DB::raw('(SELECT recommended_stocks FROM products WHERE products.product_id = inventory.product_id)'));
        }

        $perPage = $request->get('per_page', 15);
        return $this->paginated($query->paginate($perPage), 'Inventory retrieved successfully');
    }

    public function show($id)
    {
        $inventory = Inventory::with(['product', 'location'])->find($id);

        if (!$inventory) {
            return $this->notFound('Inventory not found');
        }

        return $this->success($inventory, 'Inventory retrieved successfully');
    }

    public function byLocation($locationId)
    {
        $inventory = Inventory::where('location_id', $locationId)
            ->with(['product'])
            ->get();

        return $this->success($inventory, 'Location inventory retrieved successfully');
    }

    public function byItem($product)
    {
        $productId = is_object($product) ? $product->product_id : $product;
        $inventory = Inventory::where('product_id', $productId)
            ->with(['location'])
            ->get();

        return $this->success($inventory, 'Product inventory retrieved successfully');
    }

    public function scanBarcode(Request $request)
    {
        try {
            $validated = $request->validate([
                'barcode'     => 'required|string',
                'location_id' => 'nullable|exists:locations,location_id',
            ]);

            $product = Product::where('product_code', $validated['barcode'])
                ->orWhere('barcode', $validated['barcode'])
                ->first();

            if (!$product) {
                return $this->notFound('Product not found with this barcode');
            }

            $inventoryQuery = Inventory::where('product_id', $product->product_id)
                ->with(['location']);

            if (isset($validated['location_id'])) {
                $inventoryQuery->where('location_id', $validated['location_id']);
            }

            return $this->success([
                'product'   => $product,
                'inventory' => $inventoryQuery->get(),
            ], 'Barcode scanned successfully');

        } catch (ValidationException $e) {
            return $this->validationError($e->errors());
        } catch (\Exception $e) {
            return $this->error('Scan failed: ' . $e->getMessage(), 500);
        }
    }
}
