/*  BOF: ASSETS/JS/cabinet-config-require.js  */

/*!
 * ASSETS/JS/cabinet-config-require.js
 * Copyright(c) 2016-2017 Baltrushaitis Tomas
 * MIT Licensed
 */

'use strict';

(function (require) {

    var rootPath    =   document.querySelector('body').dataset.rooturl.replace('://', '');
    if (!rootPath.endsWith('/')) {
        rootPath += '/';
    }

    var pos     =   rootPath.indexOf('/');
    rootPath    =   (-1 !== pos && pos + 1 < rootPath.length) ? rootPath.substr(pos) : '/';

    require.config({
        baseUrl:        rootPath + 'assets/js'
      , waitSeconds:    6
    });

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
            map: {
                '*': {
                    index:  'app/index'
                }
            }
          , paths: {
                jquery:             'lib/jquery'
              , Tmpl:               'lib/jquery.tmpl'
              , bootstrap:          'lib/bootstrap'
              , underscore:         'lib/lodash'
              , raty:               'plugins/raty/jquery.raty'
              , functions:          'app/functions'
              , bootstrapTags:      'plugins/bootstrap-tagsinput/bootstrap-tagsinput'
              , Abstract:           'app/classes/Abstract.class'
              , cabinetController:  'app/controllers/cabinetController'
            }
          , shim: {
                jquery: {
                    exports:        'jQuery'
                }
              , underscore: {
                    exports:        '_'
                  , deps:           ['jquery']
                }
              , bootstrap: {
                    exports:        'bootstrap'
                  , deps:           ['jquery']
                }
              , bootstrapTags:      ['jquery', 'bootstrap']
              , Tmpl:               ['jquery']
              , raty:               ['jquery']
              , functions:          ['jquery', 'underscore']
              , Abstract:           ['jquery', 'underscore']
              , cabinetController:  ['jquery', 'underscore']
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

    // Load Starter Module
    (function () {
        require(['cabinet-starter']);
    })();

})(require);
/*  EOF: assets/js/cabinet-config-require.js  */
