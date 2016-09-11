<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class AlterUsersTableStructure extends Migration {
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up () {
        Schema::table('users', function (Blueprint $table) {
            $table->text('avatar')->after('email')->default('')->comment('User Avatar');
            $table->text('profile_url')->after('avatar')->default('')->comment('Link to FB Profile Page');
            $table->boolean('is_admin')->after('profile_url')->default(FALSE)->comment('Enable ADMIN privileges');
            $table->text('notes')->after('is_admin')->default('')->comment('Comments');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down () {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn('avatar');
            $table->dropColumn('profile_url');
            $table->dropColumn('is_admin');
            $table->dropColumn('notes');
        });
    }
}
