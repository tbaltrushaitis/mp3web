/* ASSETS/JS/APP/CLASSES/Abstract.class.js */

'use strict';

define([
      'jquery'
    , 'underscore'
    , 'functions'
  ]
  , function ($, _, F) {

    //  CONSTRUCTOR
    var Abstract = function () {
      var self         = this
        , dfdClass     = $.Deferred()
        , dfdPrototype = $.Deferred()
        , i            = 0
      ;
      console.groupCollapsed('Abstract.class Constructor');

      // INIT
      dfdPrototype = self._init();

      // Wait while instance initialized
      setTimeout (function working() {
        if ('pending' === dfdPrototype.state()) {
          console.log( '\tLoading ' + self._entity + ' ... ', i++ );
          if (i <= 20) {
            setTimeout (working, 500);
          }
        }
      }, 1);

      $.when(dfdPrototype)
       .done(function (oClass) {
          console.timeStamp('Instance of ' + oClass._entity + ' created');
          console.log('Class ' + oClass._entity + ' Object:', oClass);
          dfdClass.resolve(oClass);
      })
      .always(function (oResult) {
        console.groupEnd('Abstract.class Constructor');
      });

      return dfdClass.promise();
    };

    //  PROTOTYPE
    Abstract.prototype = {

      _defaults: {
        _entity: 'Abstract.class'
      }

    , _config:  new Object()
    , _data:    new Object()

      //  INIT
    , _init:  function () {
        var self = this;
        return self.Init();
      }


      //  INITIALIZATION
    , Init:   function () {
        var self    = this
          , dfdInit = $.Deferred()
          , i       = 0
        ;

        //  Apply DEFAULT class OPTIONS
        var loaded  = $.when( _.extend(self, self._defaults) )
                       .then( function (objSelf) {
                          return objSelf.Load();
                      });

        $.when( loaded )
         .then( function (objSelf) {
            dfdInit.resolve(objSelf);
        });

        setTimeout (function workingInit () {
          if ('pending' === loaded.state()) {
            console.timeStamp('\tInit '  + self._entity + ' ... ', i++);
            if (i <= 20) {
              setTimeout (workingInit, 500);
            }
          }
        }, 1);

        return dfdInit.promise();
      }


      // Load Default Data and Modules
    , Load:   function () {
        var self        =   this
          , dfdMethod   =   $.Deferred()
          , dfdModules  =   $.Deferred();

        dfdModules.resolve(self);
        dfdModules
          .done(function (loSelf) {
            var tStamp  =   {timestamp: (new Date()).getTime()}
              , UUID    =   {UID: F.genUUID()}
            ;
            _.extend(loSelf._config, tStamp, UUID);
            dfdMethod.resolve(loSelf);
          });

        return dfdMethod.promise();
      }

    };

  return Abstract;

});
