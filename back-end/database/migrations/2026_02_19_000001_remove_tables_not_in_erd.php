<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

/**
 * Removes tables that were incorrectly added and are NOT in the user's ERD.
 * Aligns schema strictly with the ERD.
 *
 * Tables to REMOVE (not in ERD):
 * - product_lookup, im_inventory, item_terms, adjustment_type
 * - return_merchandise_authorization, inventory_return, inventory_return_detail
 * - qc_transfer_tracking, inventory_group, inventory_group_items, process_logs
 *
 * ERD has: tbl_transfer_tracking (not qc_transfer_tracking)
 * ERD has: adjustment_type as varchar column (not adjustment_type_id FK)
 */
return new class extends Migration
{
    public function up(): void
    {
        // Fix transfer_details: drop FK to im_inventory, repoint inventory_id to inventory table (ERD: tbl_Inventory)
        if (Schema::hasTable('transfer_details') && Schema::hasColumn('transfer_details', 'inventory_id')) {
            try {
                Schema::table('transfer_details', function (Blueprint $table) {
                    $table->dropForeign(['inventory_id']);
                });
            } catch (\Throwable $e) {
                // FK name may differ
            }
            DB::table('transfer_details')->whereNotNull('inventory_id')->update(['inventory_id' => null]);
            try {
                Schema::table('transfer_details', function (Blueprint $table) {
                    $table->foreign('inventory_id')->references('inventory_id')->on('inventory')->onDelete('set null');
                });
            } catch (\Throwable $e) {
                //
            }
        }

        // Fix adjustment_details: drop FK to im_inventory, repoint inventory_id to inventory table (ERD: tbl_Inventory)
        if (Schema::hasTable('adjustment_details') && Schema::hasColumn('adjustment_details', 'inventory_id')) {
            try {
                Schema::table('adjustment_details', function (Blueprint $table) {
                    $table->dropForeign(['inventory_id']);
                });
            } catch (\Throwable $e) {
                //
            }
            DB::table('adjustment_details')->whereNotNull('inventory_id')->update(['inventory_id' => null]);
            try {
                Schema::table('adjustment_details', function (Blueprint $table) {
                    $table->foreign('inventory_id')->references('inventory_id')->on('inventory')->onDelete('set null');
                });
            } catch (\Throwable $e) {
                //
            }
        }

        // Remove adjustment_type_id from adjustments (ERD uses adjustment_type varchar)
        if (Schema::hasTable('adjustments') && Schema::hasColumn('adjustments', 'adjustment_type_id')) {
            Schema::table('adjustments', function (Blueprint $table) {
                $table->dropForeign(['adjustment_type_id']);
            });
            Schema::table('adjustments', function (Blueprint $table) {
                $table->dropColumn('adjustment_type_id');
            });
        }

        // Drop tables NOT in ERD (order matters for FKs)
        Schema::dropIfExists('process_logs');
        Schema::dropIfExists('inventory_group_items');
        Schema::dropIfExists('inventory_group');
        Schema::dropIfExists('qc_transfer_tracking');
        Schema::dropIfExists('inventory_return_detail');
        Schema::dropIfExists('inventory_return');
        Schema::dropIfExists('return_merchandise_authorization');
        Schema::dropIfExists('item_terms');
        Schema::dropIfExists('im_inventory');
        Schema::dropIfExists('product_lookup');
        Schema::dropIfExists('adjustment_type');

        // Create tbl_transfer_tracking per ERD (tracking_id, transfer_id, location_id, status_note, recorded_at, recorded_by)
        if (!Schema::hasTable('tbl_transfer_tracking')) {
            Schema::create('tbl_transfer_tracking', function (Blueprint $table) {
                $table->id('tracking_id');
                $table->unsignedBigInteger('transfer_id')->nullable();
                $table->unsignedBigInteger('location_id')->nullable();
                $table->string('status_note', 255)->nullable();
                $table->dateTime('recorded_at')->nullable();
                $table->unsignedBigInteger('recorded_by')->nullable();
                $table->timestamps();

                $table->foreign('transfer_id')->references('transfer_id')->on('transfers')->onDelete('cascade');
                $table->foreign('location_id')->references('id')->on('locations')->onDelete('set null');
                $table->foreign('recorded_by')->references('user_id')->on('users')->onDelete('set null');
            });
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('tbl_transfer_tracking');

        // Re-create dropped tables would require the previous migration logic
        // For rollback, we only drop tbl_transfer_tracking
    }
};
