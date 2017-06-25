/*!
 * ./gulp-tasks/sync/src2build.js
 * Copyright(c) 2016-2017 Baltrushaitis Tomas
 * MIT Licensed
 */

'use strict';

//--------------//
// DEPENDENCIES //
//--------------//

const dirSync   =   require('gulp-directory-sync');


//--------------//
//  EXPORTS     //
//--------------//

module.exports  =   function (gulp) {
    console.log('module.filename = ' + module.filename);

    return  gulp.src('')
                .pipe(dirSync(
                    SRC
                  , BUILD
                  , global.pkg.options.sync)
                )
                .on('error', console.error.bind(console));

};

