<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        // Insert default role if it doesn't exist
        $adminRoleId = DB::table('roles')->where('role_name', 'admin')->value('role_id');
        if (!$adminRoleId) {
            $adminRoleId = DB::table('roles')->insertGetId([
                'role_name' => 'admin',
                'description' => 'System Administrator',
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }

        // Insert default status if it doesn't exist
        $activeStatusId = DB::table('status_lookup')->where('status_name', 'Active')->value('status_id');
        if (!$activeStatusId) {
            $activeStatusId = DB::table('status_lookup')->insertGetId([
                'status_name' => 'Active',
                'status_category' => 'user',
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }

        // Rename columns
        Schema::table('users', function (Blueprint $table) {
            $table->renameColumn('id', 'user_id');
            $table->renameColumn('password', 'password_hash');
        });

        // Drop old string columns
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['role', 'branch', 'status']);
        });

        // Add new foreign key columns
        Schema::table('users', function (Blueprint $table) use ($adminRoleId, $activeStatusId) {
            $table->unsignedBigInteger('role_id')->default($adminRoleId)->after('phone');
            $table->unsignedBigInteger('branch_id')->nullable()->after('role_id');
            $table->unsignedBigInteger('status_id')->default($activeStatusId)->after('branch_id');
        });

        // Add foreign key constraints
        Schema::table('users', function (Blueprint $table) {
            $table->foreign('role_id')->references('role_id')->on('roles')->onDelete('restrict');
            $table->foreign('branch_id')->references('id')->on('branches')->onDelete('set null');
            $table->foreign('status_id')->references('status_id')->on('status_lookup')->onDelete('restrict');
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropForeign(['role_id']);
            $table->dropForeign(['branch_id']);
            $table->dropForeign(['status_id']);
            $table->dropColumn(['role_id', 'branch_id', 'status_id']);
        });

        Schema::table('users', function (Blueprint $table) {
            $table->string('role')->default('System Admin')->after('phone');
            $table->string('branch')->nullable()->after('role');
            $table->enum('status', ['Active', 'Inactive'])->default('Active')->after('branch');
        });

        Schema::table('users', function (Blueprint $table) {
            $table->renameColumn('password_hash', 'password');
            $table->renameColumn('user_id', 'id');
        });
    }
};
