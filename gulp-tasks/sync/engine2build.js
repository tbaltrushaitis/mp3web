/*!
 * File:        ./gulp-tasks/sync/engine2build.js
 * Copyright(c) 2016-2017 Baltrushaitis Tomas
 * Licensed:    MIT
 */

'use strict';

//--------------//
// DEPENDENCIES //
//--------------//

const _       = require('lodash');
const dirSync = require('gulp-directory-sync');


//--------------//
//  EXPORTS     //
//--------------//

module.exports = function (gulp) {
  console.log(`LOADED: [${module.filename}]`);

  return  gulp.src('')
            .pipe(dirSync(
                ME.ENGINE
              , ME.BUILD
              , _.extend({}, ME.pkg.options.sync, {ignore: [
                    /^\.env(.*)?$/i
                  , /^(.*)\.md$/i
                  , /^(.*)\.lock$/i
                ]})
            ))
            .on('error', console.error.bind(console));

};
