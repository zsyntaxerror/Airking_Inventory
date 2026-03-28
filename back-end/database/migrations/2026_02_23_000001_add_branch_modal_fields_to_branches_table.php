<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('branches', function (Blueprint $table) {
            $table->string('region', 100)->nullable()->after('name');
            $table->string('city', 100)->nullable()->after('region');
            $table->string('contact_number', 50)->nullable()->after('address');
            $table->string('email', 255)->nullable()->after('contact_number');
            $table->date('opening_date')->nullable()->after('email');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('branches', function (Blueprint $table) {
            $table->dropColumn(['region', 'city', 'contact_number', 'email', 'opening_date']);
        });
    }
};
