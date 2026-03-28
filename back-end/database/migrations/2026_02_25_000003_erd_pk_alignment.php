<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

/**
 * ERD PK Alignment
 *
 *  1. receivings        – add supplier_id FK (ERD shows it, column was missing)
 *  2. suppliers         – rename id → supplier_id  (ERD PK name)
 *  3. locations         – rename id → location_id  (ERD PK name)
 *
 * All FK constraints referencing these PKs are dropped first and re-added
 * under the new column name.
 */
return new class extends Migration
{
    public function up(): void
    {
        DB::statement('SET FOREIGN_KEY_CHECKS=0');

        // ── 1. receivings — add supplier_id ──────────────────────────────────
        if (Schema::hasTable('receivings') && !Schema::hasColumn('receivings', 'supplier_id')) {
            Schema::table('receivings', function (Blueprint $table) {
                $table->unsignedBigInteger('supplier_id')->nullable()->after('pc_id');
            });
            try {
                Schema::table('receivings', function (Blueprint $table) {
                    $table->foreign('supplier_id')
                          ->references('id')->on('suppliers')
                          ->onDelete('set null');
                });
            } catch (\Throwable $e) {}
        }

        // ── 2. suppliers: id → supplier_id ───────────────────────────────────
        if (Schema::hasTable('suppliers')
            && Schema::hasColumn('suppliers', 'id')
            && !Schema::hasColumn('suppliers', 'supplier_id')) {

            // Drop FKs referencing suppliers.id
            try { DB::statement('ALTER TABLE purchase_returns DROP FOREIGN KEY purchase_returns_supplier_id_foreign'); } catch (\Throwable $e) {}
            try { DB::statement('ALTER TABLE supplier_product DROP FOREIGN KEY supplier_product_supplier_id_foreign'); } catch (\Throwable $e) {}
            try { DB::statement('ALTER TABLE receivings DROP FOREIGN KEY receivings_supplier_id_foreign'); } catch (\Throwable $e) {}

            // Rename PK atomically
            DB::statement('ALTER TABLE suppliers DROP PRIMARY KEY, CHANGE COLUMN `id` `supplier_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, ADD PRIMARY KEY (`supplier_id`)');

            // Re-add FKs pointing to the new column name
            try {
                Schema::table('purchase_returns', function (Blueprint $table) {
                    $table->foreign('supplier_id')->references('supplier_id')->on('suppliers')->onDelete('set null');
                });
            } catch (\Throwable $e) {}
            try {
                Schema::table('supplier_product', function (Blueprint $table) {
                    $table->foreign('supplier_id')->references('supplier_id')->on('suppliers')->onDelete('cascade');
                });
            } catch (\Throwable $e) {}
            try {
                Schema::table('receivings', function (Blueprint $table) {
                    $table->foreign('supplier_id')->references('supplier_id')->on('suppliers')->onDelete('set null');
                });
            } catch (\Throwable $e) {}
        }

        // ── 3. locations: id → location_id ───────────────────────────────────
        if (Schema::hasTable('locations')
            && Schema::hasColumn('locations', 'id')
            && !Schema::hasColumn('locations', 'location_id')) {

            // Drop all FKs referencing locations.id
            $locationFks = [
                'adjustments'             => 'adjustments_location_id_foreign',
                'issuances'               => 'issuances_location_id_foreign',
                'restock_recommendations' => 'restock_recommendations_location_id_foreign',
                'sales'                   => 'sales_location_id_foreign',
                'tbl_transfer_tracking'   => 'tbl_transfer_tracking_location_id_foreign',
                'transfers'               => ['transfers_from_location_id_foreign', 'transfers_to_location_id_foreign'],
            ];
            foreach ($locationFks as $table => $fk) {
                foreach ((array) $fk as $name) {
                    try { DB::statement("ALTER TABLE $table DROP FOREIGN KEY $name"); } catch (\Throwable $e) {}
                }
            }
            // Also drop any other implicit FKs from purchase_orders, receivings, inventory
            $extraFks = [
                'purchase_orders' => 'purchase_orders_location_id_foreign',
                'receivings'      => 'receivings_location_id_foreign',
                'inventory'       => 'inventory_location_id_foreign',
            ];
            foreach ($extraFks as $table => $fk) {
                try { DB::statement("ALTER TABLE $table DROP FOREIGN KEY $fk"); } catch (\Throwable $e) {}
            }

            // Rename PK atomically
            DB::statement('ALTER TABLE locations DROP PRIMARY KEY, CHANGE COLUMN `id` `location_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, ADD PRIMARY KEY (`location_id`)');

            // Re-add FKs
            $reAddFks = [
                'adjustments'             => 'location_id',
                'issuances'               => 'location_id',
                'sales'                   => 'location_id',
                'tbl_transfer_tracking'   => 'location_id',
                'purchase_orders'         => 'location_id',
                'receivings'              => 'location_id',
            ];
            foreach ($reAddFks as $table => $col) {
                if (Schema::hasTable($table) && Schema::hasColumn($table, $col)) {
                    try {
                        Schema::table($table, function (Blueprint $t) use ($col) {
                            $t->foreign($col)->references('location_id')->on('locations')->onDelete('set null');
                        });
                    } catch (\Throwable $e) {}
                }
            }
            // transfers has two FKs
            try {
                Schema::table('transfers', function (Blueprint $t) {
                    $t->foreign('from_location_id')->references('location_id')->on('locations')->onDelete('set null');
                    $t->foreign('to_location_id')->references('location_id')->on('locations')->onDelete('set null');
                });
            } catch (\Throwable $e) {}
        }

        DB::statement('SET FOREIGN_KEY_CHECKS=1');
    }

    public function down(): void
    {
        DB::statement('SET FOREIGN_KEY_CHECKS=0');

        // Reverse locations rename
        if (Schema::hasTable('locations')
            && Schema::hasColumn('locations', 'location_id')
            && !Schema::hasColumn('locations', 'id')) {
            DB::statement('ALTER TABLE locations DROP PRIMARY KEY, CHANGE COLUMN `location_id` `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, ADD PRIMARY KEY (`id`)');
        }

        // Reverse suppliers rename
        if (Schema::hasTable('suppliers')
            && Schema::hasColumn('suppliers', 'supplier_id')
            && !Schema::hasColumn('suppliers', 'id')) {
            DB::statement('ALTER TABLE suppliers DROP PRIMARY KEY, CHANGE COLUMN `supplier_id` `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, ADD PRIMARY KEY (`id`)');
        }

        // Drop the added supplier_id from receivings
        if (Schema::hasTable('receivings') && Schema::hasColumn('receivings', 'supplier_id')) {
            try { DB::statement('ALTER TABLE receivings DROP FOREIGN KEY receivings_supplier_id_foreign'); } catch (\Throwable $e) {}
            Schema::table('receivings', fn(Blueprint $t) => $t->dropColumn('supplier_id'));
        }

        DB::statement('SET FOREIGN_KEY_CHECKS=1');
    }
};
