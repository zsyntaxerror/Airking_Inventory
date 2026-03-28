<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

/**
 * ERD Alignment Fixes
 *
 *  1. model_lookup   – The table exists but was created with a bare schema (only
 *                      id/timestamps). Drop and recreate with the correct ERD columns:
 *                      model_id PK, brand_id FK, subcategory_id FK, model_code,
 *                      variant, capacity, status_id FK.
 *
 *  2. adjustments    – Rename `date` → `adjustment_date` (matches ERD column name).
 *
 *  3. purchase_orders – Rename `po_number` → `pc_number` (matches ERD column name).
 */
return new class extends Migration
{
    public function up(): void
    {
        // =====================================================================
        // 1. REBUILD model_lookup with correct ERD schema
        // =====================================================================

        // Disable FK checks so we can drop/recreate without worrying about
        // referencing tables (products.model_id, profit_loss.model_id).
        DB::statement('SET FOREIGN_KEY_CHECKS=0');

        Schema::dropIfExists('model_lookup');

        Schema::create('model_lookup', function (Blueprint $table) {
            $table->id('model_id');
            $table->unsignedBigInteger('brand_id')->nullable();
            $table->unsignedBigInteger('subcategory_id')->nullable();
            $table->string('model_code', 100);
            $table->string('variant', 100)->nullable();
            $table->string('capacity', 50)->nullable();   // e.g. 1HP, 1.5HP, 2HP, 3HP, 5HP
            $table->unsignedBigInteger('status_id')->nullable();
            $table->timestamps();

            $table->unique(['brand_id', 'model_code']);
        });

        // Add FK constraints individually (inside try/catch so a missing parent
        // table never prevents the overall migration from completing).
        try {
            Schema::table('model_lookup', function (Blueprint $table) {
                $table->foreign('brand_id')
                      ->references('brand_id')->on('brand_lookup')
                      ->onDelete('set null');
            });
        } catch (\Throwable $e) {}

        try {
            Schema::table('model_lookup', function (Blueprint $table) {
                $table->foreign('subcategory_id')
                      ->references('subcategory_id')->on('subcategory_lookup')
                      ->onDelete('set null');
            });
        } catch (\Throwable $e) {}

        try {
            Schema::table('model_lookup', function (Blueprint $table) {
                $table->foreign('status_id')
                      ->references('status_id')->on('status_lookup')
                      ->onDelete('set null');
            });
        } catch (\Throwable $e) {}

        DB::statement('SET FOREIGN_KEY_CHECKS=1');

        // =====================================================================
        // 2. FIX adjustments — rename `date` → `adjustment_date`
        // =====================================================================
        if (Schema::hasTable('adjustments')) {
            if (Schema::hasColumn('adjustments', 'date') &&
                !Schema::hasColumn('adjustments', 'adjustment_date')) {
                Schema::table('adjustments', function (Blueprint $table) {
                    $table->renameColumn('date', 'adjustment_date');
                });
            }
        }

        // =====================================================================
        // 3. FIX purchase_orders — rename `po_number` → `pc_number`
        // =====================================================================
        if (Schema::hasTable('purchase_orders')) {
            if (Schema::hasColumn('purchase_orders', 'po_number') &&
                !Schema::hasColumn('purchase_orders', 'pc_number')) {

                // Drop unique index before renaming
                try {
                    Schema::table('purchase_orders', function (Blueprint $table) {
                        $table->dropUnique(['po_number']);
                    });
                } catch (\Throwable $e) {}

                Schema::table('purchase_orders', function (Blueprint $table) {
                    $table->renameColumn('po_number', 'pc_number');
                });

                // Re-add unique on new name
                try {
                    Schema::table('purchase_orders', function (Blueprint $table) {
                        $table->unique('pc_number');
                    });
                } catch (\Throwable $e) {}
            }
        }
    }

    public function down(): void
    {
        // Reverse purchase_orders rename
        if (Schema::hasTable('purchase_orders') &&
            Schema::hasColumn('purchase_orders', 'pc_number') &&
            !Schema::hasColumn('purchase_orders', 'po_number')) {
            try { Schema::table('purchase_orders', fn($t) => $t->dropUnique(['pc_number'])); } catch (\Throwable $e) {}
            Schema::table('purchase_orders', fn($t) => $t->renameColumn('pc_number', 'po_number'));
            try { Schema::table('purchase_orders', fn($t) => $t->unique('po_number')); } catch (\Throwable $e) {}
        }

        // Reverse adjustments rename
        if (Schema::hasTable('adjustments') &&
            Schema::hasColumn('adjustments', 'adjustment_date') &&
            !Schema::hasColumn('adjustments', 'date')) {
            Schema::table('adjustments', fn($t) => $t->renameColumn('adjustment_date', 'date'));
        }

        // Drop the rebuilt model_lookup (no rollback of the original broken state)
        DB::statement('SET FOREIGN_KEY_CHECKS=0');
        Schema::dropIfExists('model_lookup');
        DB::statement('SET FOREIGN_KEY_CHECKS=1');
    }
};
