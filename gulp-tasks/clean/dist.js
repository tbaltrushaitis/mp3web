/*!
 * ./gulp-tasks/clean/build.js
 * Copyright(c) 2016-2017 Baltrushaitis Tomas
 * MIT Licensed
 */

'use strict';

//--------------//
// DEPENDENCIES //
//--------------//

const del           =   require('del');
const vinylPaths    =   require('vinyl-paths');


//--------------//
//  EXPORTS     //
//--------------//

module.exports  =   function (gulp) {
    console.log('module.filename = ' + module.filename);

    return  gulp.src([global.DIST]).pipe(vinylPaths(del));

};

