/*!
 * ./gulp-tasks/sync/assets.js
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
    console.log('module.filename = ' + module.filename);

    return  gulp.src('')
                .pipe(dirSync(
                    path.join(BUILD, 'resources/assets')
                  , path.join(BUILD, 'public/assets')
                  , global.pkg.options.sync
                ))
                .on('error', console.error.bind(console));
};

