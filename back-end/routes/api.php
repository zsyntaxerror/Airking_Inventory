<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\InventoryController;
use App\Http\Controllers\Api\BranchController;
use App\Http\Controllers\Api\WarehouseController;
use App\Http\Controllers\Api\BatchController;
use App\Http\Controllers\Api\CategoryLookupController;
use App\Http\Controllers\Api\BrandLookupController;
use App\Http\Controllers\Api\CustomerController;
use App\Http\Controllers\Api\ProductController;
use App\Http\Controllers\Api\SupplierController;
use App\Http\Controllers\Api\SerialController;
// ERD-aligned controllers
use App\Http\Controllers\Api\LocationController;
use App\Http\Controllers\Api\ModelLookupController;
use App\Http\Controllers\Api\SubcategoryLookupController;
use App\Http\Controllers\Api\PurchaseOrderController;
use App\Http\Controllers\Api\ReceivingController;
use App\Http\Controllers\Api\PurchaseReturnController;
use App\Http\Controllers\Api\SaleController;
use App\Http\Controllers\Api\DeliveryReceiptController;
use App\Http\Controllers\Api\IssuanceController;
use App\Http\Controllers\Api\TransferController;
use App\Http\Controllers\Api\AdjustmentController;
use App\Http\Controllers\Api\ProfitLossController;
use App\Http\Controllers\Api\ActivityLogController;
use App\Http\Controllers\Api\StatusLookupController;
use App\Http\Controllers\Api\UnitLookupController;
use App\Http\Controllers\Api\RoleController;

/*
|--------------------------------------------------------------------------
| API HEALTH (no auth)
|--------------------------------------------------------------------------
*/
Route::get('/', function () {
    return response()->json(['message' => 'API is running', 'version' => '1.0']);
});

/*
|--------------------------------------------------------------------------
| AUTH (DO NOT TOUCH)
|--------------------------------------------------------------------------
*/
Route::post('/login', [AuthController::class, 'login']);
Route::post('/register', [AuthController::class, 'register']);
Route::post('/forgot-password', [AuthController::class, 'forgotPassword']);

Route::middleware('auth:sanctum')->group(function () {

    /*
    |--------------------------------------------------------------------------
    | AUTH (DO NOT TOUCH)
    |--------------------------------------------------------------------------
    */
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', [AuthController::class, 'user']);
    Route::post('/refresh-token', [AuthController::class, 'refresh']);

    /*
    |--------------------------------------------------------------------------
    | DASHBOARD (DO NOT TOUCH)
    |--------------------------------------------------------------------------
    */
    Route::get('/dashboard', [DashboardController::class, 'index']);
    Route::get('/batch', [BatchController::class, 'index']);
    Route::get('/dashboard/stats', [DashboardController::class, 'stats']);
    Route::get('/dashboard/low-stock', [DashboardController::class, 'lowStock']);
    Route::get('/dashboard/recent-sales', [DashboardController::class, 'recentSales']);
    Route::get('/dashboard/recent-movements', [DashboardController::class, 'recentMovements']);

    /*
    |--------------------------------------------------------------------------
    | USER MANAGEMENT (ADMIN ONLY)
    |--------------------------------------------------------------------------
    */
    Route::middleware('role:admin')->group(function () {
        Route::put('/users/{user}/change-password', [UserController::class, 'changePassword']);
        Route::put('/users/{user}/status', [UserController::class, 'updateStatus']);
        Route::apiResource('users', UserController::class);
    });

    /*
    |--------------------------------------------------------------------------
    | ERD: ROLES (roles)
    |--------------------------------------------------------------------------
    */
    Route::get('/roles', [RoleController::class, 'index']);
    Route::get('/roles/{id}', [RoleController::class, 'show']);
    Route::middleware('role:admin')->group(function () {
        Route::post('/roles', [RoleController::class, 'store']);
        Route::put('/roles/{id}', [RoleController::class, 'update']);
        Route::delete('/roles/{id}', [RoleController::class, 'destroy']);
    });

    /*
    |--------------------------------------------------------------------------
    | ERD: STATUS (status_lookup)
    |--------------------------------------------------------------------------
    */
    Route::get('/status-lookup', [StatusLookupController::class, 'index']);
    Route::get('/status-lookup/{id}', [StatusLookupController::class, 'show']);
    Route::middleware('role:admin')->group(function () {
        Route::post('/status-lookup', [StatusLookupController::class, 'store']);
        Route::put('/status-lookup/{id}', [StatusLookupController::class, 'update']);
        Route::delete('/status-lookup/{id}', [StatusLookupController::class, 'destroy']);
    });

    /*
    |--------------------------------------------------------------------------
    | ERD: CATEGORY (category_lookup)
    |--------------------------------------------------------------------------
    */
    Route::get('/categories/performance', [CategoryLookupController::class, 'performance']);
    Route::get('/categories/archived', [CategoryLookupController::class, 'archived']);
    Route::post('/categories/{category}/restore', [CategoryLookupController::class, 'restore']);
    Route::apiResource('categories', CategoryLookupController::class)->parameters(['categories' => 'category']);

    /*
    |--------------------------------------------------------------------------
    | ERD: SUBCATEGORY (subcategory_lookup)
    |--------------------------------------------------------------------------
    */
    Route::get('/subcategories', [SubcategoryLookupController::class, 'index']);
    Route::get('/subcategories/{id}', [SubcategoryLookupController::class, 'show']);
    Route::middleware('role:admin,branch_manager')->group(function () {
        Route::post('/subcategories', [SubcategoryLookupController::class, 'store']);
        Route::put('/subcategories/{id}', [SubcategoryLookupController::class, 'update']);
    });
    Route::middleware('role:admin')->group(function () {
        Route::delete('/subcategories/{id}', [SubcategoryLookupController::class, 'destroy']);
    });

    /*
    |--------------------------------------------------------------------------
    | ERD: BRAND (brand_lookup)
    |--------------------------------------------------------------------------
    */
    Route::get('/brands/archived', [BrandLookupController::class, 'archived']);
    Route::post('/brands/{brand}/restore', [BrandLookupController::class, 'restore']);
    Route::apiResource('brands', BrandLookupController::class)->parameters(['brands' => 'brand']);

    /*
    |--------------------------------------------------------------------------
    | ERD: MODEL LOOKUP (model_lookup)
    |--------------------------------------------------------------------------
    */
    Route::get('/models', [ModelLookupController::class, 'index']);
    Route::get('/models/{id}', [ModelLookupController::class, 'show']);
    Route::middleware('role:admin,branch_manager')->group(function () {
        Route::post('/models', [ModelLookupController::class, 'store']);
        Route::put('/models/{id}', [ModelLookupController::class, 'update']);
    });
    Route::middleware('role:admin')->group(function () {
        Route::delete('/models/{id}', [ModelLookupController::class, 'destroy']);
    });

    /*
    |--------------------------------------------------------------------------
    | ERD: UNIT LOOKUP (unit_lookup)
    |--------------------------------------------------------------------------
    */
    Route::get('/units', [UnitLookupController::class, 'index']);
    Route::get('/units/{id}', [UnitLookupController::class, 'show']);
    Route::middleware('role:admin')->group(function () {
        Route::post('/units', [UnitLookupController::class, 'store']);
        Route::put('/units/{id}', [UnitLookupController::class, 'update']);
        Route::delete('/units/{id}', [UnitLookupController::class, 'destroy']);
    });

    /*
    |--------------------------------------------------------------------------
    | BRANCHES (for branch-linked locations)
    |--------------------------------------------------------------------------
    */
    Route::get('/branches', [BranchController::class, 'index']);
    Route::get('/branches/{branch}', [BranchController::class, 'show']);

    /*
    |--------------------------------------------------------------------------
    | ERD: LOCATION (location)
    |--------------------------------------------------------------------------
    */
    Route::get('/locations', [LocationController::class, 'index']);
    Route::get('/locations/{location}', [LocationController::class, 'show']);
    Route::middleware('role:admin,branch_manager')->group(function () {
        Route::post('/locations', [LocationController::class, 'store']);
        Route::put('/locations/{location}', [LocationController::class, 'update']);
    });
    Route::middleware('role:admin')->group(function () {
        Route::delete('/locations/{location}', [LocationController::class, 'destroy']);
    });

    /*
    |--------------------------------------------------------------------------
    | ERD: PRODUCT (Product table)
    |--------------------------------------------------------------------------
    */
    Route::get('/products', [ProductController::class, 'index']);
    Route::get('/products/{product}', [ProductController::class, 'show']);
    Route::middleware('role:admin,branch_manager')->group(function () {
        Route::post('/products', [ProductController::class, 'store']);
        Route::put('/products/{product}', [ProductController::class, 'update']);
    });
    Route::middleware('role:admin')->group(function () {
        Route::delete('/products/{product}', [ProductController::class, 'destroy']);
    });

    // Legacy alias: /items → products
    Route::get('/items', [ProductController::class, 'index']);
    Route::get('/items/{product}', [ProductController::class, 'show']);
    Route::middleware('role:admin,branch_manager')->group(function () {
        Route::post('/items', [ProductController::class, 'store']);
        Route::put('/items/{product}', [ProductController::class, 'update']);
    });
    Route::middleware('role:admin')->group(function () {
        Route::delete('/items/{product}', [ProductController::class, 'destroy']);
    });

    /*
    |--------------------------------------------------------------------------
    | ERD: ITEM_SERIAL (item_serial)
    |--------------------------------------------------------------------------
    */
    Route::get('/serials', [SerialController::class, 'index']);
    Route::get('/serials/{serial}', [SerialController::class, 'show']);
    Route::post('/serials/scan', [SerialController::class, 'scan']);
    Route::middleware('role:admin,branch_manager,warehouse_personnel')->group(function () {
        Route::post('/serials', [SerialController::class, 'store']);
        Route::put('/serials/{serial}', [SerialController::class, 'update']);
    });
    Route::middleware('role:admin')->group(function () {
        Route::delete('/serials/{serial}', [SerialController::class, 'destroy']);
    });

    /*
    |--------------------------------------------------------------------------
    | ERD: SUPPLIER (supplier)
    |--------------------------------------------------------------------------
    */
    Route::get('/suppliers', [SupplierController::class, 'index']);
    Route::get('/suppliers/{id}', [SupplierController::class, 'show']);
    Route::get('/suppliers/{id}/products', [SupplierController::class, 'products']);
    Route::middleware('role:admin,branch_manager')->group(function () {
        Route::post('/suppliers', [SupplierController::class, 'store']);
        Route::put('/suppliers/{id}', [SupplierController::class, 'update']);
        Route::post('/suppliers/{id}/products', [SupplierController::class, 'addProduct']);
        Route::put('/suppliers/{id}/products/{supplierProdId}', [SupplierController::class, 'updateProduct']);
        Route::delete('/suppliers/{id}/products/{productId}', [SupplierController::class, 'removeProduct']);
    });
    Route::middleware('role:admin')->group(function () {
        Route::delete('/suppliers/{id}', [SupplierController::class, 'destroy']);
    });

    /*
    |--------------------------------------------------------------------------
    | ERD: CUSTOMER (customer)
    |--------------------------------------------------------------------------
    */
    Route::get('/customers', [CustomerController::class, 'index']);
    Route::get('/customers/search', [CustomerController::class, 'search']);
    Route::get('/customers/{customer}', [CustomerController::class, 'show']);
    Route::post('/customers', [CustomerController::class, 'store']);
    Route::put('/customers/{customer}', [CustomerController::class, 'update']);
    Route::delete('/customers/{customer}', [CustomerController::class, 'destroy']);

    /*
    |--------------------------------------------------------------------------
    | ERD: PURCHASE_ORDER (purchase_order)
    |--------------------------------------------------------------------------
    */
    Route::get('/purchase-orders', [PurchaseOrderController::class, 'index']);
    Route::get('/purchase-orders/{id}', [PurchaseOrderController::class, 'show']);
    Route::middleware('role:admin,branch_manager')->group(function () {
        Route::post('/purchase-orders', [PurchaseOrderController::class, 'store']);
        Route::put('/purchase-orders/{id}', [PurchaseOrderController::class, 'update']);
    });
    Route::middleware('role:admin')->group(function () {
        Route::delete('/purchase-orders/{id}', [PurchaseOrderController::class, 'destroy']);
    });

    /*
    |--------------------------------------------------------------------------
    | ERD: RECEIVING (RECEIVING)
    |--------------------------------------------------------------------------
    */
    Route::get('/receivings', [ReceivingController::class, 'index']);
    Route::get('/receivings/{id}', [ReceivingController::class, 'show']);
    Route::middleware('role:admin,branch_manager,warehouse_personnel')->group(function () {
        Route::post('/receivings', [ReceivingController::class, 'store']);
        Route::put('/receivings/{id}', [ReceivingController::class, 'update']);
    });
    Route::middleware('role:admin')->group(function () {
        Route::delete('/receivings/{id}', [ReceivingController::class, 'destroy']);
    });

    /*
    |--------------------------------------------------------------------------
    | ERD: PURCHASE_RETURN (purchase_return)
    |--------------------------------------------------------------------------
    */
    Route::get('/purchase-returns', [PurchaseReturnController::class, 'index']);
    Route::get('/purchase-returns/{id}', [PurchaseReturnController::class, 'show']);
    Route::middleware('role:admin,branch_manager')->group(function () {
        Route::post('/purchase-returns', [PurchaseReturnController::class, 'store']);
        Route::put('/purchase-returns/{id}', [PurchaseReturnController::class, 'update']);
    });
    Route::middleware('role:admin')->group(function () {
        Route::delete('/purchase-returns/{id}', [PurchaseReturnController::class, 'destroy']);
    });

    /*
    |--------------------------------------------------------------------------
    | ERD: SALES (sales)
    |--------------------------------------------------------------------------
    */
    Route::get('/sales', [SaleController::class, 'index']);
    Route::get('/sales/{id}', [SaleController::class, 'show']);
    Route::middleware('role:admin,branch_manager,inventory_analyst')->group(function () {
        Route::post('/sales', [SaleController::class, 'store']);
    });
    Route::middleware('role:admin,branch_manager')->group(function () {
        Route::put('/sales/{id}', [SaleController::class, 'update']);
    });
    Route::middleware('role:admin')->group(function () {
        Route::delete('/sales/{id}', [SaleController::class, 'destroy']);
    });

    /*
    |--------------------------------------------------------------------------
    | ERD: DELIVERY_RECEIPT (delivery_receipt)
    |--------------------------------------------------------------------------
    */
    Route::get('/delivery-receipts', [DeliveryReceiptController::class, 'index']);
    Route::get('/delivery-receipts/{id}', [DeliveryReceiptController::class, 'show']);
    Route::middleware('role:admin,branch_manager')->group(function () {
        Route::post('/delivery-receipts', [DeliveryReceiptController::class, 'store']);
        Route::put('/delivery-receipts/{id}', [DeliveryReceiptController::class, 'update']);
    });
    Route::middleware('role:admin')->group(function () {
        Route::delete('/delivery-receipts/{id}', [DeliveryReceiptController::class, 'destroy']);
    });

    /*
    |--------------------------------------------------------------------------
    | ERD: ISSUANCE (issuance)
    |--------------------------------------------------------------------------
    */
    Route::get('/issuances', [IssuanceController::class, 'index']);
    Route::get('/issuances/{id}', [IssuanceController::class, 'show']);
    Route::middleware('role:admin,branch_manager,warehouse_personnel')->group(function () {
        Route::post('/issuances', [IssuanceController::class, 'store']);
        Route::put('/issuances/{id}', [IssuanceController::class, 'update']);
    });
    Route::middleware('role:admin')->group(function () {
        Route::delete('/issuances/{id}', [IssuanceController::class, 'destroy']);
    });

    /*
    |--------------------------------------------------------------------------
    | ERD: TRANSFER (transfer)
    |--------------------------------------------------------------------------
    */
    Route::get('/transfers', [TransferController::class, 'index']);
    Route::get('/transfers/{id}', [TransferController::class, 'show']);
    Route::middleware('role:admin,branch_manager,warehouse_personnel')->group(function () {
        Route::post('/transfers', [TransferController::class, 'store']);
        Route::put('/transfers/{id}', [TransferController::class, 'update']);
        Route::post('/transfers/{id}/tracking', [TransferController::class, 'addTracking']);
    });
    Route::middleware('role:admin')->group(function () {
        Route::delete('/transfers/{id}', [TransferController::class, 'destroy']);
    });

    /*
    |--------------------------------------------------------------------------
    | ERD: ADJUSTMENT (adjustment)
    |--------------------------------------------------------------------------
    */
    Route::get('/adjustments', [AdjustmentController::class, 'index']);
    Route::get('/adjustments/{id}', [AdjustmentController::class, 'show']);
    Route::middleware('role:admin,branch_manager,warehouse_personnel')->group(function () {
        Route::post('/adjustments', [AdjustmentController::class, 'store']);
        Route::put('/adjustments/{id}', [AdjustmentController::class, 'update']);
    });
    Route::middleware('role:admin')->group(function () {
        Route::delete('/adjustments/{id}', [AdjustmentController::class, 'destroy']);
    });

    /*
    |--------------------------------------------------------------------------
    | ERD: PROFIT_LOSS (profit_loss)
    |--------------------------------------------------------------------------
    */
    Route::get('/profit-loss', [ProfitLossController::class, 'index']);
    Route::get('/profit-loss/{id}', [ProfitLossController::class, 'show']);
    Route::middleware('role:admin,branch_manager')->group(function () {
        Route::post('/profit-loss', [ProfitLossController::class, 'store']);
        Route::put('/profit-loss/{id}', [ProfitLossController::class, 'update']);
    });
    Route::middleware('role:admin')->group(function () {
        Route::delete('/profit-loss/{id}', [ProfitLossController::class, 'destroy']);
    });

    /*
    |--------------------------------------------------------------------------
    | ERD: AUDIT_LOG (audit_log)
    |--------------------------------------------------------------------------
    */
    Route::middleware('role:admin')->group(function () {
        Route::get('/audit-log', function (Illuminate\Http\Request $request) {
            $query = \App\Models\AuditLog::with('user')->orderBy('created_at', 'desc');
            if ($request->has('user_id')) {
                $query->where('user_id', $request->user_id);
            }
            if ($request->has('action')) {
                $query->where('action', $request->action);
            }
            return $query->paginate($request->get('per_page', 50));
        });

        Route::get('/audit-trail', function () {
            return \App\Models\AuditTrail::with('user')
                ->orderBy('created_at', 'desc')
                ->paginate(50);
        });

        Route::get('/audit-trail/user/{userId}', function ($userId) {
            return \App\Models\AuditTrail::where('user_id', $userId)
                ->orderBy('created_at', 'desc')
                ->paginate(50);
        });
    });

    /*
    |--------------------------------------------------------------------------
    | ERD: ACTIVITY_LOG (activity_log)
    |--------------------------------------------------------------------------
    */
    Route::get('/activity-log', [ActivityLogController::class, 'index']);
    Route::get('/activity-log/{id}', [ActivityLogController::class, 'show']);
    Route::post('/activity-log', [ActivityLogController::class, 'store']);
    Route::middleware('role:admin')->group(function () {
        Route::delete('/activity-log/{id}', [ActivityLogController::class, 'destroy']);
    });

    /*
    |--------------------------------------------------------------------------
    | INVENTORY (legacy scan/adjust endpoints via InventoryController)
    |--------------------------------------------------------------------------
    */
    Route::get('/inventory', [InventoryController::class, 'index']);
    Route::get('/inventory/{inventory}', [InventoryController::class, 'show']);
    Route::get('/inventory/location/{location}', [InventoryController::class, 'byLocation']);
    Route::get('/inventory/product/{product}', [InventoryController::class, 'byItem']);
    Route::post('/inventory/scan-barcode', [InventoryController::class, 'scanBarcode']);

    /*
    |--------------------------------------------------------------------------
    | REPORTS & ANALYTICS
    |--------------------------------------------------------------------------
    */
    Route::prefix('reports')->group(function () {
        Route::get('/inventory-valuation', function () {
            $products = \App\Models\Product::with(['category', 'brand'])
                ->select('products.*')
                ->get()
                ->map(fn($p) => [
                    'product_id'   => $p->product_id,
                    'product_name' => $p->product_name,
                    'category'     => $p->category?->category_name,
                    'brand'        => $p->brand?->brand_name,
                    'quantity'     => $p->quantity,
                    'cost_price'   => $p->cost_price,
                    'total_value'  => $p->quantity * $p->cost_price,
                ]);
            return response()->json(['success' => true, 'data' => $products]);
        });
        Route::get('/sales-summary', function (Illuminate\Http\Request $request) {
            $query = \App\Models\Sale::with('customer');
            if ($request->has('date_from')) {
                $query->where('sale_date', '>=', $request->date_from);
            }
            if ($request->has('date_to')) {
                $query->where('sale_date', '<=', $request->date_to);
            }
            return response()->json(['success' => true, 'data' => $query->paginate(50)]);
        });
        Route::get('/movement-history', function () {
            return response()->json(['success' => true, 'data' => \App\Models\Transfer::with(['fromLocation', 'toLocation'])->orderBy('created_at', 'desc')->paginate(50)]);
        });
        Route::get('/low-stock-report', function () {
            $products = \App\Models\Product::whereColumn('quantity', '<=', 'recommended_stocks')
                ->with(['category', 'brand'])
                ->get();
            return response()->json(['success' => true, 'data' => $products]);
        });
        Route::get('/adjustments-summary', function (Illuminate\Http\Request $request) {
            $query = \App\Models\Adjustment::with(['location', 'createdBy']);
            if ($request->has('location_id')) {
                $query->where('location_id', $request->location_id);
            }
            return response()->json(['success' => true, 'data' => $query->orderBy('created_at', 'desc')->paginate(50)]);
        });
        Route::get('/receivings-summary', function (Illuminate\Http\Request $request) {
            $query = \App\Models\Receiving::with(['purchaseOrder.supplier', 'location', 'receivedBy']);
            if ($request->has('location_id')) {
                $query->where('location_id', $request->location_id);
            }
            return response()->json(['success' => true, 'data' => $query->orderBy('created_at', 'desc')->paginate(50)]);
        });
        Route::get('/profit-loss-summary', function (Illuminate\Http\Request $request) {
            $query = \App\Models\ProfitLoss::with(['product', 'model', 'recordedBy']);
            if ($request->has('product_id')) {
                $query->where('product_id', $request->product_id);
            }
            return response()->json([
                'success' => true,
                'data'    => $query->orderBy('created_at', 'desc')->paginate(50),
                'summary' => ['total_loss' => \App\Models\ProfitLoss::sum('total_loss_amount')],
            ]);
        });
    });
});
