<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * Updates table attributes to match the ERD.
 */
return new class extends Migration
{
    public function up(): void
    {
        // Customers: add customer_code, status_id per ERD
        if (Schema::hasTable('customers')) {
            Schema::table('customers', function (Blueprint $table) {
                if (!Schema::hasColumn('customers', 'customer_code')) {
                    $table->string('customer_code', 50)->nullable();
                }
                if (!Schema::hasColumn('customers', 'status_id')) {
                    $table->unsignedBigInteger('status_id')->nullable();
                }
            });
        }

        // Inventory (tbl_Inventory): add status_id, condition if missing
        if (Schema::hasTable('inventory')) {
            Schema::table('inventory', function (Blueprint $table) {
                if (!Schema::hasColumn('inventory', 'status_id')) {
                    $table->unsignedBigInteger('status_id')->nullable()->after('product_id');
                }
                if (!Schema::hasColumn('inventory', 'condition')) {
                    $table->string('condition', 50)->nullable()->after('quantity_on_hand');
                }
            });
        }

        // Products: ensure barcode exists
        if (Schema::hasTable('products') && !Schema::hasColumn('products', 'barcode')) {
            Schema::table('products', function (Blueprint $table) {
                $table->string('barcode', 100)->nullable()->after('product_code');
            });
        }

        // Roles: ensure description exists (ERD has role_name only, we keep description)
        // status_lookup: ensure is_active
        if (Schema::hasTable('status_lookup') && !Schema::hasColumn('status_lookup', 'is_active')) {
            Schema::table('status_lookup', function (Blueprint $table) {
                $table->boolean('is_active')->default(true)->after('status_category');
            });
        }
    }

    public function down(): void
    {
        if (Schema::hasTable('customers')) {
            Schema::table('customers', function (Blueprint $table) {
                if (Schema::hasColumn('customers', 'customer_code')) {
                    $table->dropColumn('customer_code');
                }
                if (Schema::hasColumn('customers', 'status_id')) {
                    $table->dropColumn('status_id');
                }
            });
        }
        if (Schema::hasTable('inventory')) {
            Schema::table('inventory', function (Blueprint $table) {
                if (Schema::hasColumn('inventory', 'status_id')) {
                    $table->dropColumn('status_id');
                }
                if (Schema::hasColumn('inventory', 'condition')) {
                    $table->dropColumn('condition');
                }
            });
        }
    }
};
