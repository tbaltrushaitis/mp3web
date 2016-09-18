/* ASSETS/JS/APP/CLASSES/Player.class.js */

'use strict';

define([
    'jquery'
  , 'underscore'
  , 'Abstract'
  , 'functions'
    ]
  , function (
        $
      , _
      , Abstract
  ) {

    //  CONSTRUCTOR
    var Player  =   function () {
            var self    =   this;
            Abstract.call(self);
        };

    //  PROTOTYPE
    Player.prototype    =   Object.create(Abstract.prototype);
    Player.prototype.constructor =   Player;

    Player.prototype._defaults  =   {
        _entity: 'Audio_Player'
      , _config: {
            selector: 'audio#player'
          , random: null
          , repeat: null
          , volume: 1.00
          , tracks: {
                container: '#tracklist'
              , selector:  'li a'
            }
          , states: {
                playing: {
                    action:   'Pause'
                  , icon:     'fa-pause'
                  , progress: 'active'
                  , title:    'Pause'
                }
              , paused: {
                    action:   'Resume'
                  , icon:     'fa-play'
                  , progress: ''
                  , title:    'Resume'
                }
              , stopped: {
                    action:   'Play'
                  , icon:     'fa-play'
                  , progress: ''
                  , title:    'Play'
                }
            }
        }
      , _data: {
            instance: {}
          , tracks: {
                current: -1
              , list: []
            }
        }
    };

    Player.prototype.Populate   =   function () {
        var self = this;

        self._data.instance         =   $(self._config.selector)[0];
        self._data.instance.volume  =   self._config.volume;

        $(self._config.tracks.container)
            .find(self._config.tracks.selector)
            .each( function (idx, el) {
                self._data.tracks.list.push( $(el).attr('href') );
            });
        $('#files-count').text(self._data.tracks.list.length);

        self._data.instance.addEventListener('play',    self.setButtonPlay.bind(this),  false);
        self._data.instance.addEventListener('pause',   self.setButtonPause.bind(this), false);
        self._data.instance.addEventListener('ended',   self.stepForward.bind(this), false);

        self._data.instance.addEventListener('canplay',     self.initCounters, false);
        self._data.instance.addEventListener('timeupdate',  self.checkTimeLeft, false);

        return self;
    };

    Player.prototype.Play   =   function (link) {
        var self        =   this
          , Instance    =   self._data.instance
          , trackHash   =   link.attr('href')
          , trackName   =   link.text()
          , trackDom    =   link.parent()
        ;

        var requestUrl  =   window.location.protocol
                        +   '//'
                        +   window.location.host
                        +   '/'
                        +   trackHash
          , oRequest    =   $.ajax({
                                url:     requestUrl
                              , type:    'GET'
                              , timeout: 5000
                            });

        oRequest
            .done( function (loResponse) {
                // console.log('Play Response:\t', loResponse);

                Instance.src  =   loResponse.url;
                Instance.load();
                Instance.play();

                self._data.tracks.current   =   trackDom.index();
                $('#data-current-src').text(trackName);
                $('#info-rank-like').text(loResponse.likes || 0);
                $('#info-rank-dislike').text(loResponse.dislikes || 0);
                $('#info-plays').text(loResponse.plays || 0);

                trackDom
                    .find('i')
                    .addClass('fa-spinner fa-pulse')
                    .end()
                    .addClass('active')
                    .siblings()
                    .removeClass('active')
                    .find('i')
                    .removeClass('fa-spinner')
                    .removeClass('fa-pulse')
                    .addClass('fa-volume-off');

                //  Move Track To Top of List
                var domParent   =   trackDom.parent()
                  , trackClone  =   trackDom.clone();
                trackDom.addClass('animated slideOutUp').delay(1500).remove();
                domParent.prepend(trackClone.addClass('animated slideInUp'));
            })
            .fail( function (loError) {
                console.warn('Error loading media:\t', loError);
            });

        return self;
    };

    Player.prototype.Pause  =   function () {
        var self        =   this
          , Instance    =   self._data.instance;
        Instance.pause();
        return self;
    };

    Player.prototype.Resume =   function () {
        var self        =   this
          , Instance    =   self._data.instance;
        Instance.play();
        return self;
    };

    Player.prototype.stepBackward   =   function () {
        var self = this;
        return self;
    };

    Player.prototype.stepForward    =   function () {
        var self    =   this
          , current =   self._data.tracks.current
          , len     =   self._data.tracks.list.length;

        self._config.random =   $('#btn-option-random').hasClass('is-enabled');
        self._config.repeat =   $('#btn-option-repeat').hasClass('is-enabled');

        if (true === !!self._config.repeat) {
            //self._data.instance.loop    =   true;
        }else if (self._config.random) {
            current =   parseInt(Math.random() * len, 10);
        }else{
            current++;
        }

        if (current === len) {
            current =   0;
        }
        self._data.tracks.current   =   current;

        var link    =   $(self._config.tracks.container).find('a')[current];
        self.Play( $(link) );

        return self;
    };

    Player.prototype.checkTimeLeft  =   function () {
        var secRemain   =   parseInt(this.duration - this.currentTime, 10)
          , strTime     =   sec2time(secRemain)
          , percDone    =   parseInt(this.currentTime * 100 / this.duration, 10)
        ;
        $('#data-time-remain').text(strTime);
        $('#data-current-progress').attr({
                'aria-valuenow':    this.currentTime
              , 'style':            'width: ' + percDone + '%'
            })
        ;
        return strTime;
    };

    Player.prototype.resetToolbar   =   function () {
        var self        =   this
          , btnPlay     =   $('#btn-control-play')
          , domProgress =   $('#data-current-progress').parent()
        ;
        // Clean Properties
        for (var state in self._config.states) {
            btnPlay
                .removeClass(state)
                .children('i')
                    .removeClass(self._config.states[state]['icon'])
            ;
            domProgress
                .removeClass(self._config.states[state]['progress'])
            ;
        }
        return self;
    };

    Player.prototype.setButtonPlay  =   function () {
        var self    =   this;
        self.setButtonState('playing');
        return self;
    };

    Player.prototype.setButtonPause =   function () {
        var self    =   this;
        self.setButtonState('paused');
        return self;
    };

    Player.prototype.setButtonState =   function (pState) {
        var self        =   this
          , btnPlay     =   $('#btn-control-play')
          , domProgress =   $('#data-current-progress');

        // Clean Properties
        self.resetToolbar();
        // Set Properties
        btnPlay
            .attr({
                'aria-label': self._config.states[pState]['title']
              , 'title':      self._config.states[pState]['title']
            })
            .addClass(pState)
            .children('i')
                .addClass(self._config.states[pState]['icon'])
        ;
        domProgress
            .parent()
            .addClass(self._config.states[pState]['progress'])
        ;
        return self;
    };

    Player.prototype.initCounters   =   function () {
        $('#data-current-progress').attr({
            'aria-valuemin': 0
          , 'aria-valuemax': this.duration
          , 'aria-valuenow': 0
        });
    };

    Player.prototype.setDuration    =   function () {
        $('#data-current-progress').attr({
            'aria-valuemax': this.duration
        });
    };

    Player.prototype.Rate   =   function (Rank) {
        var self        =   this
          , Instance    =   self._data.instance
          , Hash        =   self._data.tracks.list[self._data.tracks.current]
          , rankHolder  =   $('#info-rank-' + Rank)
          , rankCount   =   parseInt(rankHolder.text(), 10)
          , actionUrl   =   'rate/' + Hash + '/' + Rank
        ;

        var requestUrl  =   window.location.protocol
                        +   '//'
                        +   window.location.host
                        +   '/'
                        +   actionUrl
          , oRequest    =   $.ajax({
                                url:    requestUrl
                              , type:   'POST'
                              , data: {
                                    hash:   Hash
                                  , action: Rank
                                  , _token: $('meta[name="csrf-token"]').attr('content')
                                }
                              , timeout:    5000
                              , beforeSend: function () {
                                    rankHolder.addClass('animated rotateIn rotateOut');
                                }
                            });

        oRequest
            .done( function (loResponse) {
                if ('SUCCESS' === loResponse.action_result) {
                    ++rankCount;
                }
            })
            .fail( function (loError) {
                console.warn('Error changing Rate:\t', loError);
            })
            .always( function () {
                rankHolder.text(rankCount).removeClass('rotateOut');
            });

        return self;
    };

    return Player;

});
