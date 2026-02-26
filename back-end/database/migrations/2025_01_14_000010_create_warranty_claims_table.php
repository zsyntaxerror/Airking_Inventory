<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('warranty_claims', function (Blueprint $table) {
            $table->id();
            $table->string('warranty_code')->unique();
            $table->string('customer_name');
            $table->string('customer_contact')->nullable();
            $table->string('item_name');
            $table->string('serial_number');
            $table->text('issue');
            $table->string('branch')->nullable();
            $table->enum('priority', ['LOW', 'MEDIUM', 'HIGH', 'CRITICAL'])->default('MEDIUM');
            $table->enum('status', ['Open', 'In-Repair', 'Completed', 'Closed'])->default('Open');
            $table->string('technician')->nullable();
            $table->date('estimated_date')->nullable();
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('warranty_claims');
    }
};
