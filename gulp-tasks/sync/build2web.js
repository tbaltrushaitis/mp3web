/*!
 * File:        ./gulp-tasks/sync/build2web.js
 * Copyright(c) 2016-2017 Baltrushaitis Tomas
 * License:     MIT
 */

'use strict';

//--------------//
// DEPENDENCIES //
//--------------//

const dirSync = require('gulp-directory-sync');


//--------------//
//  EXPORTS     //
//--------------//

module.exports = function (gulp) {
  console.log('[' + module.filename + ']');

  return  gulp.src('')
            .pipe(dirSync(ME.BUILD, ME.WEB, ME.pkg.options.sync))
            .on('error', console.error.bind(console));

};
