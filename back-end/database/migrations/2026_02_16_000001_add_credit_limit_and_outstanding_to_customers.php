<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('customers', function (Blueprint $table) {
            if (!Schema::hasColumn('customers', 'credit_limit')) {
                $table->decimal('credit_limit', 12, 2)->nullable()->after('notes');
            }
            if (!Schema::hasColumn('customers', 'outstanding_balance')) {
                $table->decimal('outstanding_balance', 12, 2)->default(0)->after('credit_limit');
            }
        });
    }

    public function down(): void
    {
        Schema::table('customers', function (Blueprint $table) {
            if (Schema::hasColumn('customers', 'credit_limit')) {
                $table->dropColumn('credit_limit');
            }
            if (Schema::hasColumn('customers', 'outstanding_balance')) {
                $table->dropColumn('outstanding_balance');
            }
        });
    }
};
