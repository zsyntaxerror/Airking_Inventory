<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('locations', function (Blueprint $table) {
            $table->id('location_id');
            $table->string('location_type', 50); // warehouse, showroom, service_center
            $table->foreignId('branch_id')->constrained('branches', 'id')->onDelete('cascade');
            $table->string('location_name', 255);
            $table->text('address');
            $table->string('city', 100);
            $table->string('province', 100);
            $table->string('region', 100);
            $table->foreignId('status_id')->constrained('status_lookup', 'status_id');
            $table->timestamps();
            $table->softDeletes();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('locations');
    }
};