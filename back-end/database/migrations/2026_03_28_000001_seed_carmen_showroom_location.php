<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

/**
 * Adds Carmen Showroom as a destination option (Misamis Oriental).
 */
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

        $row = [
            'branch_id' => $cdoBranch->id,
            'location_name' => 'Carmen Showroom',
            'location_type' => 'showroom',
            'address' => 'Carmen, Misamis Oriental — AirKing showroom',
            'city' => 'Carmen',
            'province' => 'Misamis Oriental',
            'region' => 'Region X',
            'status_id' => $activeStatusId,
        ];

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

    public function down(): void
    {
        DB::table('locations')
            ->where('location_name', 'Carmen Showroom')
            ->delete();
    }
};
