/*  BOF: assets/js/app/controllers/cabinetController.js  */

define(['jquery', 'underscore', 'Tmpl', 'functions', 'bootstrapTags', 'bootstrap']
  , function ($, _, tmpl, F, bsTags) {

    'use strict';

    /*
    |--------------------------------------------------------------------------
    |   START CONTROLLER
    |--------------------------------------------------------------------------
    */
    function start () {
        bindEvents();
    }


    /*
    |--------------------------------------------------------------------------
    |   LOAD DATA
    |--------------------------------------------------------------------------
    */
    function loadTrackData (Id) {
        var Modal   =   $('#modalEditTrack');
        var oMeta   =   requestAjax('/' + Id + '/meta');

        Modal.find('.panel-title').text('Edit Track [' + Id + ']');
        Modal.find('#id').val(oMeta.id);
        Modal.find('#filename').val(oMeta.name);
        Modal.find('#path').val(oMeta.path);
        Modal.find('#title').val(oMeta.title);
        Modal.find('#name').val(oMeta.name);
        Modal.find('#artist').val(oMeta.artist);
        Modal.find('#album').val(oMeta.album);
        Modal.find('#track').val(oMeta.track);
        Modal.find('#year').val(oMeta.year);
        Modal.find('#track-genre')
            .val(oMeta.genre)
            .prop({'data-role': 'tagsinput'});
        Modal.find('#track-tags')
            .val(oMeta.tags)
            .prop({'data-role': 'tagsinput'});
        Modal.find('#meta').text( JSON.stringify(oMeta) );
    }


    /*
    |--------------------------------------------------------------------------
    |   SAVE DATA
    |--------------------------------------------------------------------------
    */
    function saveTrackData () {
        var Modal   =   $('#modalEditTrack');
        var Id      =   Modal.find('#id').val();
        var oMeta   =   {
                id:     Id
              , title:  Modal.find('#title').val()
              , name:   Modal.find('#name').val()
              , artist: Modal.find('#artist').val()
              , album:  Modal.find('#album').val()
              , track:  Modal.find('#track').val()
              , year:   Modal.find('#year').val()
              , genre:  Modal.find('#track-genre').val()
              , tags:   Modal.find('#track-tags').val()
            };

        var saveResult  =   requestAjax('/' + Id + '/meta', oMeta, 'POST');
    }


    /*
    |--------------------------------------------------------------------------
    |   RESET FORM FIELDS
    |--------------------------------------------------------------------------
    */
    function resetForm () {
        var Modal   =   $('#modalEditTrack');

        Modal.find('.panel-title').text('');
        Modal.find('#id').val(null);
        Modal.find('#filename').val(null);
        Modal.find('#path').val(null);
        Modal.find('#title').val(null);
        Modal.find('#name').val(null);
        Modal.find('#artist').val(null);
        Modal.find('#album').val(null);
        Modal.find('#track').val(null);
        Modal.find('#year').val(null);
        Modal.find('#track-genre')
            .val('')
            .prop({'data-role': 'tagsinput-disabled'});
        Modal.find('#track-tags')
            .val('')
            .prop({'data-role': 'tagsinput-disabled'});
        Modal.find('#meta').text(null);
    }


    /*
    |--------------------------------------------------------------------------
    |   EVENTS BINDING
    |--------------------------------------------------------------------------
    */
    function bindEvents () {
        var Modal   =   $('#modalEditTrack');

        //  EDIT Track in Modal Window
        $('body').delegate('.btn-edit', 'click', function (e) {
            var trackId =   $(e.target).data('id');
            loadTrackData(trackId);
        });

        //  SAVE Track metadata
        $('body').delegate('.btn-save', 'click', function (e) {
            saveTrackData();
        });

        //  RESET Track Edit form
        Modal.on('hidden.bs.modal', function (e) {
            resetForm();
        });

    }

    return {
        'start': start
    };

});
/*  EOF: assets/js/app/controllers/cabinetController.js  */
