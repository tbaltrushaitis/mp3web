/*!
 * File:          ASSETS/JS/APP/cabinet-starter.js
 * License:       MIT
 * Copyright (c)  2016-2017 Baltrushaitis Tomas
 */

'use strict';

require([
    'jquery'
  , 'underscore'
  , 'cabinetController'
  , 'bootstrapTags'
  , 'functions'
  // , 'LTEapp'
]
  // , function ($, _, cc, bsTags, F, LTE) {
  , function ($, _, cc, bsTags) {
    console.info('CABINET STARTER MODULES READY');
});

// define([
require([
    // 'require'
    'jquery'
  , 'underscore'
  , 'bootstrapTags'
  , 'functions'
  // , 'cabinetController'
  // , 'LTEapp'
  ]

  // , function (require, $, _, LTE) {
  // , function ($, _, libTags, cabinetController) {
  , function ($, _, libTags) {

    var ControllerCabinet = new require('cabinetController');
    // var libTags           = new require('bootstrapTags');

    // $.when(ControllerCabinet, libTags, LTE)
    $.when(ControllerCabinet, libTags)
     .then(function (loCabinet) {
      var pageId = $('body').attr('data-id_page');
      console.group(pageId);
      console.info(pageId + ':CHECK-IN');
      console.info('Starting CabinetController');
      console.log('loCabinet (', typeof loCabinet, ') =', loCabinet);
      console.groupEnd(pageId);
      loCabinet.start();
    });

});

/*  EOF: assets/js/app/cabinet-starter.js  */
