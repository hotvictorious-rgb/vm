database/migrations/2024_01_01_000001_create_chat_tables.php

<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Add new columns to existing 'chatting' table
        if (Schema::hasTable('chatting')) {
            Schema::table('chatting', function (Blueprint $table) {
                if (!Schema::hasColumn('chatting', 'order_id')) {
                    $table->unsignedBigInteger('order_id')->nullable()->after('admin_id');
                    $table->foreign('order_id')->references('id')->on('orders')->onDelete('cascade');
                }
                if (!Schema::hasColumn('chatting', 'chat_type')) {
                    $table->enum('chat_type', [
                        'customer_to_admin',
                        'customer_to_delivery',
                        'vendor_to_admin',
                        'vendor_to_delivery'
                    ])->nullable()->after('order_id');
                }
                if (!Schema::hasColumn('chatting', 'is_active')) {
                    $table->boolean('is_active')->default(true)->after('chat_type');
                }
                if (!Schema::hasColumn('chatting', 'seen_by_admin')) {
                    $table->boolean('seen_by_admin')->default(false)->after('seen_by_delivery_man');
                }
            });
        }

        // Create chat_attachments table
        if (!Schema::hasTable('chat_attachments')) {
            Schema::create('chat_attachments', function (Blueprint $table) {
                $table->id();
                $table->unsignedBigInteger('chat_id');
                $table->enum('type', ['media', 'file']);
                $table->text('path');
                $table->string('name');
                $table->string('size')->nullable();
                $table->string('key')->nullable();
                $table->timestamps();

                $table->foreign('chat_id')->references('id')->on('chatting')->onDelete('cascade');
                $table->index('chat_id');
            });
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('chatting', function (Blueprint $table) {
            $table->dropForeignIfExists(['order_id']);
            $table->dropColumnIfExists(['order_id', 'chat_type', 'is_active', 'seen_by_admin']);
        });

        Schema::dropIfExists('chat_attachments');
    }
};
