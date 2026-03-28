<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('customers', function (Blueprint $table) {
            $table->id('customer_id');
            $table->string('customer_type', 50); // individual, corporate
            $table->string('customer_name', 255);
            $table->string('contact_number', 20);
            $table->string('email', 100)->nullable();
            $table->string('company_name', 255)->nullable();
            $table->text('address');
            $table->string('city', 100)->nullable();
            $table->string('province', 100)->nullable();
            $table->string('tin', 50)->nullable();
            $table->text('notes')->nullable();
            $table->timestamps();
            $table->softDeletes();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('customers');
    }
};