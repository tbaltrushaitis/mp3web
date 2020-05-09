/*!
 * ./gulp-tasks/artisan/migrate.js
 * Copyright(c) 2017-nowdays Baltrushaitis Tomas
 * MIT Licensed
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
          .pipe(exec('cd ' + global.ME.CURDIR + global.ME.BUILD + ' && php artisan -vvv --no-interaction migrate && cd -'))
          .pipe(exec.reporter(global.ME.pkg.options.reporting));
};
