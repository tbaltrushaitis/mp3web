/*  BOF: assets/js/cabinet-starter.js  */

require(['jquery', 'underscore', 'cabinetController', 'bootstrapTags', 'functions']
  , function ($, _, cc, bsTags, F) {
        'use strict';
        console.timeStamp('CABINET MODULES READY');
});

define(['jquery', 'underscore', 'cabinetController', 'bootstrapTags', 'functions']
  , function ($, _, cc, bsTags, F) {

    'use strict';

    var ControllerCabinet   =   cc;
    var libTags             =   bsTags;

    $.when(ControllerCabinet, libTags, F)
     .then(function (loCabinet) {
        var pageId  =   $('body').attr('data-id_page');
        console.groupCollapsed(pageId);
        console.timeStamp('CHECK-IN');
        console.info('Starting CabinetController');
        console.groupEnd(pageId);
        loCabinet.start();
    });

});

/*  EOF: assets/js/cabinet-starter.js  */
