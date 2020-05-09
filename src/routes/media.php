<?php

/*
|-------------------------------------------------------------------------------
|   Media Entities Manipulations Routes
|-------------------------------------------------------------------------------
*/

Route::get('/{hash}', 'MediaController@mediaPlay')
  ->where(['hash' => '[0-9a-f]+'])
  ->name('Media:Hash')
;

Route::get('/{hash}/play', 'MediaController@mediaPlay')
  ->where(['hash' => '[0-9a-f]+'])
  ->name('Media:Play')
;

Route::get('/play/{hash}', 'MediaController@mediaPlay')
  ->where(['hash' => '[0-9a-f]+'])
  ->name('Media:Play:Hash')
;

Route::post('rate/{hash}/{rate}', 'MediaController@mediaRate')
  ->where([
      'hash' => '[0-9a-f]+'
    , 'rate' => '(dis)?like'
  ])
  ->name('Media:Rate')
;

Route::delete('/{hash}', 'MediaController@mediaDrop')
  ->where(['hash' => '[0-9a-f]+'])
  ->name('Media:Delete')
;
