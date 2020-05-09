/*!
 * File:        ./gulp-tasks/sync/assets2public.js
 * Copyright(c) 2016-2017 Baltrushaitis Tomas
 * License:     MIT
 */

'use strict';

//--------------//
// DEPENDENCIES //
//--------------//

const path = require('path');

const merge   = require('merge-stream');
const changed = require('gulp-changed');


//--------------//
//  EXPORTS     //
//--------------//

module.exports = function (gulp) {
  console.log(`[${new Date().toISOString()}] LOADED: [${module.filename}]`);

  let DEST        = path.join(ME.BUILD, 'public');
  let DEST_ASSETS = path.join(DEST,     'assets');

  let resAssets = gulp.src([
                    path.join(ME.BUILD, 'resources/assets', '*.*')
                  ])
                  .pipe(changed(DEST_ASSETS))
                  .pipe(gulp.dest(DEST_ASSETS))
                  .on('error', console.error.bind(console));

  let resStuff  = gulp.src([
                      path.join(ME.BUILD, 'resources', '*.*')
                    , path.join(ME.BUILD, 'resources', '.*')
                  ])
                  .pipe(changed(DEST))
                  .pipe(gulp.dest(DEST))
                  .on('error', console.error.bind(console));

  return merge(resAssets, resStuff);
};
