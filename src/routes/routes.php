<?php

/*
|-------------------------------------------------------------------------------
|   Application Routes
|-------------------------------------------------------------------------------
*/
// Route::get('/', ['as' => 'Front:Index', 'uses' => 'MediaController@listAudio']);
Route::get('/', ['as' => 'Front:Index', 'uses' => 'FrontController@index']);

/*
|-------------------------------------------------------------------------------
|   Tracks Properties manipulation Routes
|-------------------------------------------------------------------------------
*/
Route::get('/{hash}', ['as' => 'Media:Play', 'uses' => 'MediaController@mediaPlay'])
  ->where(['hash' => '[0-9a-f]+']);

Route::get('/{hash}/play', ['as' => 'Media:Play', 'uses' => 'MediaController@mediaPlay'])
  ->where(['hash' => '[0-9a-f]+']);

Route::post('rate/{hash}/{rate}', ['as' => 'Media:Rate', 'uses' => 'MediaController@mediaRate'])
  ->where([
    'hash' => '[0-9a-f]+'
  , 'rate' => '(dis)?like'
]);

Route::delete('/{hash}', ['as' => 'Media:Delete', 'uses' => 'MediaController@mediaDrop'])
  ->where(['hash' => '[0-9a-f]+']);


/*
|-------------------------------------------------------------------------------
|   Authentication Routes
|-------------------------------------------------------------------------------
*/
Route::get('login',  ['as' => 'Auth:LoginForm', 'uses' => 'Auth\AuthController@showLoginForm']);
Route::post('login', ['as' => 'Auth:Login',     'uses' => 'Auth\AuthController@login']);
Route::get('logout', ['as' => 'Auth:Logout',    'uses' => 'Auth\AuthController@logout']);

Route::group(['prefix' => 'password'], function () {

  Route::post('email',         ['as' => 'Password:send',          'uses' => 'Auth\PasswordController@sendResetLinkEmail']);
  Route::post('reset',         ['as' => 'Password:reset',         'uses' => 'Auth\PasswordController@reset']);
  Route::get('reset/{token?}', ['as' => 'Password:showResetForm', 'uses' => 'Auth\PasswordController@showResetForm']);

});

Route::get('register',  ['as' => 'Auth:RegistrationForm', 'uses' => 'Auth\AuthController@showRegistrationForm']);
Route::post('register', ['as' => 'Auth:Register',         'uses' => 'Auth\AuthController@register']);


/*
|-------------------------------------------------------------------------------
|   Cabinet Routes
|-------------------------------------------------------------------------------
*/
Route::get('/cabinet',   ['as' => 'Cabinet:Index',     'uses' => 'CabinetController@index']);
Route::get('/dashboard', ['as' => 'Cabinet:Dashboard', 'uses' => 'CabinetController@showDashboard']);


/*
|-------------------------------------------------------------------------------
|   AJAX Routes
|-------------------------------------------------------------------------------
*/
Route::get('/{hash}/meta',    ['as' => 'Meta:get', 'uses' => 'AjaxController@getMeta'])
  ->where(['hash' => '[0-9a-f]+']);

Route::post('/{hash}/meta',   ['as' => 'Meta:update', 'uses' => 'AjaxController@updateMeta'])
  ->where(['hash' => '[0-9a-f]+']);

Route::delete('/{hash}/meta', ['as' => 'Meta:delete', 'uses' => 'AjaxController@destroy'])
  ->where(['hash' => '[0-9a-f]+']);
