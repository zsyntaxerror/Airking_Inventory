<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * Align products table with ERD: remove non-ERD attributes, add model_id.
 * ERD Product: product_id, unit_id, category_id, barcode, product_code, product_name,
 *              brand_id, model_id, unit_price, cost_price, warranty_period_months,
 *              status_id, created_at, updated_at
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('products', function (Blueprint $table) {
            if (Schema::hasColumn('products', 'subcategory_id')) {
                $table->dropForeign(['subcategory_id']);
                $table->dropColumn('subcategory_id');
            }
        });

        if (Schema::hasColumn('products', 'supplier_id')) {
            $dbName = \DB::getDatabaseName();
            $fkExists = \DB::selectOne("
                SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
                WHERE TABLE_SCHEMA = ? AND TABLE_NAME = 'products' AND CONSTRAINT_NAME = 'products_supplier_id_foreign'
            ", [$dbName]);
            if ($fkExists) {
                Schema::table('products', fn (Blueprint $t) => $t->dropForeign(['supplier_id']));
            }
            Schema::table('products', fn (Blueprint $t) => $t->dropColumn('supplier_id'));
        }

        Schema::table('products', function (Blueprint $table) {
            $drops = ['brand_name', 'brand', 'model', 'model_no', 'unit', 'selling_price', 'currently_stored_quantity'];
            foreach ($drops as $col) {
                if (Schema::hasColumn('products', $col)) {
                    $table->dropColumn($col);
                }
            }
        });

        if (!Schema::hasColumn('products', 'model_id')) {
            Schema::table('products', function (Blueprint $table) {
                $table->unsignedBigInteger('model_id')->nullable()->after('brand_id');
            });
        }
    }

    public function down(): void
    {
        Schema::table('products', function (Blueprint $table) {
            if (Schema::hasColumn('products', 'model_id')) {
                try {
                    $table->dropForeign(['model_id']);
                } catch (\Throwable $e) {
                    // FK may not exist
                }
                $table->dropColumn('model_id');
            }
        });

        Schema::table('products', function (Blueprint $table) {
            $table->unsignedBigInteger('subcategory_id')->nullable();
            $table->unsignedBigInteger('supplier_id')->nullable();
            $table->string('brand_name', 100)->nullable();
            $table->string('brand', 100)->nullable();
            $table->string('model', 100)->nullable();
            $table->string('model_no', 100)->nullable();
            $table->string('unit', 50)->nullable();
            $table->decimal('selling_price', 10, 2)->nullable();
            $table->integer('currently_stored_quantity')->default(0);
            $table->foreign('subcategory_id')->references('subcategory_id')->on('subcategory_lookup')->onDelete('set null');
            $table->foreign('supplier_id')->references('id')->on('suppliers')->onDelete('set null');
        });
    }
};
