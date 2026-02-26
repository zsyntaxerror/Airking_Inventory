<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('items', function (Blueprint $table) {
            $table->string('brand', 100)->nullable()->after('category');
            $table->string('barcode', 50)->nullable()->after('code');
            $table->string('unit', 20)->default('Unit')->after('price');
            $table->string('supplier', 255)->nullable()->after('reorder_level');
            $table->string('status', 20)->default('Active')->after('supplier');
            $table->string('type', 30)->nullable()->after('status'); // Serialized / Non-Serialized
        });
    }

    public function down(): void
    {
        Schema::table('items', function (Blueprint $table) {
            $table->dropColumn(['brand', 'barcode', 'unit', 'supplier', 'status', 'type']);
        });
    }
};
