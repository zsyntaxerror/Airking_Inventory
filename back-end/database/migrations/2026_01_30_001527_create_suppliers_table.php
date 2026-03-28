<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('suppliers', function (Blueprint $table) {
            $table->id('supplier_id');
            $table->string('supplier_name', 255);
            $table->string('contact_person', 255)->nullable();
            $table->string('contact_number', 20);
            $table->string('email', 100)->nullable();
            $table->text('address');
            $table->string('tin', 50)->nullable();
            $table->foreignId('status_id')->constrained('status_lookup', 'status_id');
            $table->text('notes')->nullable();
            $table->timestamps();
            $table->softDeletes();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('suppliers');
    }
};