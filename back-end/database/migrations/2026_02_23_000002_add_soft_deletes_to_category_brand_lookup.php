<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('category_lookup', function (Blueprint $table) {
            $table->softDeletes();
        });

        Schema::table('brand_lookup', function (Blueprint $table) {
            $table->softDeletes();
        });
    }

    public function down(): void
    {
        Schema::table('category_lookup', function (Blueprint $table) {
            $table->dropSoftDeletes();
        });

        Schema::table('brand_lookup', function (Blueprint $table) {
            $table->dropSoftDeletes();
        });
    }
};
