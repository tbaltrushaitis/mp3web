/*  BOF: assets/js/app/controllers/cabinetController.js  */

define(['jquery', 'underscore', 'Tmpl', 'functions', 'bootstrap'], function ($, _, tmpl, F) {
    'use strict';

    /*
    |--------------------------------------------------------------------------
    |   START CONTROLLER
    |--------------------------------------------------------------------------
    */
    function start () {

        bindEvents();

    }


    function getTrackData (Id) {
        var Modal   =   $('#modalEditTrack');
        var oMeta   =   requestAjax('/' + Id + '/meta');

        Modal.find('.panel-title').text('Edit Track [' + Id + ']');
        Modal.find('#id').val(oMeta.id);
        Modal.find('#filename').val(oMeta.name);
        Modal.find('#path').val(oMeta.path);
        Modal.find('#title').val(oMeta.title);
        Modal.find('#artist').val(oMeta.artist);
        Modal.find('#album').val(oMeta.album);
        Modal.find('#year').val(oMeta.year);
        Modal.find('#meta').text( JSON.stringify(oMeta) );
    }


    function saveTrackData () {
        var Modal   =   $('#modalEditTrack');
        var Id      =   Modal.find('#id').val();
        var oMeta   =   {
            id:     Id
          , title:  Modal.find('#title').val()
          , artist: Modal.find('#artist').val()
          , album:  Modal.find('#album').val()
          , year:   Modal.find('#year').val()
        };

        var saveResult  =   requestAjax('/' + Id + '/meta', oMeta, 'POST');
        // Modal.modal('toggle');
    }


    /*
    |--------------------------------------------------------------------------
    |   EVENTS BINDING
    |--------------------------------------------------------------------------
    */
    function bindEvents () {

        //  EDIT Track in Modal Window
        $('body').delegate('.btn-edit', 'click', function (e) {
            var trackId =   $(e.target).data('id');
            getTrackData(trackId);
        });

        //  SAVE Track metadata
        $('body').delegate('.btn-save', 'click', function (e) {
            saveTrackData();
        });

    }

    return {
        'start': start
    };

});
/*  EOF: assets/js/app/controllers/cabinetController.js  */
