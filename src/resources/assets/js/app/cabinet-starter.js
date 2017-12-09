/*  BOF: assets/js/app/cabinet-starter.js  */

/*!
 * ASSETS/JS/APP/cabinet-starter.js
 * Copyright(c) 2016-2017 Baltrushaitis Tomas
 * MIT Licensed
 */

'use strict';

require([
    'jquery'
  , 'lodash'
  , 'cabinetController'
  , 'bootstrapTags'
  , 'functions'
  // , 'LTEapp'
]
  // , function ($, _, cc, bsTags, F, LTE) {
  , function ($, _, cc, bsTags, F) {
    console.timeStamp('CABINET MODULES READY');
});

//define([
require([
    'require'
  , 'jquery'
  , 'lodash'
  , 'functions'
  , 'cabinetController'
  , 'bootstrapTags'
  // , 'LTEapp'
  ]

  // , function (require, $, _, LTE) {
  , function (require, $, _) {

    var ControllerCabinet = new require('cabinetController');
    var libTags           = new require('bootstrapTags');

    // $.when(ControllerCabinet, libTags, LTE)
    $.when(ControllerCabinet, libTags)
     .then(function (loCabinet) {
      var pageId = $('body').attr('data-id_page');
      console.group(pageId);
      console.timeStamp(pageId + ':CHECK-IN');
      console.info('Starting CabinetController');
      console.groupEnd(pageId);
      loCabinet.start();
    });

});

/*  EOF: assets/js/app/cabinet-starter.js  */
