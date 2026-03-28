<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

/**
 * Fix locations table: add missing ERD columns (location_name, location_type, address, etc.)
 * Fix users table: drop non-ERD branch_id column
 */
return new class extends Migration
{
    public function up(): void
    {
        // ── 1. Add missing ERD columns to locations ──────────────────────────
        Schema::table('locations', function (Blueprint $table) {
            if (!Schema::hasColumn('locations', 'location_name')) {
                $table->string('location_name', 255)->nullable()->after('id');
            }
            if (!Schema::hasColumn('locations', 'location_type')) {
                $table->string('location_type', 50)->nullable()->after('location_name');
            }
            if (!Schema::hasColumn('locations', 'address')) {
                $table->text('address')->nullable()->after('location_type');
            }
            if (!Schema::hasColumn('locations', 'city')) {
                $table->string('city', 100)->nullable()->after('address');
            }
            if (!Schema::hasColumn('locations', 'province')) {
                $table->string('province', 100)->nullable()->after('city');
            }
            if (!Schema::hasColumn('locations', 'region')) {
                $table->string('region', 100)->nullable()->after('province');
            }
            if (!Schema::hasColumn('locations', 'status_id')) {
                $table->unsignedBigInteger('status_id')->nullable()->after('region');
                $table->foreign('status_id')->references('status_id')->on('status_lookup')->onDelete('set null');
            }
        });

        // ── 2. Drop branch_id from users (not in ERD) ────────────────────────
        if (Schema::hasColumn('users', 'branch_id')) {
            DB::statement('SET FOREIGN_KEY_CHECKS=0');
            Schema::table('users', function (Blueprint $table) {
                // Drop FK if it exists
                try {
                    $table->dropForeign(['branch_id']);
                } catch (\Throwable $e) {
                    // FK may not exist if branches was already dropped with FK_CHECKS=0
                }
                $table->dropColumn('branch_id');
            });
            DB::statement('SET FOREIGN_KEY_CHECKS=1');
        }
    }

    public function down(): void
    {
        // Re-add branch_id to users
        if (!Schema::hasColumn('users', 'branch_id')) {
            Schema::table('users', function (Blueprint $table) {
                $table->unsignedBigInteger('branch_id')->nullable()->after('role_id');
            });
        }

        // Remove added location columns
        Schema::table('locations', function (Blueprint $table) {
            $cols = ['location_name', 'location_type', 'address', 'city', 'province', 'region'];
            foreach ($cols as $col) {
                if (Schema::hasColumn('locations', $col)) {
                    $table->dropColumn($col);
                }
            }
            if (Schema::hasColumn('locations', 'status_id')) {
                $table->dropForeign(['status_id']);
                $table->dropColumn('status_id');
            }
        });
    }
};
