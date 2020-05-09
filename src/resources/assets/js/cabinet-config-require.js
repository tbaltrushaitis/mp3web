/*!
 * File:          ASSETS/JS/cabinet-config-require.js
 * License:       MIT
 * Copyright (c)  2016-nowdays Baltrushaitis Tomas
 */

'use strict';

(function (require) {

    var rootPath = document.querySelector('body').dataset.rooturl.replace('://', '');
    if (!rootPath.endsWith('/')) {
      rootPath += '/';
    }

    var pos  = rootPath.indexOf('/');
    rootPath = (-1 !== pos && pos + 1 < rootPath.length) ? rootPath.substr(pos) : '/';

    require.config({
        baseUrl:      rootPath + 'assets/js'
      , waitSeconds:  8
    });

    require.onError = function (err) {
      console.warn('[requirejs] Error:', err.requireType);
      if ('timeout' === err.requireType) {
        console.warn('Affected Modules: ' + err.requireModules);
      }
      throw err;
    };

    (function () {
      var config = {
        map: {
          '*': {
            // 'common': 'app/common'
            //index:          'app/index'
          }
        }
      };
      require.config(config);
    })();

    (function () {

      var config = {
          paths: {
              jquery:             'lib/jquery'
            , Tmpl:               'lib/jquery.tmpl'
            , bootstrap:          'lib/bootstrap'
            , lodash:             'lib/lodash'
            , raty:               'lib/jquery.raty'
            , bootstrapTags:      'lib/bootstrap-tagsinput'
            , LTEapp:             'lib/bower-bundle.min'
            , Abstract:           'app/classes/Abstract.class'
            , cabinetController:  'app/controllers/cabinetController'
            , functions:          'app/functions'
          }
        , shim: {
              jquery: {
                exports:  'jQuery'
              }
            , lodash: {
                exports:  '_'
              , deps:     ['jquery']
              }
            , bootstrap: {
                exports:  'bootstrap'
              , deps:     ['jquery']
              }
            , bootstrapTags:      ['jquery', 'bootstrap']
            , Tmpl:               ['jquery']
            , raty:               ['jquery']
            , LTEapp:             ['jquery', 'bootstrap']
            , Abstract:           ['jquery', 'lodash']
            , cabinetController:  ['jquery', 'lodash']
            , functions:          ['jquery', 'lodash']
          }
        , deps: [
              'jquery'
            , 'lodash'
          ]
      };

      require(['jquery'], function ($) {
        $.noConflict();
      });

      require(['jquery'], function ($) {
        $.ajaxSetup({
          headers: {
            'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
          }
        });
      });

      require.config(config);

    })();

    // Load Starter Module
    (function () {
      require(['jquery', 'app/cabinet-starter'], function ($) {
        var pageId = $('body').attr('data-id_page');
        console.groupCollapsed(pageId);
        console.timeStamp('CABINET.CHECK-IN');
        console.info('CABINET::Started');
        console.groupEnd(pageId);
      }, function (err) {
        var failedId = err.requireModules && err.requireModules[0];
        console.warn('[requirejs] Errors in [' + failedId + ']:', err.requireModules[0]);
      });
    })();

})(require);

/*  EOF: assets/js/cabinet-config-require.js  */
