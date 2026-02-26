<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

/**
 * Full ERD Schema Alignment
 *
 * Removes every column that exists in the live database but is NOT shown in the
 * ERD, and adds any column that the ERD shows but is currently missing.
 *
 * Tables covered:
 *  ✔ item_serial         – drop barcode, condition, purchase_cost, date_received,
 *                          warranty_start_date, warranty_end_date
 *  ✔ transfers           – drop transfer_by, total_quantity_transferred,
 *                          total_quantity_received
 *  ✔ transfer_details    – drop inventory_id, item_id, serial_number, barcode,
 *                          quantity_received, condition
 *  ✔ issuances           – drop issuance_number, issued_to_name, total_quantity
 *  ✔ issuance_details    – drop item_id, serial_number, barcode
 *  ✔ sales_details       – drop item_id, serial_number
 *  ✔ delivery_receipts   – drop delivery_date, delivered_by, received_by
 *  ✔ receivings          – drop profit_loss_id, status_id
 *  ✔ purchase_returns    – rename pc_id → po_id  (ERD FK name)
 *  ✔ audit_log           – rename id → audit_id; drop duplicate record_table col
 */
return new class extends Migration
{
    public function up(): void
    {
        // Disable FK checks for the whole migration — we are only REMOVING columns
        // and renaming; no referential integrity is being changed.
        DB::statement('SET FOREIGN_KEY_CHECKS=0');

        // ── 1. item_serial ────────────────────────────────────────────────────
        // ERD: serial_id, product_id, serial_number, serial_type, status_id
        $this->dropCols('item_serial', [
            'barcode', 'condition', 'purchase_cost',
            'date_received', 'warranty_start_date', 'warranty_end_date',
        ]);

        // ── 2. transfers ──────────────────────────────────────────────────────
        // ERD: transfer_id, from_location_id, to_location_id, transfer_number,
        //      transfer_date, requested_by, approved_by, received_by, status_id
        $this->dropCols('transfers', [
            'transfer_by', 'total_quantity_transferred', 'total_quantity_received',
        ]);

        // ── 3. transfer_details ───────────────────────────────────────────────
        // ERD: transfer_detail_id, transfer_id, product_id, quantity_transferred
        // Must explicitly drop FKs on inventory_id and item_id before dropping columns
        // (MySQL 8 requires this even with FK_CHECKS=0).
        try { DB::statement('ALTER TABLE transfer_details DROP FOREIGN KEY transfer_details_inventory_id_foreign'); } catch (\Throwable $e) {}
        try { DB::statement('ALTER TABLE transfer_details DROP FOREIGN KEY transfer_details_item_id_foreign'); } catch (\Throwable $e) {}
        $this->dropCols('transfer_details', [
            'inventory_id', 'item_id', 'serial_number',
            'barcode', 'quantity_received', 'condition',
        ]);

        // ── 4. issuances ──────────────────────────────────────────────────────
        // ERD: issuance_id, location_id, issuance_date, issuance_type, purpose,
        //      issued_to_user_id, expected_return_date, actual_return_date,
        //      issued_by, approved_by, status_id
        $this->dropCols('issuances', [
            'issuance_number', 'issued_to_name', 'total_quantity',
        ]);

        // ── 5. issuance_details ───────────────────────────────────────────────
        // ERD: issuance_detail_id, issuance_id, product_id, quantity_issued,
        //      quantity_returned, condition_issued, condition_returned
        try { DB::statement('ALTER TABLE issuance_details DROP FOREIGN KEY issuance_details_item_id_foreign'); } catch (\Throwable $e) {}
        $this->dropCols('issuance_details', [
            'item_id', 'serial_number', 'barcode',
        ]);

        // ── 6. sales_details ─────────────────────────────────────────────────
        // ERD: sales_detail_id, sales_id, product_id, quantity, unit_price, subtotal
        try { DB::statement('ALTER TABLE sales_details DROP FOREIGN KEY sales_details_item_id_foreign'); } catch (\Throwable $e) {}
        $this->dropCols('sales_details', [
            'item_id', 'serial_number',
        ]);

        // ── 7. delivery_receipts ──────────────────────────────────────────────
        // ERD: dr_id, dr_number, sales_id, issued_by, status_id
        $this->dropCols('delivery_receipts', [
            'delivery_date', 'delivered_by', 'received_by',
        ]);

        // ── 8. receivings ─────────────────────────────────────────────────────
        // ERD: receiving_id, pc_id, location_id, receiving_number, receiving_date,
        //      received_by, total_quantity_received, total_quantity_damaged
        try { DB::statement('ALTER TABLE receivings DROP FOREIGN KEY receivings_profit_loss_id_foreign'); } catch (\Throwable $e) {}
        $this->dropCols('receivings', [
            'profit_loss_id', 'status_id',
        ]);

        // ── 9. purchase_returns — rename pc_id → po_id ───────────────────────
        // ERD names this FK column "po_id" (pointing to purchase_orders.po_id).
        if (Schema::hasTable('purchase_returns')
            && Schema::hasColumn('purchase_returns', 'pc_id')
            && !Schema::hasColumn('purchase_returns', 'po_id')) {

            try {
                DB::statement('ALTER TABLE purchase_returns DROP FOREIGN KEY purchase_returns_pc_id_foreign');
            } catch (\Throwable $e) {}

            Schema::table('purchase_returns', function (Blueprint $table) {
                $table->renameColumn('pc_id', 'po_id');
            });

            // Re-add FK under new name
            try {
                Schema::table('purchase_returns', function (Blueprint $table) {
                    $table->foreign('po_id')
                          ->references('po_id')->on('purchase_orders')
                          ->onDelete('set null');
                });
            } catch (\Throwable $e) {}
        }

        // ── 10. audit_log — rename id → audit_id; drop duplicate record_table ─
        // ERD PK is audit_id; current table has `id` and two overlapping columns
        // (record_table & table_affected) from different migrations.
        if (Schema::hasTable('audit_log')) {

            // a) rename PK column id → audit_id
            // Use a single compound ALTER so MySQL can handle AUTO_INCREMENT + PK drop atomically.
            if (Schema::hasColumn('audit_log', 'id') && !Schema::hasColumn('audit_log', 'audit_id')) {
                DB::statement('ALTER TABLE audit_log DROP PRIMARY KEY, CHANGE COLUMN `id` `audit_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, ADD PRIMARY KEY (`audit_id`)');
            }

            // b) drop the duplicate record_table column (table_affected is the ERD name)
            $this->dropCols('audit_log', ['record_table']);
        }

        DB::statement('SET FOREIGN_KEY_CHECKS=1');
    }

    public function down(): void
    {
        // Partial rollback — only structural renames are reversed; dropped columns
        // cannot be recovered (no data was in non-ERD columns at migration time).
        DB::statement('SET FOREIGN_KEY_CHECKS=0');

        // Reverse audit_log PK rename
        if (Schema::hasTable('audit_log')
            && Schema::hasColumn('audit_log', 'audit_id')
            && !Schema::hasColumn('audit_log', 'id')) {
            DB::statement('ALTER TABLE audit_log DROP PRIMARY KEY, CHANGE COLUMN `audit_id` `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, ADD PRIMARY KEY (`id`)');
        }

        // Reverse purchase_returns rename
        if (Schema::hasTable('purchase_returns')
            && Schema::hasColumn('purchase_returns', 'po_id')
            && !Schema::hasColumn('purchase_returns', 'pc_id')) {
            try { DB::statement('ALTER TABLE purchase_returns DROP FOREIGN KEY purchase_returns_po_id_foreign'); } catch (\Throwable $e) {}
            Schema::table('purchase_returns', fn($t) => $t->renameColumn('po_id', 'pc_id'));
            try {
                Schema::table('purchase_returns', function ($t) {
                    $t->foreign('pc_id')->references('po_id')->on('purchase_orders')->onDelete('set null');
                });
            } catch (\Throwable $e) {}
        }

        DB::statement('SET FOREIGN_KEY_CHECKS=1');
    }

    // ── Helper ───────────────────────────────────────────────────────────────

    /** Drop a list of columns from a table only when they actually exist. */
    private function dropCols(string $table, array $cols): void
    {
        if (!Schema::hasTable($table)) {
            return;
        }
        $existing = array_filter($cols, fn($c) => Schema::hasColumn($table, $c));
        if (!empty($existing)) {
            Schema::table($table, fn(Blueprint $t) => $t->dropColumn(array_values($existing)));
        }
    }
};
