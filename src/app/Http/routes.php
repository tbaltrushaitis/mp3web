<?php

/*
|--------------------------------------------------------------------------
|   Application Routes
|--------------------------------------------------------------------------
*/
Route::get('/', ['as' => 'Index', 'uses' => 'MediaController@listAudio']);

Route::get('login',     'Auth\AuthController@showLoginForm');
Route::post('login',    'Auth\AuthController@login');
Route::get('logout',    'Auth\AuthController@logout');

Route::post('password/email',           'Auth\PasswordController@sendResetLinkEmail');
Route::post('password/reset',           'Auth\PasswordController@reset');
Route::get('password/reset/{token?}',   'Auth\PasswordController@showResetForm');

Route::get('register',  'Auth\AuthController@showRegistrationForm');
Route::post('register', 'Auth\AuthController@register');

/*
|--------------------------------------------------------------------------
|   Tracks Properties manipulation routes
|--------------------------------------------------------------------------
*/
Route::get('/{hash}',   ['as' => 'Play', 'uses' => 'MediaController@Play'])
    ->where(['hash' => '[0-9a-f]+']);

Route::post('rate/{hash}/{rate}',   ['as' => 'Rate', 'uses' => 'MediaController@Rate'])
    ->where(['hash' => '[0-9a-f]+', 'rate' => '(dis)?like']);

/*
|--------------------------------------------------------------------------
|   Dashboard Routes
|--------------------------------------------------------------------------
*/
Route::get('/home', ['as' => 'Home', 'uses' => 'HomeController@index']);
