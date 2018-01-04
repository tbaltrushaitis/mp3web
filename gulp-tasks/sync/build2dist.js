/*!
 * File:        ./gulp-tasks/sync/build2dist.js
 * Copyright(c) 2016-2017 Baltrushaitis Tomas
 * License:     MIT
 */

'use strict';

//--------------//
// DEPENDENCIES //
//--------------//

const path    = require('path');
const dirSync = require('gulp-directory-sync');


//--------------//
//  EXPORTS     //
//--------------//

module.exports = function (gulp) {
  console.log(`LOADED: [${module.filename}]`);

  return  gulp.src('')
            .pipe(dirSync(ME.BUILD, ME.DIST, ME.pkg.options.sync))
            .on('error', console.error.bind(console));

};
