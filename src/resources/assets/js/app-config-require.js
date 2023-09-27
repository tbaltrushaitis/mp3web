/*!
 * File:        ASSETS/JS/app-config-require.js
 * License:     MIT
 * Copyright (c) 2016-nowdays Baltrushaitis Tomas
 */

'use strict';

(function (require) {

  let AppConsoleLogo = `
┌────────┐
│ MP3WEB │
└────────┘
`;

  let rootPath = document.querySelector('body').dataset.rooturl.replace('://', '');
  if (!rootPath.endsWith('/')) {
    rootPath += '/';
  }

  let pos  = rootPath.indexOf('/');
  rootPath = (-1 !== pos && pos + 1 < rootPath.length) ? rootPath.substr(pos) : '/';

  require.config({
      baseUrl:      rootPath + 'assets/js'
    , waitSeconds:  10
  });

  require.onError = function (err) {
    console.warn('[requirejs] Error:', err.requireType, err);
    if ('timeout' === err.requireType) {
      console.warn('Affected Modules: ' + err.requireModules);
    }
    throw err;
  };


  (function () {
    let config = {
      map: {
        '*': {
          // 'common': 'app/common'
        }
      }
    };
    require.config(config);
  })();


  (function () {

    let config = {
        paths: {
            jquery:         'lib/jquery'
          , lodash:         'lib/lodash'
          , bootstrap:      'lib/bootstrap'
          , Tmpl:           'lib/jquery.tmpl'
          , raty:           'lib/jquery.raty'
          , bootstrapTags:  'lib/bootstrap-tagsinput'
          , Abstract:       'app/classes/Abstract.class'
          , Player:         'app/classes/Player.class'
          , Config:         'app/modules/Config'
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
          , bootstrap: {
                exports:  'bootstrap'
              , deps:     ['jquery']
            }
          , bootstrapTags:  ['jquery', 'bootstrap']
          , Tmpl:           ['jquery']
          , raty:           ['jquery']
          , Abstract:       ['jquery', 'lodash']
          , Player:         ['jquery', 'lodash']
          , functions:      ['jquery']
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


  // Load APP-Starter Module
  (function () {

    require(['jquery', 'app/app-starter'], function ($) {
      console.log(AppConsoleLogo);

      let pageId = $('body').attr('data-id_page');
      // console.groupCollapsed(pageId);
      console.group(pageId);
      console.timeStamp('APP.CHECK-IN');
      console.log('APP.CHECK-IN');
      console.info('APP::Started');
      console.groupEnd(pageId);

    }, function (err) {
      let failedId = err.requireModules && err.requireModules[0];
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
