/*!
 * ./gulp-tasks/sync/build2dist.js
 * Copyright(c) 2017 Baltrushaitis Tomas
 * MIT Licensed
 */

'use strict';

//--------------//
// DEPENDENCIES //
//--------------//

const path      =   require('path');
const dirSync   =   require('gulp-directory-sync');


//--------------//
//  EXPORTS     //
//--------------//

module.exports  =   function (gulp) {
    console.log('[' + module.filename + ']');

    return  gulp.src('')
                .pipe(dirSync(BUILD, DIST, global.pkg.options.sync))
                .on('error', console.error.bind(console));

};

