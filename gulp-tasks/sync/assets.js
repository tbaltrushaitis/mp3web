/*!
 * File:        ./gulp-tasks/sync/assets.js
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
            .pipe(dirSync(
                path.join(ME.BUILD, 'resources/assets')
              , path.join(ME.BUILD, 'public/assets')
              , ME.pkg.options.sync
            ))
            .on('error', console.error.bind(console));
};
