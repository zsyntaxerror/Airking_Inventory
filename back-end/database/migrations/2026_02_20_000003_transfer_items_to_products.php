<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Transfer item master data from items table to products table (ERD).
 * Maps: items.code->product_code, items.name->product_name, items.barcode->barcode,
 *       items.price->unit_price & cost_price, items.category->category_id,
 *       items.brand->brand_id, items.unit->unit_id, items.status->status_id.
 */
return new class extends Migration
{
    public function up(): void
    {
        // Ensure unit_lookup has common units
        $units = [
            ['unit_name' => 'Unit', 'unit_abbreviation' => 'pc', 'created_at' => now(), 'updated_at' => now()],
            ['unit_name' => 'Piece', 'unit_abbreviation' => 'pc', 'created_at' => now(), 'updated_at' => now()],
            ['unit_name' => 'Roll', 'unit_abbreviation' => 'roll', 'created_at' => now(), 'updated_at' => now()],
        ];
        foreach ($units as $u) {
            if (DB::table('unit_lookup')->where('unit_name', $u['unit_name'])->doesntExist()) {
                DB::table('unit_lookup')->insert($u);
            }
        }

        // Ensure status_lookup has Inactive
        if (DB::table('status_lookup')->where('status_name', 'Inactive')->doesntExist()) {
            $inactive = [
                'status_name' => 'Inactive',
                'status_category' => 'product',
                'created_at' => now(),
                'updated_at' => now(),
            ];
            if (Schema::hasColumn('status_lookup', 'is_active')) {
                $inactive['is_active'] = 1;
            }
            DB::table('status_lookup')->insert($inactive);
        }

        $categories = DB::table('category_lookup')->pluck('category_id', 'category_name')->toArray();
        $brands = DB::table('brand_lookup')->pluck('brand_id', 'brand_name')->toArray();
        $unitsMap = DB::table('unit_lookup')->pluck('unit_id', 'unit_name')->toArray();
        $statusMap = DB::table('status_lookup')->pluck('status_id', 'status_name')->toArray();

        $items = DB::table('items')->get();

        foreach ($items as $item) {
            // Skip if product with same code already exists
            if (DB::table('products')->where('product_code', $item->code)->exists()) {
                continue;
            }

            $categoryId = $categories[$item->category ?? ''] ?? null;
            $brandId = $brands[$item->brand ?? ''] ?? null;
            $unitId = $unitsMap[$item->unit ?? ''] ?? $unitsMap['Unit'] ?? $unitsMap['Piece'] ?? null;
            $statusId = $statusMap[$item->status ?? 'Active'] ?? $statusMap['Active'] ?? null;

            DB::table('products')->insert([
                'unit_id' => $unitId,
                'category_id' => $categoryId,
                'brand_id' => $brandId,
                'model_id' => null,
                'barcode' => $item->barcode ?? null,
                'product_code' => $item->code,
                'product_name' => $item->name ?? $item->code,
                'unit_price' => $item->price ?? 0,
                'cost_price' => $item->price ?? 0,
                'warranty_period_months' => 0,
                'status_id' => $statusId,
                'created_at' => $item->created_at ?? now(),
                'updated_at' => $item->updated_at ?? now(),
            ]);
        }

        // Transfer inventories (branch/item) to inventory (location/product)
        if (Schema::hasTable('inventories') && Schema::hasTable('inventory')) {
            $locPk = Schema::hasColumn('locations', 'location_id') ? 'location_id' : 'id';
            $branchCol = Schema::hasColumn('locations', 'branch_id') ? 'branch_id' : null;
            $branchToLocation = [];
            if ($branchCol) {
                $branchToLocation = DB::table('locations')->orderBy($locPk)->pluck($locPk, $branchCol)->toArray();
            }

            foreach (DB::table('inventories')->get() as $inv) {
                $productId = null;
                $item = DB::table('items')->find($inv->item_id);
                if ($item) {
                    $product = DB::table('products')->where('product_code', $item->code)->first();
                    $productId = $product?->product_id;
                }
                $locationId = $branchToLocation[$inv->branch_id ?? 0] ?? null;
                if (!$productId || !$locationId) {
                    continue;
                }
                $qty = (int) ($inv->quantity ?? 0);
                if ($qty <= 0) {
                    continue;
                }
                $existing = DB::table('inventory')->where('product_id', $productId)->where('location_id', $locationId)->first();
                if ($existing) {
                    DB::table('inventory')->where('inventory_id', $existing->inventory_id)->update([
                        'quantity_on_hand' => $existing->quantity_on_hand + $qty,
                        'available_quantity' => ($existing->available_quantity ?? 0) + $qty,
                        'last_updated' => now(),
                        'updated_at' => now(),
                    ]);
                } else {
                    DB::table('inventory')->insert([
                        'location_id' => $locationId,
                        'product_id' => $productId,
                        'quantity_on_hand' => $qty,
                        'available_quantity' => $qty,
                        'reorder_level' => 0,
                        'last_updated' => now(),
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);
                }
            }
        }
    }

    public function down(): void
    {
        // Remove products that were migrated from items (by product_code matching items.code)
        $codes = DB::table('items')->pluck('code');
        DB::table('products')->whereIn('product_code', $codes)->delete();
    }
};
