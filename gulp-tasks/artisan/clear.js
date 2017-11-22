/*!
 * File:        ./gulp-tasks/artisan/clear.js
 * Copyright(c) 2016-2017 Baltrushaitis Tomas
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
  console.log('module.filename = ' + module.filename);

  return gulp.src('')
          .pipe(exec('cd ' + ME.CURDIR + ME.WEB + ' && php artisan -vvv view:clear && cd -'))
          .pipe(exec('cd ' + ME.CURDIR + ME.WEB + ' && php artisan -vvv route:list && cd -'))
          .pipe(exec.reporter(ME.pkg.options.reporting));
};
