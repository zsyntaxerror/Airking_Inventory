<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (!Schema::hasTable('status_lookup')) {
            return;
        }
        $now = now();
        foreach (
            [
                ['status_name' => 'Rejected', 'status_category' => 'purchase_order'],
                ['status_name' => 'Partially Fulfilled', 'status_category' => 'purchase_order'],
                ['status_name' => 'Fulfilled', 'status_category' => 'purchase_order'],
            ] as $row
        ) {
            $exists = DB::table('status_lookup')
                ->where('status_category', $row['status_category'])
                ->where('status_name', $row['status_name'])
                ->exists();
            if (!$exists) {
                DB::table('status_lookup')->insert([
                    'status_name'     => $row['status_name'],
                    'status_category' => $row['status_category'],
                    'created_at'      => $now,
                    'updated_at'      => $now,
                ]);
            }
        }
    }

    public function down(): void
    {
        if (!Schema::hasTable('status_lookup')) {
            return;
        }
        DB::table('status_lookup')
            ->where('status_category', 'purchase_order')
            ->whereIn('status_name', ['Rejected', 'Partially Fulfilled', 'Fulfilled'])
            ->delete();
    }
};
