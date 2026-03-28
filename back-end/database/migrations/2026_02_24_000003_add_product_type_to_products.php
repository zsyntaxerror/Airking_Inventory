<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * Extends the products table to support two distinct product classes:
 *
 *  - appliance  : Durable equipment tracked by model code, capacity rating, and
 *                 serial number (e.g. split-type aircons rated at 1HP, 2HP, 3HP, 5HP).
 *
 *  - consumable : Non-serialized bulk supplies managed by descriptive attributes
 *                 and packaging-based quantities (e.g. copper pipe sold per roll,
 *                 refrigerant per can, installation accessories per box).
 *
 * Columns added
 * ─────────────
 *  product_type      – discriminator: 'appliance' | 'consumable'  (default: 'appliance')
 *  capacity_rating   – horsepower / capacity spec for appliances   (e.g. '1HP', '2HP', '3HP', '5HP')
 *  description       – free-text descriptive attributes for consumables
 *  pieces_per_package– packaging quantity (how many pieces in one unit of sale for consumables)
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('products', function (Blueprint $table) {
            if (!Schema::hasColumn('products', 'product_type')) {
                // Stored as a plain varchar so it works across MySQL and SQLite
                // without needing to alter enum definitions in future migrations.
                $table->string('product_type', 20)
                      ->default('appliance')
                      ->after('product_code')
                      ->comment('appliance | consumable');
            }

            if (!Schema::hasColumn('products', 'capacity_rating')) {
                $table->string('capacity_rating', 20)
                      ->nullable()
                      ->after('product_type')
                      ->comment('HP / capacity rating for appliances: 1HP, 1.5HP, 2HP, 2.5HP, 3HP, 5HP');
            }

            if (!Schema::hasColumn('products', 'description')) {
                $table->text('description')
                      ->nullable()
                      ->after('capacity_rating')
                      ->comment('Descriptive attributes for consumable supplies');
            }

            if (!Schema::hasColumn('products', 'pieces_per_package')) {
                $table->unsignedInteger('pieces_per_package')
                      ->nullable()
                      ->after('description')
                      ->comment('Number of individual pieces in one package unit (consumables)');
            }
        });
    }

    public function down(): void
    {
        Schema::table('products', function (Blueprint $table) {
            $cols = array_filter(
                ['product_type', 'capacity_rating', 'description', 'pieces_per_package'],
                fn($c) => Schema::hasColumn('products', $c)
            );
            if (!empty($cols)) {
                $table->dropColumn(array_values($cols));
            }
        });
    }
};
