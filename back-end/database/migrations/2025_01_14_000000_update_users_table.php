<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn('name');
            $table->string('first_name')->after('id');
            $table->string('last_name')->after('first_name');
            $table->string('username')->unique()->after('last_name');
            $table->string('phone')->nullable()->after('email');
            $table->string('role')->default('System Admin')->after('phone');
            $table->string('branch')->nullable()->after('role');
            $table->enum('status', ['Active', 'Inactive'])->default('Active')->after('branch');
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('name')->after('id');
            $table->dropColumn(['first_name', 'last_name', 'username', 'phone', 'role', 'branch', 'status']);
        });
    }
};
