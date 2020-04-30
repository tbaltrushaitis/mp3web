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

  var Config = {};

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
      return Config[n];
    });
  }

  console.info('Config:', Config);

  /*
  |--------------------------------------------------------------------------
  |   EXPOSED OBJECT
  |--------------------------------------------------------------------------
  */

  return Config;

});
