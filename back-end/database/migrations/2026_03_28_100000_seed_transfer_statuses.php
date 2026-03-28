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

        $rows = [
            ['status_name' => 'In Transit', 'status_category' => 'transfer'],
            ['status_name' => 'Received', 'status_category' => 'transfer'],
        ];

        foreach ($rows as $row) {
            $exists = DB::table('status_lookup')
                ->where('status_name', $row['status_name'])
                ->where('status_category', $row['status_category'])
                ->exists();
            if ($exists) {
                continue;
            }
            $insert = array_merge($row, ['created_at' => now(), 'updated_at' => now()]);
            if (Schema::hasColumn('status_lookup', 'is_active')) {
                $insert['is_active'] = true;
            }
            DB::table('status_lookup')->insert($insert);
        }
    }

    public function down(): void
    {
        if (!Schema::hasTable('status_lookup')) {
            return;
        }
        DB::table('status_lookup')
            ->where('status_category', 'transfer')
            ->whereIn('status_name', ['In Transit', 'Received'])
            ->delete();
    }
};
