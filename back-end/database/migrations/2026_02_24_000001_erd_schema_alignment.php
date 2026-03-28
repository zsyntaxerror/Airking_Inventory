<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

/**
 * Comprehensive ERD schema alignment migration.
 * Fixes all column/FK misalignments and creates missing tables to match the ERD exactly.
 *
 * ERD: Web-Based Adaptive Barcode Auditing and Inventory Management System for AirKing
 */
return new class extends Migration
{
    public function up(): void
    {
        // =============================================
        // 1. Fix item_serial: swap item_id → product_id
        // =============================================
        if (Schema::hasTable('item_serial')) {
            if (Schema::hasColumn('item_serial', 'item_id')) {
                // Disable FK checks — items_master was dropped with FK_CHECKS=0,
                // leaving orphaned FK metadata on item_serial.item_id
                DB::statement('SET FOREIGN_KEY_CHECKS=0');
                try {
                    DB::statement('ALTER TABLE item_serial DROP FOREIGN KEY item_serial_item_id_foreign');
                } catch (\Throwable $e) { /* FK may not exist */ }
                Schema::table('item_serial', function (Blueprint $table) {
                    $table->dropColumn('item_id');
                });
                DB::statement('SET FOREIGN_KEY_CHECKS=1');
            }

            if (!Schema::hasColumn('item_serial', 'product_id')) {
                Schema::table('item_serial', function (Blueprint $table) {
                    $table->unsignedBigInteger('product_id')->nullable()->after('serial_id');
                });
                try {
                    Schema::table('item_serial', function (Blueprint $table) {
                        $table->foreign('product_id')
                            ->references('product_id')->on('products')
                            ->onDelete('set null');
                    });
                } catch (\Throwable $e) { /* FK may already exist */ }
            }
        }

        // =============================================
        // 2. Fix products: add recommended_stocks, quantity
        // =============================================
        if (Schema::hasTable('products')) {
            Schema::table('products', function (Blueprint $table) {
                if (!Schema::hasColumn('products', 'recommended_stocks')) {
                    $table->integer('recommended_stocks')->default(0)->after('warranty_period_months');
                }
                if (!Schema::hasColumn('products', 'quantity')) {
                    $table->integer('quantity')->default(0)->after('recommended_stocks');
                }
            });
        }

        // =============================================
        // 3. Fix adjustments: add created_by, rename adjustment_date → date,
        //    convert adjusted_by from FK → varchar per ERD
        // =============================================
        if (Schema::hasTable('adjustments')) {
            // Drop adjusted_by FK constraint (ERD shows it as a plain varchar, not FK)
            if (Schema::hasColumn('adjustments', 'adjusted_by')) {
                try {
                    Schema::table('adjustments', function (Blueprint $table) {
                        $table->dropForeign(['adjusted_by']);
                    });
                } catch (\Throwable $e) { /* FK may not exist */ }
                // Change type to varchar
                Schema::table('adjustments', function (Blueprint $table) {
                    $table->string('adjusted_by', 255)->nullable()->change();
                });
            }

            // Add created_by (FK → users)
            if (!Schema::hasColumn('adjustments', 'created_by')) {
                Schema::table('adjustments', function (Blueprint $table) {
                    $table->unsignedBigInteger('created_by')->nullable()->after('location_id');
                });
                try {
                    Schema::table('adjustments', function (Blueprint $table) {
                        $table->foreign('created_by')
                            ->references('user_id')->on('users')
                            ->onDelete('set null');
                    });
                } catch (\Throwable $e) { /* ignore */ }
            }

            // Rename adjustment_date → date (ERD column name)
            if (Schema::hasColumn('adjustments', 'adjustment_date') && !Schema::hasColumn('adjustments', 'date')) {
                Schema::table('adjustments', function (Blueprint $table) {
                    $table->renameColumn('adjustment_date', 'date');
                });
            }
        }

        // =============================================
        // 4. Fix adjustment_details: replace variance columns with add_quantity/deduct_quantity
        // =============================================
        if (Schema::hasTable('adjustment_details')) {
            // Use FK_CHECKS=0 to safely drop columns that may have orphaned FK constraints
            // (items_master was dropped with FK_CHECKS=0 leaving orphaned FK metadata)
            DB::statement('SET FOREIGN_KEY_CHECKS=0');

            // Drop inventory_id FK + column
            if (Schema::hasColumn('adjustment_details', 'inventory_id')) {
                try {
                    DB::statement('ALTER TABLE adjustment_details DROP FOREIGN KEY adjustment_details_inventory_id_foreign');
                } catch (\Throwable $e) { /* FK may not exist */ }
                Schema::table('adjustment_details', function (Blueprint $table) {
                    $table->dropColumn('inventory_id');
                });
            }

            // Drop item_id (broken FK to dropped items_master)
            if (Schema::hasColumn('adjustment_details', 'item_id')) {
                try {
                    DB::statement('ALTER TABLE adjustment_details DROP FOREIGN KEY adjustment_details_item_id_foreign');
                } catch (\Throwable $e) { /* ignore */ }
                Schema::table('adjustment_details', function (Blueprint $table) {
                    $table->dropColumn('item_id');
                });
            }

            DB::statement('SET FOREIGN_KEY_CHECKS=1');

            // Drop serial_number column (not in ERD adjustment_detail)
            if (Schema::hasColumn('adjustment_details', 'serial_number')) {
                Schema::table('adjustment_details', function (Blueprint $table) {
                    $table->dropColumn('serial_number');
                });
            }

            // Drop ERD-non-compliant variance columns
            $colsToDrop = array_filter(
                ['system_quantity', 'actual_quantity', 'variance_quantity'],
                fn($c) => Schema::hasColumn('adjustment_details', $c)
            );
            if (!empty($colsToDrop)) {
                Schema::table('adjustment_details', function (Blueprint $table) use ($colsToDrop) {
                    $table->dropColumn(array_values($colsToDrop));
                });
            }

            // Add ERD-specified columns
            if (!Schema::hasColumn('adjustment_details', 'add_quantity')) {
                Schema::table('adjustment_details', function (Blueprint $table) {
                    $table->integer('add_quantity')->default(0);
                });
            }
            if (!Schema::hasColumn('adjustment_details', 'deduct_quantity')) {
                Schema::table('adjustment_details', function (Blueprint $table) {
                    $table->integer('deduct_quantity')->default(0);
                });
            }
        }

        // =============================================
        // 5. Fix receivings: rename purchase_order_id → pc_id,
        //    add profit_loss_id, drop supplier_id
        // =============================================
        if (Schema::hasTable('receivings')) {
            // Drop supplier_id FK + column (not in ERD receiving table)
            if (Schema::hasColumn('receivings', 'supplier_id')) {
                try {
                    Schema::table('receivings', function (Blueprint $table) {
                        $table->dropForeign(['supplier_id']);
                    });
                } catch (\Throwable $e) { /* ignore */ }
                Schema::table('receivings', function (Blueprint $table) {
                    $table->dropColumn('supplier_id');
                });
            }

            // Rename purchase_order_id → pc_id (ERD uses pc_id as the FK column)
            if (Schema::hasColumn('receivings', 'purchase_order_id') && !Schema::hasColumn('receivings', 'pc_id')) {
                try {
                    Schema::table('receivings', function (Blueprint $table) {
                        $table->dropForeign(['purchase_order_id']);
                    });
                } catch (\Throwable $e) { /* ignore */ }

                Schema::table('receivings', function (Blueprint $table) {
                    $table->renameColumn('purchase_order_id', 'pc_id');
                });

                try {
                    Schema::table('receivings', function (Blueprint $table) {
                        $table->foreign('pc_id')
                            ->references('po_id')->on('purchase_orders')
                            ->onDelete('set null');
                    });
                } catch (\Throwable $e) { /* ignore */ }
            }

            // Add profit_loss_id FK (ERD: RECEIVING references profit_loss)
            if (!Schema::hasColumn('receivings', 'profit_loss_id')) {
                Schema::table('receivings', function (Blueprint $table) {
                    $table->unsignedBigInteger('profit_loss_id')->nullable()->after('total_quantity_damaged');
                });
                try {
                    Schema::table('receivings', function (Blueprint $table) {
                        $table->foreign('profit_loss_id')
                            ->references('profit_loss_id')->on('profit_loss')
                            ->onDelete('set null');
                    });
                } catch (\Throwable $e) { /* ignore */ }
            }
        }

        // =============================================
        // 6. Fix receiving_details: replace raw receipt columns with ERD columns
        // =============================================
        if (Schema::hasTable('receiving_details')) {
            // Drop legacy columns not in ERD
            $legacyCols = array_filter(
                ['quantity_received', 'quantity_damaged', 'serial_number', 'barcode'],
                fn($c) => Schema::hasColumn('receiving_details', $c)
            );
            if (!empty($legacyCols)) {
                Schema::table('receiving_details', function (Blueprint $table) use ($legacyCols) {
                    $table->dropColumn(array_values($legacyCols));
                });
            }

            // Add ERD-specified columns
            if (!Schema::hasColumn('receiving_details', 'prod_price')) {
                Schema::table('receiving_details', function (Blueprint $table) {
                    $table->decimal('prod_price', 10, 2)->default(0);
                });
            }
            if (!Schema::hasColumn('receiving_details', 'quantity_amount')) {
                Schema::table('receiving_details', function (Blueprint $table) {
                    $table->integer('quantity_amount')->default(0);
                });
            }
            if (!Schema::hasColumn('receiving_details', 'condition')) {
                Schema::table('receiving_details', function (Blueprint $table) {
                    $table->string('condition', 100)->nullable();
                });
            }
        }

        // =============================================
        // 7. Fix profit_loss: add model_id FK, drop location_id + item_id
        //    ERD profit_loss: profit_loss_id, model_id FK, product_id FK, reference_type,
        //                     transaction_date, incident_date, serial_number, quantity_lost,
        //                     unit_cost, total_loss_amount, recorded_by, approved_by, status_id
        // =============================================
        if (Schema::hasTable('profit_loss')) {
            // Drop item_id FK + column (not in ERD)
            if (Schema::hasColumn('profit_loss', 'item_id')) {
                try {
                    Schema::table('profit_loss', function (Blueprint $table) {
                        $table->dropForeign(['item_id']);
                    });
                } catch (\Throwable $e) { /* ignore */ }
                Schema::table('profit_loss', function (Blueprint $table) {
                    $table->dropColumn('item_id');
                });
            }

            // Drop location_id FK + column (not in ERD)
            if (Schema::hasColumn('profit_loss', 'location_id')) {
                try {
                    Schema::table('profit_loss', function (Blueprint $table) {
                        $table->dropForeign(['location_id']);
                    });
                } catch (\Throwable $e) { /* ignore */ }
                Schema::table('profit_loss', function (Blueprint $table) {
                    $table->dropColumn('location_id');
                });
            }

            // Add model_id FK (ERD: profit_loss references model_lookup)
            if (!Schema::hasColumn('profit_loss', 'model_id')) {
                Schema::table('profit_loss', function (Blueprint $table) {
                    $table->unsignedBigInteger('model_id')->nullable()->after('profit_loss_id');
                });
                try {
                    Schema::table('profit_loss', function (Blueprint $table) {
                        $table->foreign('model_id')
                            ->references('model_id')->on('model_lookup')
                            ->onDelete('set null');
                    });
                } catch (\Throwable $e) { /* ignore */ }
            }

            // Drop reference_id (ERD uses reference_type only as varchar, not a FK integer)
            if (Schema::hasColumn('profit_loss', 'reference_id')) {
                Schema::table('profit_loss', function (Blueprint $table) {
                    $table->dropColumn('reference_id');
                });
            }
        }

        // =============================================
        // 8. Fix activity_log: add status_id FK (ERD field)
        // =============================================
        if (Schema::hasTable('activity_log')) {
            if (!Schema::hasColumn('activity_log', 'status_id')) {
                Schema::table('activity_log', function (Blueprint $table) {
                    $table->unsignedBigInteger('status_id')->nullable();
                });
                try {
                    Schema::table('activity_log', function (Blueprint $table) {
                        $table->foreign('status_id')
                            ->references('status_id')->on('status_lookup')
                            ->onDelete('set null');
                    });
                } catch (\Throwable $e) { /* ignore */ }
            }
        }

        // =============================================
        // 9. Fix audit_log: ensure ERD columns exist
        //    ERD: audit_id, user_id FK, action, table_affected, record_id, timestamp
        // =============================================
        if (Schema::hasTable('audit_log')) {
            Schema::table('audit_log', function (Blueprint $table) {
                if (!Schema::hasColumn('audit_log', 'table_affected')) {
                    $table->string('table_affected', 100)->nullable();
                }
                if (!Schema::hasColumn('audit_log', 'record_id')) {
                    $table->unsignedBigInteger('record_id')->nullable();
                }
                if (!Schema::hasColumn('audit_log', 'action')) {
                    $table->string('action', 50)->nullable();
                }
                if (!Schema::hasColumn('audit_log', 'timestamp')) {
                    $table->dateTime('timestamp')->nullable();
                }
            });

            // Rename record_table → table_affected if record_table exists
            if (Schema::hasColumn('audit_log', 'record_table') && !Schema::hasColumn('audit_log', 'table_affected')) {
                Schema::table('audit_log', function (Blueprint $table) {
                    $table->renameColumn('record_table', 'table_affected');
                });
            }
        }

        // =============================================
        // 10. Create purchase_returns table
        //     ERD: purchase_return_id, pc_id FK, supplier_id FK, receiving_id FK,
        //          pr_number, return_date, reason, total_amount, status_id FK,
        //          requested_by, approved_by, created_at, updated_at
        // =============================================
        if (!Schema::hasTable('purchase_returns')) {
            Schema::create('purchase_returns', function (Blueprint $table) {
                $table->id('purchase_return_id');
                $table->unsignedBigInteger('pc_id')->nullable();
                $table->unsignedBigInteger('supplier_id')->nullable();
                $table->unsignedBigInteger('receiving_id')->nullable();
                $table->string('pr_number', 50)->unique();
                $table->date('return_date')->nullable();
                $table->text('reason')->nullable();
                $table->decimal('total_amount', 12, 2)->default(0);
                $table->unsignedBigInteger('status_id')->nullable();
                $table->unsignedBigInteger('requested_by')->nullable();
                $table->unsignedBigInteger('approved_by')->nullable();
                $table->timestamps();

                $table->foreign('pc_id')
                    ->references('po_id')->on('purchase_orders')
                    ->onDelete('set null');
                $table->foreign('supplier_id')
                    ->references('id')->on('suppliers')
                    ->onDelete('set null');
                $table->foreign('receiving_id')
                    ->references('receiving_id')->on('receivings')
                    ->onDelete('set null');
                $table->foreign('status_id')
                    ->references('status_id')->on('status_lookup')
                    ->onDelete('set null');
                $table->foreign('requested_by')
                    ->references('user_id')->on('users')
                    ->onDelete('set null');
                $table->foreign('approved_by')
                    ->references('user_id')->on('users')
                    ->onDelete('set null');
            });
        }

        // =============================================
        // 11. Create purchase_return_details table
        //     ERD: pr_detail_id, purchase_return_id FK, product_id FK,
        //          quantity_returned, unit_cost, subtotal, condition,
        //          serial_id FK (→ item_serial), created_at
        // =============================================
        if (!Schema::hasTable('purchase_return_details')) {
            Schema::create('purchase_return_details', function (Blueprint $table) {
                $table->id('pr_detail_id');
                $table->unsignedBigInteger('purchase_return_id')->nullable();
                $table->unsignedBigInteger('product_id')->nullable();
                $table->integer('quantity_returned')->default(0);
                $table->decimal('unit_cost', 10, 2)->default(0);
                $table->decimal('subtotal', 12, 2)->default(0);
                $table->string('condition', 100)->nullable();
                $table->unsignedBigInteger('serial_id')->nullable();
                $table->timestamps();

                $table->foreign('purchase_return_id')
                    ->references('purchase_return_id')->on('purchase_returns')
                    ->onDelete('cascade');
                $table->foreign('product_id')
                    ->references('product_id')->on('products')
                    ->onDelete('set null');
                $table->foreign('serial_id')
                    ->references('serial_id')->on('item_serial')
                    ->onDelete('set null');
            });
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('purchase_return_details');
        Schema::dropIfExists('purchase_returns');

        // Re-add item_id to item_serial (simplified rollback)
        if (Schema::hasTable('item_serial') && !Schema::hasColumn('item_serial', 'item_id')) {
            Schema::table('item_serial', function (Blueprint $table) {
                $table->unsignedBigInteger('item_id')->nullable();
            });
        }
    }
};
