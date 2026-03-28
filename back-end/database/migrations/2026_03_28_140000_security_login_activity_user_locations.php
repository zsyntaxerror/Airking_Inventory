<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (! Schema::hasTable('login_activities')) {
            Schema::create('login_activities', function (Blueprint $table) {
                $table->id();
                $table->unsignedBigInteger('user_id')->nullable()->index();
                $table->string('username_attempt', 100)->nullable()->index();
                $table->boolean('success')->default(false);
                $table->string('failure_reason', 255)->nullable();
                $table->string('ip_address', 45)->nullable()->index();
                $table->text('user_agent')->nullable();
                $table->timestamp('created_at')->useCurrent();

                $table->foreign('user_id')->references('user_id')->on('users')->nullOnDelete();
            });
        }

        if (Schema::hasTable('users') && ! Schema::hasColumn('users', 'assigned_location_ids')) {
            Schema::table('users', function (Blueprint $table) {
                $table->json('assigned_location_ids')->nullable();
            });
        }
    }

    public function down(): void
    {
        if (Schema::hasTable('users') && Schema::hasColumn('users', 'assigned_location_ids')) {
            Schema::table('users', function (Blueprint $table) {
                $table->dropColumn('assigned_location_ids');
            });
        }

        Schema::dropIfExists('login_activities');
    }
};
