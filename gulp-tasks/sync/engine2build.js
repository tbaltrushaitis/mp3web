/*!
 * ./gulp-tasks/sync/engine2build.js
 * Copyright(c) 2016-2017 Baltrushaitis Tomas
 * MIT Licensed
 */

'use strict';

//--------------//
// DEPENDENCIES //
//--------------//

const _             =   require('lodash');
const dirSync       =   require('gulp-directory-sync');


//--------------//
//  EXPORTS     //
//--------------//

module.exports  =   function (gulp) {
    console.log('module.filename = ' + module.filename);

    return  gulp.src('')
                .pipe(dirSync(
                    ENGINE
                  , BUILD
                  , _.extend({}, global.pkg.options.sync, {ignore: [
                        /^\.env(.*)?$/i
                      , /^(.*)\.md$/i
                      , /^(.*)\.lock$/i
                    ]})
                ))
                .on('error', console.error.bind(console));

};

