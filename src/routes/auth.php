<?php

/*
|-------------------------------------------------------------------------------
|   Authentication Routes
|-------------------------------------------------------------------------------
*/

Auth::routes();

Route::get('logout', ['as' => 'Auth:Logout', 'uses' => 'Auth\LoginController@logout']);
