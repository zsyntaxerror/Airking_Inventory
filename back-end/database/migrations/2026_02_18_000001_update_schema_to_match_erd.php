<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * Migration to align schema with the updated ERD for the
 * Web-Based Adaptive Barcode Auditing and Inventory Management System.
 */
return new class extends Migration
{
    public function up(): void
    {
        // Add is_active to status_lookup (ERD: status)
        if (Schema::hasTable('status_lookup') && !Schema::hasColumn('status_lookup', 'is_active')) {
            Schema::table('status_lookup', function (Blueprint $table) {
                $table->boolean('is_active')->default(true)->after('status_category');
            });
        }

        // Create product_lookup (ERD: product specifications lookup)
        if (!Schema::hasTable('product_lookup')) {
            Schema::create('product_lookup', function (Blueprint $table) {
                $table->id();
                $table->unsignedBigInteger('category_id')->nullable();
                $table->unsignedBigInteger('subcategory_id')->nullable();
                $table->unsignedBigInteger('brand_id')->nullable();
                $table->string('model_name', 255)->nullable();
                $table->string('model_no', 100)->nullable();
                $table->string('variant', 100)->nullable();
                $table->string('wattage_capacity', 50)->nullable();
                $table->string('kilos_h', 50)->nullable();
                $table->boolean('active')->default(true);
                $table->timestamps();

                $table->foreign('category_id')->references('category_id')->on('category_lookup')->onDelete('set null');
                $table->foreign('subcategory_id')->references('subcategory_id')->on('subcategory_lookup')->onDelete('set null');
                $table->foreign('brand_id')->references('brand_id')->on('brand_lookup')->onDelete('set null');
            });
        }

        // Update products table to match ERD (add brand_id, barcode, selling_price, currently_stored_quantity)
        if (Schema::hasTable('products')) {
            Schema::table('products', function (Blueprint $table) {
                if (!Schema::hasColumn('products', 'brand_id')) {
                    $table->unsignedBigInteger('brand_id')->nullable()->after('subcategory_id');
                }
                if (!Schema::hasColumn('products', 'barcode')) {
                    $table->string('barcode', 100)->nullable()->after('brand_id');
                }
                if (!Schema::hasColumn('products', 'brand_name')) {
                    $table->string('brand_name', 100)->nullable()->after('brand_id');
                }
                if (!Schema::hasColumn('products', 'model_no')) {
                    $table->string('model_no', 100)->nullable()->after('model');
                }
                if (!Schema::hasColumn('products', 'unit')) {
                    $table->string('unit', 50)->nullable();
                }
                if (!Schema::hasColumn('products', 'selling_price')) {
                    $table->decimal('selling_price', 10, 2)->default(0)->after('cost_price');
                }
                if (!Schema::hasColumn('products', 'currently_stored_quantity')) {
                    $table->integer('currently_stored_quantity')->default(0)->after('selling_price');
                }
            });
            if (Schema::hasColumn('products', 'brand_id')) {
                try {
                    Schema::table('products', function (Blueprint $table) {
                        $table->foreign('brand_id')->references('brand_id')->on('brand_lookup')->onDelete('set null');
                    });
                } catch (\Throwable $e) {
                    // FK may already exist
                }
            }
        }

        // Create IM_Inventory (serialized/unit-level inventory tracking)
        if (!Schema::hasTable('im_inventory')) {
            Schema::create('im_inventory', function (Blueprint $table) {
                $table->id();
                $table->unsignedBigInteger('product_id')->nullable();
                $table->unsignedBigInteger('location_id')->nullable();
                $table->string('serial_no', 100)->nullable();
                $table->integer('quantity')->default(1);
                $table->unsignedBigInteger('status_id')->nullable();
                $table->timestamps();

                $table->foreign('product_id')->references('product_id')->on('products')->onDelete('cascade');
                $table->foreign('location_id')->references('id')->on('locations')->onDelete('set null');
                $table->foreign('status_id')->references('status_id')->on('status_lookup')->onDelete('set null');
            });
        }

        // Create item_terms (warranty/terms for inventory items)
        if (!Schema::hasTable('item_terms')) {
            Schema::create('item_terms', function (Blueprint $table) {
                $table->id();
                $table->unsignedBigInteger('inventory_id');
                $table->string('serial_number', 100)->nullable();
                $table->string('warranty_type', 50)->nullable();
                $table->dateTime('expire_date')->nullable();
                $table->timestamps();

                $table->foreign('inventory_id')->references('id')->on('im_inventory')->onDelete('cascade');
            });
        }

        // Create adjustment_type lookup
        if (!Schema::hasTable('adjustment_type')) {
            Schema::create('adjustment_type', function (Blueprint $table) {
                $table->id();
                $table->string('adjustment_type_name', 100);
                $table->timestamps();
            });
        }

        // Update adjustments table - add adjustment_type_id
        if (Schema::hasTable('adjustments')) {
            Schema::table('adjustments', function (Blueprint $table) {
                if (!Schema::hasColumn('adjustments', 'adjustment_type_id')) {
                    $table->unsignedBigInteger('adjustment_type_id')->nullable()->after('adjustment_id');
                }
            });
            if (Schema::hasColumn('adjustments', 'adjustment_type_id')) {
                try {
                    Schema::table('adjustments', function (Blueprint $table) {
                        $table->foreign('adjustment_type_id')->references('id')->on('adjustment_type')->onDelete('set null');
                    });
                } catch (\Throwable $e) {
                    // FK may already exist
                }
            }
        }

        // Create return_merchandise_authorization (RMA)
        if (!Schema::hasTable('return_merchandise_authorization')) {
            Schema::create('return_merchandise_authorization', function (Blueprint $table) {
                $table->id();
                $table->unsignedBigInteger('customer_id')->nullable();
                $table->string('rma_number', 50)->nullable();
                $table->text('description')->nullable();
                $table->unsignedBigInteger('order_id')->nullable();
                $table->unsignedBigInteger('delivery_id')->nullable();
                $table->string('condition', 50)->nullable();
                $table->integer('requested_stocks')->default(0);
                $table->integer('received_stocks')->default(0);
                $table->string('confirmation', 100)->nullable();
                $table->unsignedBigInteger('status_id')->nullable();
                $table->timestamps();

                $table->foreign('customer_id')->references('id')->on('customers')->onDelete('set null');
                $table->foreign('order_id')->references('sales_id')->on('sales')->onDelete('set null');
                $table->foreign('delivery_id')->references('dr_id')->on('delivery_receipts')->onDelete('set null');
                $table->foreign('status_id')->references('status_id')->on('status_lookup')->onDelete('set null');
            });
        }

        // Create inventory_return
        if (!Schema::hasTable('inventory_return')) {
            Schema::create('inventory_return', function (Blueprint $table) {
                $table->id();
                $table->unsignedBigInteger('customer_id')->nullable();
                $table->unsignedBigInteger('sales_id')->nullable();
                $table->string('return_number', 50)->nullable();
                $table->dateTime('return_date')->nullable();
                $table->string('return_type', 50)->nullable();
                $table->unsignedBigInteger('recorded_by')->nullable();
                $table->unsignedBigInteger('return_to_user_id')->nullable();
                $table->dateTime('expected_return_date')->nullable();
                $table->dateTime('actual_return_date')->nullable();
                $table->unsignedBigInteger('status_id')->nullable();
                $table->unsignedBigInteger('approved_by')->nullable();
                $table->unsignedBigInteger('received_by')->nullable();
                $table->timestamps();

                $table->foreign('customer_id')->references('id')->on('customers')->onDelete('set null');
                $table->foreign('sales_id')->references('sales_id')->on('sales')->onDelete('set null');
                $table->foreign('recorded_by')->references('user_id')->on('users')->onDelete('set null');
                $table->foreign('return_to_user_id')->references('user_id')->on('users')->onDelete('set null');
                $table->foreign('status_id')->references('status_id')->on('status_lookup')->onDelete('set null');
                $table->foreign('approved_by')->references('user_id')->on('users')->onDelete('set null');
                $table->foreign('received_by')->references('user_id')->on('users')->onDelete('set null');
            });
        }

        // Create inventory_return_detail
        if (!Schema::hasTable('inventory_return_detail')) {
            Schema::create('inventory_return_detail', function (Blueprint $table) {
                $table->id();
                $table->unsignedBigInteger('return_id');
                $table->unsignedBigInteger('product_id')->nullable();
                $table->integer('quantity_returned')->default(0);
                $table->string('reason_for_return', 255)->nullable();
                $table->string('condition_returned', 50)->nullable();
                $table->timestamps();

                $table->foreign('return_id')->references('id')->on('inventory_return')->onDelete('cascade');
                $table->foreign('product_id')->references('product_id')->on('products')->onDelete('set null');
            });
        }

        // Update purchase_orders - add ordered_by, received_by
        if (Schema::hasTable('purchase_orders')) {
            Schema::table('purchase_orders', function (Blueprint $table) {
                if (!Schema::hasColumn('purchase_orders', 'ordered_by')) {
                    $table->unsignedBigInteger('ordered_by')->nullable()->after('status_id');
                }
                if (!Schema::hasColumn('purchase_orders', 'received_by')) {
                    $table->unsignedBigInteger('received_by')->nullable()->after('approved_by');
                }
            });
            try {
                Schema::table('purchase_orders', function (Blueprint $table) {
                    if (Schema::hasColumn('purchase_orders', 'ordered_by')) {
                        $table->foreign('ordered_by')->references('user_id')->on('users')->onDelete('set null');
                    }
                    if (Schema::hasColumn('purchase_orders', 'received_by')) {
                        $table->foreign('received_by')->references('user_id')->on('users')->onDelete('set null');
                    }
                });
            } catch (\Throwable $e) {
                // FKs may already exist
            }
        }

        // Update delivery_receipts - add delivery_date, delivered_by, received_by
        if (Schema::hasTable('delivery_receipts')) {
            Schema::table('delivery_receipts', function (Blueprint $table) {
                if (!Schema::hasColumn('delivery_receipts', 'delivery_date')) {
                    $table->dateTime('delivery_date')->nullable()->after('dr_number');
                }
                if (!Schema::hasColumn('delivery_receipts', 'delivered_by')) {
                    $table->unsignedBigInteger('delivered_by')->nullable()->after('delivery_date');
                }
                if (!Schema::hasColumn('delivery_receipts', 'received_by')) {
                    $table->unsignedBigInteger('received_by')->nullable()->after('delivered_by');
                }
            });
        }

        // Update transfers - add transfer_by, date
        if (Schema::hasTable('transfers')) {
            Schema::table('transfers', function (Blueprint $table) {
                if (!Schema::hasColumn('transfers', 'transfer_by')) {
                    $table->unsignedBigInteger('transfer_by')->nullable()->after('transfer_date');
                }
            });
        }

        // Update transfer_details - add inventory_id
        if (Schema::hasTable('transfer_details')) {
            Schema::table('transfer_details', function (Blueprint $table) {
                if (!Schema::hasColumn('transfer_details', 'inventory_id')) {
                    $table->unsignedBigInteger('inventory_id')->nullable()->after('transfer_id');
                }
            });
            if (Schema::hasColumn('transfer_details', 'inventory_id')) {
                Schema::table('transfer_details', function (Blueprint $table) {
                    $table->foreign('inventory_id')->references('id')->on('im_inventory')->onDelete('set null');
                });
            }
        }

        // Update adjustment_details - add inventory_id
        if (Schema::hasTable('adjustment_details')) {
            Schema::table('adjustment_details', function (Blueprint $table) {
                if (!Schema::hasColumn('adjustment_details', 'inventory_id')) {
                    $table->unsignedBigInteger('inventory_id')->nullable()->after('adjustment_id');
                }
            });
            if (Schema::hasColumn('adjustment_details', 'inventory_id')) {
                Schema::table('adjustment_details', function (Blueprint $table) {
                    $table->foreign('inventory_id')->references('id')->on('im_inventory')->onDelete('set null');
                });
            }
        }

        // Create QC_transfer_tracking
        if (!Schema::hasTable('qc_transfer_tracking')) {
            Schema::create('qc_transfer_tracking', function (Blueprint $table) {
                $table->id();
                $table->unsignedBigInteger('transfer_id')->nullable();
                $table->unsignedBigInteger('inventory_id')->nullable();
                $table->string('transfer_number', 50)->nullable();
                $table->dateTime('date')->nullable();
                $table->string('status', 50)->nullable();
                $table->unsignedBigInteger('recorded_by')->nullable();
                $table->timestamps();

                $table->foreign('transfer_id')->references('transfer_id')->on('transfers')->onDelete('cascade');
                $table->foreign('inventory_id')->references('id')->on('im_inventory')->onDelete('set null');
                $table->foreign('recorded_by')->references('user_id')->on('users')->onDelete('set null');
            });
        }

        // Create inventory_group and inventory_group_items
        if (!Schema::hasTable('inventory_group')) {
            Schema::create('inventory_group', function (Blueprint $table) {
                $table->id();
                $table->string('group_name', 255)->nullable();
                $table->text('description')->nullable();
                $table->timestamps();
            });
        }
        if (!Schema::hasTable('inventory_group_items')) {
            Schema::create('inventory_group_items', function (Blueprint $table) {
                $table->id();
                $table->unsignedBigInteger('group_id');
                $table->unsignedBigInteger('product_id')->nullable();
                $table->integer('quantity')->default(1);
                $table->decimal('subtotal', 12, 2)->default(0);
                $table->timestamps();

                $table->foreign('group_id')->references('id')->on('inventory_group')->onDelete('cascade');
                $table->foreign('product_id')->references('product_id')->on('products')->onDelete('cascade');
            });
        }

        // Create process_logs
        if (!Schema::hasTable('process_logs')) {
            Schema::create('process_logs', function (Blueprint $table) {
                $table->id();
                $table->unsignedBigInteger('module_id')->nullable();
                $table->unsignedBigInteger('location_id')->nullable();
                $table->unsignedBigInteger('product_id')->nullable();
                $table->unsignedBigInteger('inventory_id')->nullable();
                $table->string('stock_transaction_type', 50)->nullable();
                $table->string('reference_type', 50)->nullable();
                $table->unsignedBigInteger('reference_id')->nullable();
                $table->dateTime('transaction_date')->nullable();
                $table->dateTime('received_date')->nullable();
                $table->string('barcode_number', 100)->nullable();
                $table->string('activity_type', 100)->nullable();
                $table->decimal('cost', 12, 2)->default(0);
                $table->decimal('total_loss_cost', 12, 2)->default(0);
                $table->unsignedBigInteger('recorded_by')->nullable();
                $table->timestamps();

                $table->foreign('location_id')->references('id')->on('locations')->onDelete('set null');
                $table->foreign('product_id')->references('product_id')->on('products')->onDelete('set null');
                $table->foreign('inventory_id')->references('id')->on('im_inventory')->onDelete('set null');
                $table->foreign('recorded_by')->references('user_id')->on('users')->onDelete('set null');
            });
        }

        // Create audit_log (ERD audit_log - record-level audit)
        if (!Schema::hasTable('audit_log')) {
            Schema::create('audit_log', function (Blueprint $table) {
                $table->id();
                $table->unsignedBigInteger('user_id')->nullable();
                $table->unsignedBigInteger('record_id')->nullable();
                $table->string('record_table', 100)->nullable();
                $table->string('action', 50)->nullable();
                $table->timestamps();

                $table->foreign('user_id')->references('user_id')->on('users')->onDelete('set null');
            });
        }

        // Update sales table - add order_date, due_date, payment_status (varchar), payment_due, total_paid per ERD
        if (Schema::hasTable('sales')) {
            Schema::table('sales', function (Blueprint $table) {
                if (!Schema::hasColumn('sales', 'order_date')) {
                    $table->date('order_date')->nullable()->after('invoice_number');
                }
                if (!Schema::hasColumn('sales', 'due_date')) {
                    $table->date('due_date')->nullable()->after('order_date');
                }
                if (!Schema::hasColumn('sales', 'payment_status')) {
                    $table->string('payment_status', 50)->nullable()->after('payment_method');
                }
                if (!Schema::hasColumn('sales', 'payment_due')) {
                    $table->decimal('payment_due', 12, 2)->default(0)->after('payment_status');
                }
                if (!Schema::hasColumn('sales', 'total_paid')) {
                    $table->decimal('total_paid', 12, 2)->default(0)->after('payment_due');
                }
            });
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('audit_log');
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
};
