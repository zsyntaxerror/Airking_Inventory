<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * Ensures tables NOT in the ERD are removed.
 * Uses dropIfExists - safe to run even if tables already dropped.
 */
return new class extends Migration
{
    public function up(): void
    {
        // Drop tables NOT in user's ERD (idempotent - no error if already gone)
        Schema::dropIfExists('process_logs');
        Schema::dropIfExists('inventory_group_items');
        Schema::dropIfExists('inventory_group');
        Schema::dropIfExists('qc_transfer_tracking');
        Schema::dropIfExists('inventory_return_detail');
        Schema::dropIfExists('inventory_return');
        Schema::dropIfExists('return_merchandise_authorization');
        Schema::dropIfExists('item_terms');
        Schema::dropIfExists('im_inventory');
        Schema::dropIfExists('product_lookup');
        Schema::dropIfExists('adjustment_type');
    }

    public function down(): void
    {
        // No-op - we don't re-create removed tables
    }
};
