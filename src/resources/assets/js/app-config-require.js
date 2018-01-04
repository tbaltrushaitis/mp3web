/*!
 * File:        ASSETS/JS/app-config-require.js
 * License:     MIT
 * Copyright (c) 2016-2017 Baltrushaitis Tomas
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
      , waitSeconds:  6
    });

    require.onError = function (err) {
      console.warn('[requirejs] Error:', err.requireType, err);
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
          }
        }
      };
      require.config(config);
    })();

    (function () {

      var config = {
        paths: {
            jquery:         'lib/jquery'
          , lodash:         'lib/lodash'
          , underscore:     'lib/underscore'
          , bootstrap:      'lib/bootstrap'
          , Tmpl:           'lib/jquery.tmpl'
          , raty:           'lib/jquery.raty'
          , bootstrapTags:  'lib/bootstrap-tagsinput'
          , Abstract:       'app/classes/Abstract.class'
          , Player:         'app/classes/Player.class'
          , functions:      'app/functions'
        }
      , shim: {
          jquery: {
            exports:  'jQuery'
          }
        , lodash: {
            exports:  '_'
          , deps:     ['jquery']
          }
        , underscore: {
            exports:  '_'
          , deps:     ['jquery']
          }
        , bootstrap: {
            exports:  'bootstrap'
          , deps:     ['jquery']
          }
        , bootstrapTags:  ['jquery', 'bootstrap']
        , Tmpl:           ['jquery']
        , raty:           ['jquery']
        , Abstract:       ['jquery']
        , Player:         ['jquery', 'Abstract']
        , functions:      ['jquery']
        }
      , deps: [
          'jquery'
        , 'underscore'
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

    // Load APP-Starter Module
    (function () {
      require(['jquery', 'app/app-starter'], function ($) {
        var pageId = $('body').attr('data-id_page');
        console.groupCollapsed(pageId);
        console.timeStamp('APP.CHECK-IN');
        console.info('APP::Started');
        console.groupEnd(pageId);
      }, function (err) {
        var failedId = err.requireModules && err.requireModules[0];
        console.warn('[requirejs] Errors in ' + failedId + ':', err.requireModules[0]);
      });
    })();

})(require);


// Load APP-Starter Module
/* requirejs(['jquery', 'app/app-starter']
  , function ($) {
        var pageId  =   $('body').attr('data-id_page');
        console.group(pageId);
        console.timeStamp('APP.CHECK-IN');
        console.info('APP::Started');
        console.groupEnd(pageId);
    }
);
*/

/*  EOF: assets/js/app-config-require.js  */
