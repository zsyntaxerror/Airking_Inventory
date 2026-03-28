<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('barcode_scans', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id')->nullable();
            $table->string('barcode', 191);
            $table->unsignedBigInteger('product_id');
            $table->string('scan_mode', 64);
            $table->timestamp('scanned_at')->nullable();
            $table->timestamps();

            $table->foreign('user_id')->references('user_id')->on('users')->nullOnDelete();
            $table->foreign('product_id')->references('product_id')->on('products')->cascadeOnDelete();
            $table->index(['user_id', 'scanned_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('barcode_scans');
    }
};
