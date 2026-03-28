<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        $cdoBranch = DB::table('branches')
            ->where('code', 'CDO')
            ->orWhere('name', 'Cagayan de Oro')
            ->first();

        if (!$cdoBranch) {
            return;
        }

        $activeStatusId = DB::table('status_lookup')
            ->whereRaw('LOWER(status_name) = ?', ['active'])
            ->value('status_id');

        $records = [
            [
                'branch_id' => $cdoBranch->id,
                'location_name' => 'CDO Main Warehouse',
                'location_type' => 'warehouse',
                'address' => 'Cagayan de Oro Warehouse Hub',
                'city' => 'Cagayan de Oro',
                'province' => 'Misamis Oriental',
                'region' => 'Region X',
                'status_id' => $activeStatusId,
            ],
            [
                'branch_id' => $cdoBranch->id,
                'location_name' => 'CDO Showroom',
                'location_type' => 'showroom',
                'address' => 'Cagayan de Oro Distribution Showroom',
                'city' => 'Cagayan de Oro',
                'province' => 'Misamis Oriental',
                'region' => 'Region X',
                'status_id' => $activeStatusId,
            ],
            [
                'branch_id' => $cdoBranch->id,
                'location_name' => 'Carmen Showroom',
                'location_type' => 'showroom',
                'address' => 'Carmen, Misamis Oriental — AirKing showroom',
                'city' => 'Carmen',
                'province' => 'Misamis Oriental',
                'region' => 'Region X',
                'status_id' => $activeStatusId,
            ],
        ];

        foreach ($records as $row) {
            $exists = DB::table('locations')
                ->where('branch_id', $row['branch_id'])
                ->where('location_name', $row['location_name'])
                ->first();

            if ($exists) {
                $pk = property_exists($exists, 'location_id') ? $exists->location_id : $exists->id;
                DB::table('locations')
                    ->where('location_id', $pk)
                    ->update(array_merge($row, ['updated_at' => now()]));
            } else {
                DB::table('locations')->insert(array_merge($row, [
                    'created_at' => now(),
                    'updated_at' => now(),
                ]));
            }
        }
    }

    public function down(): void
    {
        DB::table('locations')
            ->whereIn('location_name', ['CDO Main Warehouse', 'CDO Showroom', 'Carmen Showroom'])
            ->delete();
    }
};

