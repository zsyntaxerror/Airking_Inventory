<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Migrate from items to products: add product_id, migrate data, drop item_id.
 * Then drop items and items_master tables.
 */
return new class extends Migration
{
    public function up(): void
    {
        $itemToProduct = DB::table('items')
            ->join('products', 'products.product_code', '=', 'items.code')
            ->pluck('products.product_id', 'items.id')
            ->toArray();

        if (Schema::hasTable('inventories_old')) {
            Schema::dropIfExists('inventories_old');
        }

        // inventories: recreate table with product_id instead of item_id
        if (Schema::hasTable('inventories') && Schema::hasColumn('inventories', 'item_id')) {
            if (!Schema::hasColumn('inventories', 'product_id')) {
                Schema::table('inventories', function (Blueprint $table) {
                    $table->unsignedBigInteger('product_id')->nullable()->after('branch_id');
                });
            }
            foreach (DB::table('inventories')->get() as $row) {
                $productId = $itemToProduct[$row->item_id ?? 0] ?? null;
                if ($productId) {
                    DB::table('inventories')->where('id', $row->id)->update(['product_id' => $productId]);
                }
            }
            Schema::rename('inventories', 'inventories_old');
            Schema::create('inventories', function (Blueprint $table) {
                $table->id();
                $table->unsignedBigInteger('branch_id');
                $table->unsignedBigInteger('product_id');
                $table->integer('quantity')->default(0);
                $table->integer('reserved')->default(0);
                $table->timestamps();
                $table->unique(['branch_id', 'product_id'], 'inv_branch_product_unique');
            });
            Schema::table('inventories', function (Blueprint $table) {
                $table->foreign('branch_id', 'inv_branch_fk')->references('id')->on('branches')->onDelete('cascade');
                $table->foreign('product_id', 'inv_product_fk')->references('product_id')->on('products')->onDelete('cascade');
            });
            $rows = DB::table('inventories_old')->whereNotNull('product_id')->get();
            $merged = [];
            foreach ($rows as $row) {
                $key = $row->branch_id . '_' . $row->product_id;
                if (!isset($merged[$key])) {
                    $merged[$key] = ['branch_id' => $row->branch_id, 'product_id' => $row->product_id, 'quantity' => 0, 'reserved' => 0, 'created_at' => $row->created_at, 'updated_at' => $row->updated_at];
                }
                $merged[$key]['quantity'] += $row->quantity;
                $merged[$key]['reserved'] += $row->reserved;
            }
            foreach ($merged as $r) {
                DB::table('inventories')->insert($r);
            }
            Schema::drop('inventories_old');
        }

        // Drop items_master and items (disable FK checks for tables that reference them)
        DB::statement('SET FOREIGN_KEY_CHECKS=0');
        Schema::dropIfExists('items_master');
        Schema::dropIfExists('items');
        DB::statement('SET FOREIGN_KEY_CHECKS=1');
    }

    public function down(): void
    {
        // Recreate items from products (simplified - only products that came from items migration)
        Schema::create('items', function (Blueprint $table) {
            $table->id();
            $table->string('code')->unique();
            $table->string('name');
            $table->string('category');
            $table->text('description')->nullable();
            $table->decimal('price', 10, 2)->nullable();
            $table->integer('reorder_level')->default(5);
            $table->timestamps();
        });
        Schema::table('items', function (Blueprint $table) {
            $table->string('brand', 100)->nullable();
            $table->string('barcode', 50)->nullable();
            $table->string('unit', 20)->default('Unit');
            $table->string('supplier', 255)->nullable();
            $table->string('status', 20)->default('Active');
            $table->string('type', 30)->nullable();
        });
        // Note: Reverse migration would need to repopulate items from products and restore item_id - complex, left minimal
    }
};
