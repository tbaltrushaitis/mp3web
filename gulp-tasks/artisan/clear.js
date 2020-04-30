/*!
 * File:        ./gulp-tasks/artisan/clear.js
 * Copyright(c) 2016-nowdays Baltrushaitis Tomas
 * License:     MIT
 */

'use strict';

//--------------//
// DEPENDENCIES //
//--------------//

const exec = require('gulp-exec');


//--------------//
//  EXPORTS     //
//--------------//

module.exports = function (gulp) {
  console.log(`[${new Date().toISOString()}] LOADED: [${module.filename}]`);

  return gulp.src('')
          .pipe(exec('cd ' + ME.CURDIR + ME.WEB + ' && php artisan -vvv --no-interaction view:clear && cd -'))
          .pipe(exec('cd ' + ME.CURDIR + ME.WEB + ' && php artisan -vvv --no-interaction route:list && cd -'))
          .pipe(exec.reporter(ME.pkg.options.reporting));
};
