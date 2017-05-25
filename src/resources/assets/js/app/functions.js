/*  ASSETS/JS/APP/functions.js  */

/*!
 * ASSETS/JS/APP/functions.js
 * Copyright(c) 2016-2017 Baltrushaitis Tomas
 * MIT Licensed
 */

'use strict';


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
    if ('number' === typeof(intParamSecs) && !_.isNaN(intParamSecs)) {
        var intSecs     =   parseInt(intParamSecs, 10)
          , iHours      =   parseInt(intSecs / 3600, 10)
          , iMinutes    =   parseInt((intSecs - iHours * 3600) / 60, 10)
          , iSeconds    =   parseInt(intSecs - iHours * 3600 - iMinutes * 60, 10)
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


/*
|--------------------------------------------------------------------------
|   SEND AJAX REQUEST
|--------------------------------------------------------------------------
*/

function requestAjax (loUrl, loData, loType) {
    var resp = $.ajax({
        async:      false
      , data:       loData || {}
      , timeout:    10000
      , type:       loType || 'GET'
      , dataType:   'json'
      , url:        loUrl
      , beforeSend: function(req) {
            //console.log("AJAX beforeSend req = ");
            req.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        }
      , success:    function (data) {
            if (data.errorStatus) {
                console.warn(data.errorMsg || 'An error has occurred');
            }else{
                return data;
            }
        }
      , error:  function () {
            console.error('An error has occurred');
        }
    });

    try {
        var retResult   =   JSON.parse(resp.responseText);
        return retResult;
    }catch (err) {
        console.error('[ERROR] Cannot parse responseText = [', err, ']');
    }

    return {
        error:      true
      , message:    'Cannot get data from URL=[' + url + ']'
    };

}

