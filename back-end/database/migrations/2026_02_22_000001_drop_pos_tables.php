<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::dropIfExists('pos_delivery_receipt_items');
        Schema::dropIfExists('pos_delivery_receipts');
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Tables were removed; down() would require recreating them
    }
};
