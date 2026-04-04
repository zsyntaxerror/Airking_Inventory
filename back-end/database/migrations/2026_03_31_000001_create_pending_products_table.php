<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (Schema::hasTable('pending_products')) {
            return;
        }

        Schema::create('pending_products', function (Blueprint $table) {
            $table->bigIncrements('pending_product_id');
            $table->string('registration_kind', 32)->default('consumable');
            $table->string('barcode', 120);
            $table->string('supply_type', 120)->nullable();
            $table->string('packaging_unit', 64)->nullable();
            $table->unsignedInteger('quantity_per_package')->nullable();
            $table->unsignedBigInteger('category_id')->nullable();
            $table->unsignedBigInteger('brand_id')->nullable();
            $table->unsignedBigInteger('opening_location_id')->nullable();
            $table->unsignedInteger('opening_quantity')->default(1);
            $table->string('generated_name', 512)->nullable();
            $table->json('appliance_snapshot')->nullable();
            $table->string('status', 32)->default('pending');
            $table->decimal('unit_price', 12, 2)->nullable();
            $table->decimal('cost_price', 12, 2)->nullable();
            $table->unsignedBigInteger('created_by')->nullable();
            $table->unsignedBigInteger('approved_by')->nullable();
            $table->timestamp('approved_at')->nullable();
            $table->unsignedBigInteger('created_product_id')->nullable();
            $table->timestamps();

            $table->index(['status', 'created_at']);
            $table->index('barcode');
        });

        Schema::table('pending_products', function (Blueprint $table) {
            $table->foreign('category_id')->references('category_id')->on('category_lookup')->nullOnDelete();
            $table->foreign('brand_id')->references('brand_id')->on('brand_lookup')->nullOnDelete();
            $table->foreign('opening_location_id')->references('location_id')->on('locations')->nullOnDelete();
            $table->foreign('created_by')->references('user_id')->on('users')->nullOnDelete();
            $table->foreign('approved_by')->references('user_id')->on('users')->nullOnDelete();
            $table->foreign('created_product_id')->references('product_id')->on('products')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('pending_products');
    }
};
