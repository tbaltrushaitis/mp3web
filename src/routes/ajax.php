<?php

/*
|-------------------------------------------------------------------------------
|   AJAX Routes
|-------------------------------------------------------------------------------
*/

Route::get('/{hash}/meta', 'AjaxController@getMeta')
  ->where(['hash' => '[0-9a-f]+'])
  ->name('Meta:get');
Route::get('/meta/{hash}', 'AjaxController@getMeta')
  ->where(['hash' => '[0-9a-f]+'])
  ->name('Meta:getHash');


Route::post('/{hash}/meta', 'AjaxController@updateMeta')
  ->where(['hash' => '[0-9a-f]+'])
  ->name('Meta:update');
Route::post('/meta/{hash}', 'AjaxController@updateMeta')
  ->where(['hash' => '[0-9a-f]+'])
  ->name('Meta:updateHash');


Route::delete('/{hash}/meta', 'AjaxController@destroy')
  ->where(['hash' => '[0-9a-f]+'])
  ->name('Meta:delete');
Route::delete('/meta/{hash}', 'AjaxController@destroy')
  ->where(['hash' => '[0-9a-f]+'])
  ->name('Meta:deleteHash');
