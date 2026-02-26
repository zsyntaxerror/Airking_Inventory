<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('status_lookup', function (Blueprint $table) {
            $table->id('status_id');
            $table->string('status_name', 50);
            $table->string('status_category', 50); // item, order, sales, user, etc.
            $table->timestamps();

            $table->unique(['status_name', 'status_category']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('status_lookup');
    }
};