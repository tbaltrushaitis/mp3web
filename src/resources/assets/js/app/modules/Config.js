/*!
 * File:    ASSETS/JS/APP/MODULES/Config.js
 * Copyright (c) 2016-nowdays Baltrushaitis Tomas
 * License:     MIT
 */

'use strict';

define([
  'jquery',
  'lodash',
  'text'
], function ($, _, text) {

  var Config = window.Config || {};

  //  DEFAULT FLEX CONFIG
  Config['flex'] = getConfig('flex');

  /*
  |--------------------------------------------------------------------------
  |   GET JSON CONFIG
  |--------------------------------------------------------------------------
  */

  function getConfig (n) {
    var flexUrl = `/assets/data/${n || 'config'}.json`;
    require(['text!' + flexUrl], function (content) {
      var flexConfig = content;
      Config[n] = JSON.parse(flexConfig).flex;
      console.info(`Config[${n}]:`, Config[n]);
      return Config[n];
    });
  }


  /*
  |--------------------------------------------------------------------------
  |   EXPOSED OBJECT
  |--------------------------------------------------------------------------
  */

  return Config;

});
