/*!
 * ./gulp-tasks/artisan/clear.js
 * Copyright(c) 2017 Baltrushaitis Tomas
 * MIT Licensed
 */

'use strict';

//--------------//
// DEPENDENCIES //
//--------------//

const exec  =   require('gulp-exec');


//--------------//
//  EXPORTS     //
//--------------//

module.exports  =   function (gulp) {
    console.log('module.filename = ' + module.filename);

    return gulp.src('')
            .pipe(exec('cd ' + global.CURDIR + global.WEB + ' && php artisan -vvv view:clear && cd -'))
            .pipe(exec('cd ' + global.CURDIR + global.WEB + ' && php artisan -vvv route:list && cd -'))
            .pipe(exec.reporter(global.pkg.options.reporting));
};

