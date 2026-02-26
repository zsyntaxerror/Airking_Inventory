<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Role;
use App\Models\Branch;

/**
 * Adds roles (positions) and branches to the database.
 * Run on existing DB: php artisan db:seed --class=RolesAndBranchesSeeder
 */
class RolesAndBranchesSeeder extends Seeder
{
    public function run(): void
    {
        $roles = [
            ['role_name' => 'admin', 'description' => 'System Administrator'],
            ['role_name' => 'inventory_analyst', 'description' => 'Inventory Analyst'],
            ['role_name' => 'branch_manager', 'description' => 'Branch Manager'],
            ['role_name' => 'warehouse_personnel', 'description' => 'Warehouse Personnel'],
            ['role_name' => 'auditor', 'description' => 'Auditor'],
        ];

        foreach ($roles as $role) {
            Role::firstOrCreate(
                ['role_name' => $role['role_name']],
                ['description' => $role['description']]
            );
        }
        $this->command->info('Roles synced.');

        $branches = [
            ['code' => 'CDO', 'name' => 'Cagayan de Oro', 'capacity' => 6000],
            ['code' => 'DVO', 'name' => 'Davao City', 'capacity' => 10000],
            ['code' => 'VAL', 'name' => 'Valencia', 'capacity' => 2500],
            ['code' => 'BUT', 'name' => 'Butuan', 'capacity' => 4500],
            ['code' => 'ILI', 'name' => 'Iligan', 'capacity' => 3000],
            ['code' => 'PAG', 'name' => 'Pagadian', 'capacity' => 4000],
            ['code' => 'ZAM', 'name' => 'Zamboanga', 'capacity' => 5000],
        ];

        foreach ($branches as $branch) {
            Branch::firstOrCreate(
                ['code' => $branch['code']],
                [
                    'name' => $branch['name'],
                    'capacity' => $branch['capacity'],
                    'is_active' => true,
                ]
            );
        }
        $this->command->info('Branches synced.');
    }
}
