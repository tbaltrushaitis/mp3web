/*  ASSETS/JS/APP/functions.js  */

//  Check if parameter ("intro", "silent", etc.) is Enabled in URL
function checkMode (mode) {
    var aHashParams =   window.location.hash.split('#');
    return (_.indexOf(aHashParams, mode) > -1);
}


function stripFilename (s) {
    return s.substr(s.lastIndexOf('/') + 1);
}


function padl(number, length, symbol) {
    var num =   ('number' !== typeof(number) ? Number(number) : number)
      , len =   (false === !!length || length <= 0 ? 2 : length)
      , sym =   (false === !!symbol ? '0' : symbol)
      , res =   '' + num
    ;
    while (res.length < len) {
        res =   sym + res;
    }
    return res;
}


function sec2time (intParamSecs) {
    //  45296   ->  '12:34:56'
    var strTime =   '00:00:00';
    if ( 'number' === typeof(intParamSecs) && !_.isNaN(intParamSecs) ) {
        var intSecs     =   parseInt( intParamSecs )
          , iHours      =   parseInt( intSecs / 3600 )
          , iMinutes    =   parseInt( (intSecs - iHours * 3600) / 60 )
          , iSeconds    =   parseInt( intSecs - iHours * 3600 - iMinutes * 60 )
        ;
        strTime =   padl(iHours)
                +   ':'
                +   padl(iMinutes)
                +   ':'
                +   padl(iSeconds)
        ;
    }
    return strTime;
}


function genUUID () {
    function s4() {
        return  Math.floor( (1 + Math.random()) * 0x10000 )
                    .toString(16)
                    .substring(1);
    }
    return  s4()
          + s4()
          + '-'
          + s4()
          + '-'
          + s4()
          + '-'
          + s4()
          + '-'
          + s4()
          + s4()
          + s4()
    ;
}

