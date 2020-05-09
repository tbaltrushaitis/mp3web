<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateTracksTable extends Migration {
  /**
   * Run the migrations.
   *
   * @return void
   */
  public function up () {
    Schema::create('tracks_catalog', function (Blueprint $table) {
      $table->increments('id');

      $table->string('name', 254);

      $table->integer('appid');
      $table->integer('contextid');
      $table->string('assetid', 10);
      $table->string('classid', 10);
      $table->string('instanceid', 10);

      $table->string('exterior', 254);

      $table->decimal('price', 8, 3);
      $table->timestamps();
    });
  }

  /**
   * Reverse the migrations.
   *
   * @return void
   */
  public function down () {
    Schema::drop('tracks_catalog');
  }

}
