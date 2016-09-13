/*  BOF: assets/js/cabinet-starter.js  */

require(['jquery', 'underscore', 'cabinetController', 'functions']
  , function ($, _, cc, F) {
    'use strict';
    console.timeStamp('MODULES READY');
});

define(['jquery', 'underscore', 'cabinetController', 'functions']
  , function ($, _, cc, F) {
    'use strict';

    var ControllerCabinet   =   cc;

    $.when(ControllerCabinet, F)
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
