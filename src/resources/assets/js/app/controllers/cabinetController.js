/*!
 * File:        ASSETS/JS/APP/CONTROLLERS/cabinetController.js
 * Copyright(c) 2016-nowdays Baltrushaitis Tomas
 * License:     MIT
 */

'use strict';

require([
    'jquery'
  , 'lodash'
  , 'Tmpl'
  , 'bootstrap'
  , 'bootstrapTags'
  , 'functions'
  // , 'LTEapp'
], function ($, _, tmpl, bs, bsTags, F) {
  console.info('CABINET CONTROLLER MODULES READY');
});

define([
    'jquery'
  , 'lodash'
  , 'Tmpl'
  , 'bootstrap'
  , 'bootstrapTags'
  , 'functions'
]
, function ($, _, tmpl, bs, bsTags, F) {

  /*
  |--------------------------------------------------------------------------
  |   START CONTROLLER
  |--------------------------------------------------------------------------
  */

  function start () {
    console.info('CALLED: start()');
    bindEvents();
  }


  /*
  |--------------------------------------------------------------------------
  |   LOAD DATA
  |--------------------------------------------------------------------------
  */
  function loadTrackData (Id) {
    var Modal = $('#modalEditTrack');
    var oMeta = F.requestAjax('/' + Id + '/meta');

    $.when(oMeta)
     .then(function (lo) {

      Modal.find('.panel-title').text('Edit Track [' + Id + ']');
      Modal.find('#id').val(lo.id);
      Modal.find('#filename').val(lo.filename);
      Modal.find('#path').val(lo.path);
      Modal.find('#title').val(lo.title);
      Modal.find('#album').val(lo.album);
      Modal.find('#track').val(lo.track);
      Modal.find('#year').val(lo.year);
      Modal.find('#url-video').val(lo.url_video);

      var elGenres   = Modal.find('#track-genre');
      var elTags     = Modal.find('#track-tags');
      var listGenres = lo.genre;
      var listTags   = lo.tags;
      // console.log('listGenres = [', listGenres, ']');

      elGenres.tagsinput('removeAll');
      elGenres.tagsinput({
          maxTags:         5
        , maxChars:        15
        , trimValue:       true
        , allowDuplicates: false
      });

      elTags.tagsinput('removeAll');
      elTags.tagsinput({
          maxTags:         5
        , maxChars:        15
        , trimValue:       true
        , allowDuplicates: false
      });

      _.each(listGenres, function (tagGenre) {
        // console.info('tagGenre = ', tagGenre);
        elGenres.tagsinput('add', tagGenre);
      });

      _.each(listTags, function (tag) {
        elTags.tagsinput('add', tag);
      });

      // Modal.find('#track-tags')
      //   .val(lo.tags)
      //   .prop({'data-role': 'tagsinput'});

      Modal.find('#meta').text( JSON.stringify(lo) );
    });
  }


  /*
  |--------------------------------------------------------------------------
  |   SAVE DATA
  |--------------------------------------------------------------------------
  */
  function saveTrackData () {
    var Modal = $('#modalEditTrack');
    var Id    = Modal.find('#id').val();
    var oMeta = {
        id:        Id
      , title:     Modal.find('#title').val()
      , name:      Modal.find('#name').val()
      , artist:    Modal.find('#artist').val()
      , album:     Modal.find('#album').val()
      , track:     Modal.find('#track').val()
      , year:      Modal.find('#year').val()
      , genre:     Modal.find('#track-genre').val()
      , url_video: Modal.find('#url-video').val()
      , tags:      Modal.find('#track-tags').val()
    };

    var saveResult = F.requestAjax('/' + Id + '/meta', oMeta, 'POST');
  }


  /*
  |--------------------------------------------------------------------------
  |   RESET FORM FIELDS
  |--------------------------------------------------------------------------
  */
  function resetForm () {
    var Modal = $('#modalEditTrack');

    Modal.find('.panel-title').text('');
    Modal.find('#id').val(null);
    Modal.find('#filename').val(null);
    Modal.find('#path').val(null);
    Modal.find('#title').val(null);
    Modal.find('#album').val(null);
    Modal.find('#track').val(null);
    Modal.find('#year').val(null);
    Modal.find('#track-genre')
      .val('[]')
      .prop({'data-role': 'tagsinput-disabled'});
    Modal.find('#url-video').val(null);
    Modal.find('#track-tags')
      .val('[]')
      .prop({'data-role': 'tagsinput-disabled'});
    Modal.find('#meta').text(null);
  }


  /*
  |--------------------------------------------------------------------------
  |   EVENTS BINDING
  |--------------------------------------------------------------------------
  */
  function bindEvents () {
    var Modal = $('#modalEditTrack');

    //  EDIT Track in Modal Window
    $('body').delegate('.btn-edit', 'click', function (e) {
      var trackId = $(e.currentTarget).data('id');
      // console.log('trackId =', trackId);
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
