/*!
 * ./gulp-tasks/sync/build2web.js
 * Copyright(c) 2017 Baltrushaitis Tomas
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
    console.log('[' + module.filename + ']');

    return  gulp.src('')
                .pipe(dirSync(BUILD, WEB, global.pkg.options.sync))
                .on('error', console.error.bind(console));

};

