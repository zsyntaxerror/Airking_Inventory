<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (!Schema::hasColumn('locations', 'branch_id')) {
            Schema::table('locations', function (Blueprint $table) {
                $table->unsignedBigInteger('branch_id')->nullable()->after('id');
                $table->foreign('branch_id')->references('id')->on('branches')->onDelete('cascade');
                $table->index(['branch_id', 'location_type'], 'locations_branch_type_idx');
            });
        }

        // Backfill existing rows using city->branch mapping when possible.
        $rows = DB::table('locations')->select('id', 'city', 'branch_id')->get();
        foreach ($rows as $row) {
            if ($row->branch_id) {
                continue;
            }

            $branchId = DB::table('branches')
                ->where('city', $row->city)
                ->value('id');

            if (!$branchId && $row->city) {
                $branchId = DB::table('branches')
                    ->where('name', 'like', '%' . $row->city . '%')
                    ->value('id');
            }

            if ($branchId) {
                DB::table('locations')->where('id', $row->id)->update(['branch_id' => $branchId]);
            }
        }
    }

    public function down(): void
    {
        if (Schema::hasColumn('locations', 'branch_id')) {
            Schema::table('locations', function (Blueprint $table) {
                try {
                    $table->dropForeign(['branch_id']);
                } catch (\Throwable $e) {
                    // no-op
                }
                try {
                    $table->dropIndex('locations_branch_type_idx');
                } catch (\Throwable $e) {
                    // no-op
                }
                $table->dropColumn('branch_id');
            });
        }
    }
};

