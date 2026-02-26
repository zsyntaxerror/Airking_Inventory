<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('unit_lookup', function (Blueprint $table) {
            $table->id('unit_id');
            $table->string('unit_name', 50);
            $table->string('unit_abbreviation', 10);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('unit_lookup');
    }
};