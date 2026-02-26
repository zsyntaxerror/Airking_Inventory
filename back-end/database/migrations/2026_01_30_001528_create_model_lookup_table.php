<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('model_lookup', function (Blueprint $table) {
            $table->id('model_id');
            $table->foreignId('brand_id')->constrained('brand_lookup', 'brand_id')->onDelete('cascade');
            $table->foreignId('subcategory_id')->constrained('subcategory_lookup', 'subcategory_id')->onDelete('cascade');
            $table->string('model_name', 100);
            $table->string('model_number', 50)->nullable();
            $table->text('specifications')->nullable();
            $table->timestamps();

            $table->unique(['brand_id', 'model_name']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('model_lookup');
    }
};