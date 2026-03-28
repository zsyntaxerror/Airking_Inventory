<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Role;
use App\Models\StatusLookup;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class AdminUserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     * Creates an admin user you can use to log in.
     * Username: admin | Password: admin123
     */
    public function run(): void
    {
        $adminExists = User::where('username', 'admin')->orWhere('email', 'admin@airking.com')->exists();

        if (!$adminExists) {
            $adminRole = Role::where('role_name', 'admin')->first() ?? Role::first();
            $activeStatus = StatusLookup::where('status_category', 'user')->where('status_name', 'Active')->first()
                ?? StatusLookup::first();

            if (!$adminRole || !$activeStatus) {
                $this->command->error('Run DatabaseSeeder first to create roles and statuses.');
                return;
            }

            User::create([
                'first_name' => 'Admin',
                'last_name' => 'User',
                'username' => 'admin',
                'email' => 'admin@airking.com',
                'password_hash' => Hash::make('123456'),
                'phone' => '09171234567',
                'role_id' => $adminRole->role_id,
                'branch_id' => null,
                'status_id' => $activeStatus->status_id,
            ]);

            $this->command->info('Admin user created successfully!');
            $this->command->info('Username: admin');
            $this->command->info('Password: 123456');
        } else {
            $this->command->warn('Admin user already exists!');
        }
    }
}
