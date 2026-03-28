<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        // =============================================
        // PRODUCTS TABLE
        // =============================================
        if (!Schema::hasTable('products')) {
            Schema::create('products', function (Blueprint $table) {
                $table->id('product_id');
                $table->unsignedBigInteger('unit_id')->nullable();
                $table->unsignedBigInteger('category_id')->nullable();
                $table->unsignedBigInteger('subcategory_id')->nullable();
                $table->unsignedBigInteger('supplier_id')->nullable();
                $table->string('product_code', 50)->unique();
                $table->string('product_name', 255);
                $table->string('brand', 100)->nullable();
                $table->string('model', 100)->nullable();
                $table->decimal('unit_price', 10, 2)->default(0);
                $table->decimal('cost_price', 10, 2)->default(0);
                $table->integer('warranty_period_months')->default(0);
                $table->unsignedBigInteger('status_id')->nullable();
                $table->timestamps();

                $table->foreign('unit_id')->references('unit_id')->on('unit_lookup')->onDelete('set null');
                $table->foreign('category_id')->references('category_id')->on('category_lookup')->onDelete('set null');
                $table->foreign('subcategory_id')->references('subcategory_id')->on('subcategory_lookup')->onDelete('set null');
                $table->foreign('supplier_id')->references('id')->on('suppliers')->onDelete('set null');
                $table->foreign('status_id')->references('status_id')->on('status_lookup')->onDelete('set null');
            });
        }

        // =============================================
        // INVENTORY TABLE (ERD version)
        // =============================================
        if (!Schema::hasTable('inventory')) {
            Schema::create('inventory', function (Blueprint $table) {
                $table->id('inventory_id');
                $table->unsignedBigInteger('location_id')->nullable();
                $table->unsignedBigInteger('product_id')->nullable();
                $table->integer('quantity_on_hand')->default(0);
                $table->integer('available_quantity')->default(0);
                $table->integer('reorder_level')->default(0);
                $table->dateTime('last_updated')->nullable();
                $table->timestamps();

                $table->foreign('location_id')->references('id')->on('locations')->onDelete('set null');
                $table->foreign('product_id')->references('product_id')->on('products')->onDelete('set null');
            });
        }

        // =============================================
        // ITEMS TABLE (ERD version - links inventory, product, location)
        // =============================================
        if (!Schema::hasTable('items_master')) {
            Schema::create('items_master', function (Blueprint $table) {
                $table->id('item_id');
                $table->unsignedBigInteger('inventory_id')->nullable();
                $table->unsignedBigInteger('product_id')->nullable();
                $table->unsignedBigInteger('location_id')->nullable();
                $table->timestamps();

                $table->foreign('inventory_id')->references('inventory_id')->on('inventory')->onDelete('set null');
                $table->foreign('product_id')->references('product_id')->on('products')->onDelete('set null');
                $table->foreign('location_id')->references('id')->on('locations')->onDelete('set null');
            });
        }

        // =============================================
        // ITEM_SERIAL TABLE
        // =============================================
        if (!Schema::hasTable('item_serial')) {
            Schema::create('item_serial', function (Blueprint $table) {
                $table->id('serial_id');
                $table->unsignedBigInteger('item_id')->nullable();
                $table->string('serial_number', 100)->unique();
                $table->string('serial_type', 50)->nullable();
                $table->string('barcode', 100)->nullable();
                $table->unsignedBigInteger('status_id')->nullable();
                $table->string('condition', 50)->nullable();
                $table->decimal('purchase_cost', 10, 2)->default(0);
                $table->date('date_received')->nullable();
                $table->date('warranty_start_date')->nullable();
                $table->date('warranty_end_date')->nullable();
                $table->timestamps();

                $table->foreign('item_id')->references('item_id')->on('items_master')->onDelete('set null');
                $table->foreign('status_id')->references('status_id')->on('status_lookup')->onDelete('set null');
            });
        }

        // =============================================
        // ACTIVITY_LOG TABLE
        // =============================================
        if (!Schema::hasTable('activity_log')) {
            Schema::create('activity_log', function (Blueprint $table) {
                $table->id('activity_id');
                $table->unsignedBigInteger('user_id')->nullable();
                $table->string('activity_type', 100);
                $table->string('module', 100)->nullable();
                $table->text('description')->nullable();
                $table->dateTime('timestamp')->nullable();
                $table->timestamps();

                $table->foreign('user_id')->references('user_id')->on('users')->onDelete('set null');
            });
        }

        // =============================================
        // PURCHASE_ORDER TABLE
        // =============================================
        if (!Schema::hasTable('purchase_orders')) {
            Schema::create('purchase_orders', function (Blueprint $table) {
                $table->id('po_id');
                $table->unsignedBigInteger('supplier_id')->nullable();
                $table->unsignedBigInteger('location_id')->nullable();
                $table->string('po_number', 50)->unique();
                $table->date('order_date')->nullable();
                $table->date('expected_delivery_date')->nullable();
                $table->decimal('total_amount', 12, 2)->default(0);
                $table->decimal('grand_total', 12, 2)->default(0);
                $table->unsignedBigInteger('status_id')->nullable();
                $table->unsignedBigInteger('created_by')->nullable();
                $table->unsignedBigInteger('approved_by')->nullable();
                $table->timestamps();

                $table->foreign('supplier_id')->references('id')->on('suppliers')->onDelete('set null');
                $table->foreign('location_id')->references('id')->on('locations')->onDelete('set null');
                $table->foreign('status_id')->references('status_id')->on('status_lookup')->onDelete('set null');
                $table->foreign('created_by')->references('user_id')->on('users')->onDelete('set null');
                $table->foreign('approved_by')->references('user_id')->on('users')->onDelete('set null');
            });
        }

        // =============================================
        // PURCHASE_ORDER_DETAIL TABLE
        // =============================================
        if (!Schema::hasTable('purchase_order_details')) {
            Schema::create('purchase_order_details', function (Blueprint $table) {
                $table->id('po_detail_id');
                $table->unsignedBigInteger('po_id')->nullable();
                $table->unsignedBigInteger('product_id')->nullable();
                $table->integer('quantity_ordered')->default(0);
                $table->decimal('unit_price', 10, 2)->default(0);
                $table->decimal('subtotal', 12, 2)->default(0);
                $table->timestamps();

                $table->foreign('po_id')->references('po_id')->on('purchase_orders')->onDelete('cascade');
                $table->foreign('product_id')->references('product_id')->on('products')->onDelete('set null');
            });
        }

        // =============================================
        // RECEIVING TABLE
        // =============================================
        if (!Schema::hasTable('receivings')) {
            Schema::create('receivings', function (Blueprint $table) {
                $table->id('receiving_id');
                $table->unsignedBigInteger('purchase_order_id')->nullable();
                $table->unsignedBigInteger('supplier_id')->nullable();
                $table->unsignedBigInteger('location_id')->nullable();
                $table->string('receiving_number', 50)->unique();
                $table->date('receiving_date')->nullable();
                $table->unsignedBigInteger('received_by')->nullable();
                $table->integer('total_quantity_received')->default(0);
                $table->integer('total_quantity_damaged')->default(0);
                $table->unsignedBigInteger('status_id')->nullable();
                $table->timestamps();

                $table->foreign('purchase_order_id')->references('po_id')->on('purchase_orders')->onDelete('set null');
                $table->foreign('supplier_id')->references('id')->on('suppliers')->onDelete('set null');
                $table->foreign('location_id')->references('id')->on('locations')->onDelete('set null');
                $table->foreign('received_by')->references('user_id')->on('users')->onDelete('set null');
                $table->foreign('status_id')->references('status_id')->on('status_lookup')->onDelete('set null');
            });
        }

        // =============================================
        // RECEIVING_DETAIL TABLE
        // =============================================
        if (!Schema::hasTable('receiving_details')) {
            Schema::create('receiving_details', function (Blueprint $table) {
                $table->id('receiving_detail_id');
                $table->unsignedBigInteger('receiving_id')->nullable();
                $table->unsignedBigInteger('po_detail_id')->nullable();
                $table->unsignedBigInteger('product_id')->nullable();
                $table->string('serial_number', 100)->nullable();
                $table->string('barcode', 100)->nullable();
                $table->integer('quantity_received')->default(0);
                $table->integer('quantity_damaged')->default(0);
                $table->timestamps();

                $table->foreign('receiving_id')->references('receiving_id')->on('receivings')->onDelete('cascade');
                $table->foreign('po_detail_id')->references('po_detail_id')->on('purchase_order_details')->onDelete('set null');
                $table->foreign('product_id')->references('product_id')->on('products')->onDelete('set null');
            });
        }

        // =============================================
        // SALES TABLE
        // =============================================
        if (!Schema::hasTable('sales')) {
            Schema::create('sales', function (Blueprint $table) {
                $table->id('sales_id');
                $table->unsignedBigInteger('customer_id')->nullable();
                $table->unsignedBigInteger('location_id')->nullable();
                $table->string('invoice_number', 50)->unique();
                $table->date('sale_date')->nullable();
                $table->decimal('total_amount', 12, 2)->default(0);
                $table->string('payment_method', 50)->nullable();
                $table->unsignedBigInteger('payment_status_id')->nullable();
                $table->decimal('amount_paid', 12, 2)->default(0);
                $table->decimal('balance_due', 12, 2)->default(0);
                $table->unsignedBigInteger('sold_by')->nullable();
                $table->timestamps();

                $table->foreign('customer_id')->references('id')->on('customers')->onDelete('set null');
                $table->foreign('location_id')->references('id')->on('locations')->onDelete('set null');
                $table->foreign('payment_status_id')->references('status_id')->on('status_lookup')->onDelete('set null');
                $table->foreign('sold_by')->references('user_id')->on('users')->onDelete('set null');
            });
        }

        // =============================================
        // SALES_DETAIL TABLE
        // =============================================
        if (!Schema::hasTable('sales_details')) {
            Schema::create('sales_details', function (Blueprint $table) {
                $table->id('sales_detail_id');
                $table->unsignedBigInteger('sales_id')->nullable();
                $table->unsignedBigInteger('product_id')->nullable();
                $table->unsignedBigInteger('item_id')->nullable();
                $table->string('serial_number', 100)->nullable();
                $table->integer('quantity')->default(0);
                $table->decimal('unit_price', 10, 2)->default(0);
                $table->decimal('subtotal', 12, 2)->default(0);
                $table->timestamps();

                $table->foreign('sales_id')->references('sales_id')->on('sales')->onDelete('cascade');
                $table->foreign('product_id')->references('product_id')->on('products')->onDelete('set null');
                $table->foreign('item_id')->references('item_id')->on('items_master')->onDelete('set null');
            });
        }

        // =============================================
        // DELIVERY_RECEIPT TABLE
        // =============================================
        if (!Schema::hasTable('delivery_receipts')) {
            Schema::create('delivery_receipts', function (Blueprint $table) {
                $table->id('dr_id');
                $table->string('dr_number', 50)->unique();
                $table->unsignedBigInteger('sales_id')->nullable();
                $table->unsignedBigInteger('issued_by')->nullable();
                $table->unsignedBigInteger('status_id')->nullable();
                $table->timestamps();

                $table->foreign('sales_id')->references('sales_id')->on('sales')->onDelete('set null');
                $table->foreign('issued_by')->references('user_id')->on('users')->onDelete('set null');
                $table->foreign('status_id')->references('status_id')->on('status_lookup')->onDelete('set null');
            });
        }

        // =============================================
        // TRANSFER TABLE
        // =============================================
        if (!Schema::hasTable('transfers')) {
            Schema::create('transfers', function (Blueprint $table) {
                $table->id('transfer_id');
                $table->unsignedBigInteger('from_location_id')->nullable();
                $table->unsignedBigInteger('to_location_id')->nullable();
                $table->string('transfer_number', 50)->unique();
                $table->date('transfer_date')->nullable();
                $table->integer('total_quantity_transferred')->default(0);
                $table->integer('total_quantity_received')->default(0);
                $table->unsignedBigInteger('requested_by')->nullable();
                $table->unsignedBigInteger('approved_by')->nullable();
                $table->unsignedBigInteger('received_by')->nullable();
                $table->unsignedBigInteger('status_id')->nullable();
                $table->timestamps();

                $table->foreign('from_location_id')->references('id')->on('locations')->onDelete('set null');
                $table->foreign('to_location_id')->references('id')->on('locations')->onDelete('set null');
                $table->foreign('requested_by')->references('user_id')->on('users')->onDelete('set null');
                $table->foreign('approved_by')->references('user_id')->on('users')->onDelete('set null');
                $table->foreign('received_by')->references('user_id')->on('users')->onDelete('set null');
                $table->foreign('status_id')->references('status_id')->on('status_lookup')->onDelete('set null');
            });
        }

        // =============================================
        // TRANSFER_DETAIL TABLE
        // =============================================
        if (!Schema::hasTable('transfer_details')) {
            Schema::create('transfer_details', function (Blueprint $table) {
                $table->id('transfer_detail_id');
                $table->unsignedBigInteger('transfer_id')->nullable();
                $table->unsignedBigInteger('product_id')->nullable();
                $table->unsignedBigInteger('item_id')->nullable();
                $table->string('serial_number', 100)->nullable();
                $table->string('barcode', 100)->nullable();
                $table->integer('quantity_transferred')->default(0);
                $table->integer('quantity_received')->default(0);
                $table->string('condition', 50)->nullable();
                $table->timestamps();

                $table->foreign('transfer_id')->references('transfer_id')->on('transfers')->onDelete('cascade');
                $table->foreign('product_id')->references('product_id')->on('products')->onDelete('set null');
                $table->foreign('item_id')->references('item_id')->on('items_master')->onDelete('set null');
            });
        }

        // =============================================
        // ISSUANCE TABLE
        // =============================================
        if (!Schema::hasTable('issuances')) {
            Schema::create('issuances', function (Blueprint $table) {
                $table->id('issuance_id');
                $table->unsignedBigInteger('location_id')->nullable();
                $table->string('issuance_number', 50)->unique();
                $table->date('issuance_date')->nullable();
                $table->string('issuance_type', 50)->nullable();
                $table->text('purpose')->nullable();
                $table->unsignedBigInteger('issued_to_user_id')->nullable();
                $table->string('issued_to_name', 255)->nullable();
                $table->integer('total_quantity')->default(0);
                $table->date('expected_return_date')->nullable();
                $table->date('actual_return_date')->nullable();
                $table->unsignedBigInteger('issued_by')->nullable();
                $table->unsignedBigInteger('approved_by')->nullable();
                $table->unsignedBigInteger('status_id')->nullable();
                $table->timestamps();

                $table->foreign('location_id')->references('id')->on('locations')->onDelete('set null');
                $table->foreign('issued_to_user_id')->references('user_id')->on('users')->onDelete('set null');
                $table->foreign('issued_by')->references('user_id')->on('users')->onDelete('set null');
                $table->foreign('approved_by')->references('user_id')->on('users')->onDelete('set null');
                $table->foreign('status_id')->references('status_id')->on('status_lookup')->onDelete('set null');
            });
        }

        // =============================================
        // ISSUANCE_DETAIL TABLE
        // =============================================
        if (!Schema::hasTable('issuance_details')) {
            Schema::create('issuance_details', function (Blueprint $table) {
                $table->id('issuance_detail_id');
                $table->unsignedBigInteger('issuance_id')->nullable();
                $table->unsignedBigInteger('product_id')->nullable();
                $table->unsignedBigInteger('item_id')->nullable();
                $table->string('serial_number', 100)->nullable();
                $table->string('barcode', 100)->nullable();
                $table->integer('quantity_issued')->default(0);
                $table->integer('quantity_returned')->default(0);
                $table->string('condition_issued', 50)->nullable();
                $table->string('condition_returned', 50)->nullable();
                $table->timestamps();

                $table->foreign('issuance_id')->references('issuance_id')->on('issuances')->onDelete('cascade');
                $table->foreign('product_id')->references('product_id')->on('products')->onDelete('set null');
                $table->foreign('item_id')->references('item_id')->on('items_master')->onDelete('set null');
            });
        }

        // =============================================
        // ADJUSTMENT TABLE
        // =============================================
        if (!Schema::hasTable('adjustments')) {
            Schema::create('adjustments', function (Blueprint $table) {
                $table->id('adjustment_id');
                $table->unsignedBigInteger('location_id')->nullable();
                $table->string('adjustment_number', 50)->unique();
                $table->date('adjustment_date')->nullable();
                $table->string('adjustment_type', 50)->nullable();
                $table->integer('total_variance_positive')->default(0);
                $table->integer('total_variance_negative')->default(0);
                $table->unsignedBigInteger('adjusted_by')->nullable();
                $table->unsignedBigInteger('approved_by')->nullable();
                $table->unsignedBigInteger('status_id')->nullable();
                $table->timestamps();

                $table->foreign('location_id')->references('id')->on('locations')->onDelete('set null');
                $table->foreign('adjusted_by')->references('user_id')->on('users')->onDelete('set null');
                $table->foreign('approved_by')->references('user_id')->on('users')->onDelete('set null');
                $table->foreign('status_id')->references('status_id')->on('status_lookup')->onDelete('set null');
            });
        }

        // =============================================
        // ADJUSTMENT_DETAIL TABLE
        // =============================================
        if (!Schema::hasTable('adjustment_details')) {
            Schema::create('adjustment_details', function (Blueprint $table) {
                $table->id('adjustment_detail_id');
                $table->unsignedBigInteger('adjustment_id')->nullable();
                $table->unsignedBigInteger('product_id')->nullable();
                $table->unsignedBigInteger('item_id')->nullable();
                $table->string('serial_number', 100)->nullable();
                $table->integer('system_quantity')->default(0);
                $table->integer('actual_quantity')->default(0);
                $table->integer('variance_quantity')->default(0);
                $table->timestamps();

                $table->foreign('adjustment_id')->references('adjustment_id')->on('adjustments')->onDelete('cascade');
                $table->foreign('product_id')->references('product_id')->on('products')->onDelete('set null');
                $table->foreign('item_id')->references('item_id')->on('items_master')->onDelete('set null');
            });
        }

        // =============================================
        // PROFIT_LOSS TABLE
        // =============================================
        if (!Schema::hasTable('profit_loss')) {
            Schema::create('profit_loss', function (Blueprint $table) {
                $table->id('profit_loss_id');
                $table->unsignedBigInteger('location_id')->nullable();
                $table->unsignedBigInteger('product_id')->nullable();
                $table->unsignedBigInteger('item_id')->nullable();
                $table->string('reference_type', 50)->nullable();
                $table->integer('reference_id')->nullable();
                $table->date('transaction_date')->nullable();
                $table->date('incident_date')->nullable();
                $table->string('serial_number', 100)->nullable();
                $table->integer('quantity_lost')->default(0);
                $table->decimal('unit_cost', 10, 2)->default(0);
                $table->decimal('total_loss_amount', 12, 2)->default(0);
                $table->unsignedBigInteger('recorded_by')->nullable();
                $table->unsignedBigInteger('approved_by')->nullable();
                $table->unsignedBigInteger('status_id')->nullable();
                $table->timestamps();

                $table->foreign('location_id')->references('id')->on('locations')->onDelete('set null');
                $table->foreign('product_id')->references('product_id')->on('products')->onDelete('set null');
                $table->foreign('item_id')->references('item_id')->on('items_master')->onDelete('set null');
                $table->foreign('recorded_by')->references('user_id')->on('users')->onDelete('set null');
                $table->foreign('approved_by')->references('user_id')->on('users')->onDelete('set null');
                $table->foreign('status_id')->references('status_id')->on('status_lookup')->onDelete('set null');
            });
        }

        // =============================================
        // RESTOCK_RECOMMENDATION TABLE
        // =============================================
        if (!Schema::hasTable('restock_recommendations')) {
            Schema::create('restock_recommendations', function (Blueprint $table) {
                $table->id('recommendation_id');
                $table->unsignedBigInteger('item_id')->nullable();
                $table->unsignedBigInteger('location_id')->nullable();
                $table->decimal('current_stock', 10, 2)->default(0);
                $table->decimal('reorder_level', 10, 2)->default(0);
                $table->decimal('recommended_quantity', 10, 2)->default(0);
                $table->string('reason', 255)->nullable();
                $table->unsignedBigInteger('status_id')->nullable();
                $table->timestamps();

                $table->foreign('item_id')->references('item_id')->on('items_master')->onDelete('set null');
                $table->foreign('location_id')->references('id')->on('locations')->onDelete('set null');
                $table->foreign('status_id')->references('status_id')->on('status_lookup')->onDelete('set null');
            });
        }

        // =============================================
        // MATERIAL_MOVEMENT_LEDGER TABLE
        // =============================================
        if (!Schema::hasTable('material_movement_ledger')) {
            Schema::create('material_movement_ledger', function (Blueprint $table) {
                $table->id('movement_id');
                $table->unsignedBigInteger('transaction_type')->nullable();
                $table->dateTime('transaction_date')->nullable();
                $table->unsignedBigInteger('from_location_id')->nullable();
                $table->unsignedBigInteger('to_location_id')->nullable();
                $table->unsignedBigInteger('product_id')->nullable();
                $table->unsignedBigInteger('item_id')->nullable();
                $table->string('barcode', 100)->nullable();
                $table->decimal('quantity', 10, 2)->default(0);
                $table->decimal('unit_cost', 10, 2)->default(0);
                $table->decimal('total_amount', 12, 2)->default(0);
                $table->string('reference_type', 50)->nullable();
                $table->integer('reference_id')->nullable();
                $table->string('reference_number', 50)->nullable();
                $table->unsignedBigInteger('transacted_by')->nullable();
                $table->unsignedBigInteger('status_id')->nullable();
                $table->timestamps();

                $table->foreign('transaction_type')->references('transaction_type_id')->on('transaction_type_lookup')->onDelete('set null');
                $table->foreign('from_location_id')->references('id')->on('locations')->onDelete('set null');
                $table->foreign('to_location_id')->references('id')->on('locations')->onDelete('set null');
                $table->foreign('product_id')->references('product_id')->on('products')->onDelete('set null');
                $table->foreign('item_id')->references('item_id')->on('items_master')->onDelete('set null');
                $table->foreign('transacted_by')->references('user_id')->on('users')->onDelete('set null');
                $table->foreign('status_id')->references('status_id')->on('status_lookup')->onDelete('set null');
            });
        }
    }

    public function down()
    {
        // Drop in reverse dependency order
        Schema::dropIfExists('material_movement_ledger');
        Schema::dropIfExists('restock_recommendations');
        Schema::dropIfExists('profit_loss');
        Schema::dropIfExists('adjustment_details');
        Schema::dropIfExists('adjustments');
        Schema::dropIfExists('issuance_details');
        Schema::dropIfExists('issuances');
        Schema::dropIfExists('transfer_details');
        Schema::dropIfExists('transfers');
        Schema::dropIfExists('delivery_receipts');
        Schema::dropIfExists('sales_details');
        Schema::dropIfExists('sales');
        Schema::dropIfExists('receiving_details');
        Schema::dropIfExists('receivings');
        Schema::dropIfExists('purchase_order_details');
        Schema::dropIfExists('purchase_orders');
        Schema::dropIfExists('activity_log');
        Schema::dropIfExists('item_serial');
        Schema::dropIfExists('items_master');
        Schema::dropIfExists('inventory');
        Schema::dropIfExists('products');
    }
};
