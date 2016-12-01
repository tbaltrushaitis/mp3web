/*  BOF: assets/js/app-config-require.js  */

requirejs.config({
    baseUrl: 'assets/js'
  , paths: {
        jquery:         'lib/jquery'
      , underscore:     'lib/underscore'
      , bootstrap:      'lib/bootstrap'
      , Tmpl:           'lib/jquery.tmpl'
      , raty:           'plugins/raty/jquery.raty'
      , bootstrapTags:  'plugins/bootstrap-tagsinput/bootstrap-tagsinput'
      , Abstract:       'app/classes/Abstract.class'
      , Player:         'app/classes/Player.class'
      , functions:      'app/functions'
    }
  , shim: {
        jquery: {
            exports:    'jQuery'
        }
      , underscore: {
            exports:    '_'
          , deps:       ['jquery']
        }
      , bootstrap: {
            exports:    'bootstrap'
          , deps:       ['jquery']
        }
      , bootstrapTags:  ['jquery']
      , Tmpl:           ['jquery']
      , raty:           ['jquery']
      , Abstract:       ['jquery']
      , Player:         ['jquery']
      , functions:      ['jquery']
    }
  , waitSeconds: 6
});

// Load APP-Starter Module
requirejs(['jquery', 'app/App_Starter']
  , function ($) {
        var pageId  =   $('body').attr('data-id_page');
        console.groupCollapsed(pageId);
        console.timeStamp('APP.CHECK-IN');
        console.info('APP::Started');
        console.groupEnd(pageId);
    }
);

/*  EOF: assets/js/app-config-require.js  */
