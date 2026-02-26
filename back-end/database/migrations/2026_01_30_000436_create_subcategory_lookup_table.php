<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('subcategory_lookup', function (Blueprint $table) {
            $table->id('subcategory_id');
            $table->foreignId('category_id')->constrained('category_lookup', 'category_id')->onDelete('cascade');
            $table->string('subcategory_name', 100);
            $table->boolean('is_serialized')->default(false); // Track if items need serial numbers
            $table->timestamps();

            $table->unique(['category_id', 'subcategory_name']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('subcategory_lookup');
    }
};