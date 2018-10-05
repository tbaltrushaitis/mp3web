<?php

/*
|-------------------------------------------------------------------------------
|   Cabinet Routes
|-------------------------------------------------------------------------------
*/

Route::get('/cabinet', 'CabinetController@index')->name('Cabinet:Index');
Route::get('/dashboard', 'CabinetController@showDashboard')->name('Cabinet:Dashboard');
