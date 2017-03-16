/* ASSETS/JS/APP/App_Starter.js */

'use strict';

require([
        'jquery'
      , 'underscore'
      , 'raty'
      , 'Player'
      , 'bootstrapTags'
      , 'functions'
      , 'bootstrap'
    ]
  , function (
        $
      , _
      , raty
      , PlayerClass
      , bsTags
    ) {

    var Player  =   new PlayerClass ();
    var silent  =   checkMode ('silent');
    var intro   =   checkMode ('intro');

    Player.Populate();

    $(Player._config.tracks.container).find('a').click(function (e) {
        e.stopImmediatePropagation();
        e.preventDefault();
        var link    =   $(this);
        Player.Play(link);
    });

    $('.raty').each(function (idx, el) {
        var that    =   $(this)
          , score   =   that.attr('data-score')
        ;
        that.raty({
            score:      score
          , readOnly:   true
          , path:       'assets/js/plugins/raty/images'
        });
    });

    // RATE
    $('.btn-rate').click(function (e) {
        e.stopImmediatePropagation();
        var Rate    =   $(this).attr('data-rate');
        Player.Rate(Rate);
        e.preventDefault();
    });

    // TEST
    $('#btn-control-test').click(function (e) {
        e.stopImmediatePropagation();
        var Instance    =   Player._data.instance
          , textTracks  =   Instance.textTracks
        ;

        console.log('Instance:\t',                  Instance);
        console.log('Instance.duration:\t',         Instance.duration);
        console.log('Instance.textTracks:\t',       Instance.textTracks);
        console.log('Instance.audioTracks:\t',      Instance.audioTracks);
        console.log('Instance.textTracks.length:\t',    Instance.textTracks.length);
        console.log('Instance.mediaGroup:\t',       Instance.mediaGroup);

        e.preventDefault();
    });

    $('#btn-control-play').click(function (e) {
        e.stopImmediatePropagation();
        e.preventDefault();
        var self        =   $(this)
          , Instance    =   Player._data.instance
        ;
        self.toggleClass('playing');
        if (self.hasClass('playing')) {
            if (true === Instance.paused) {
                Player.Resume();
            }else{
                Player.stepForward();
            }
        }else{
            Player.Pause();
        }
    });

    $('#btn-control-backward').click(function (e) {
        e.stopImmediatePropagation();
        e.preventDefault();
        Player.stepBackward();
    });

    $('#btn-control-forward').click(function (e) {
        e.preventDefault();
        Player.stepForward();
    });

    $('.btn-player-option').click(function (e) {
        e.preventDefault();
        $(this).toggleClass('is-enabled')
            .toggleClass('active');
    });


    // START Parameters
    if (silent) {
        return false;
    }

    if (intro) {
        setTimeout (function PlayIntro () {
            Player.stepForward();
            setTimeout ( PlayIntro, 5000);
        }, 100);
    } else {
        Player.stepForward();
    }

    //(silent) ? false : Player.stepForward();

    //var elTags  =   $('[data-role="tagsinput"]');
    //elTags.bsTags('add', { "value": 1 , "text": "Amsterdam"   , "continent": "Europe"});

})();
