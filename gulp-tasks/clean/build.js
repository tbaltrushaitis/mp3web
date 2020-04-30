/*!
 * File:        ./gulp-tasks/clean/build.js
 * Copyright(c) 2016-nowdays Baltrushaitis Tomas
 * License:     MIT
 */

'use strict';

//--------------//
// DEPENDENCIES //
//--------------//

const del        = require('del');
const vinylPaths = require('vinyl-paths');


//--------------//
//  EXPORTS     //
//--------------//

module.exports = function (gulp) {
  console.log(`[${new Date().toISOString()}] LOADED: [${module.filename}]`);

  return gulp.src([ME.BUILD]).pipe(vinylPaths(del));
};
