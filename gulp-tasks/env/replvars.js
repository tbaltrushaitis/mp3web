/*!
 * Project: mp3web
 * File:    ./gulp-tasks/env/replvars.js
 * Author:  Baltrushaitis Tomas <tbaltrushaitis@gmail.com>
 * Created: 2017-12-19T13:28:00
 * Updated: 2017-12-19T13:28:00
 */

'use strict';

/**
 * DEPENDENCIES
 * @private
 */

const path = require('path');
const util = require('util');
const _ = require('lodash');

const buffer = require('vinyl-buffer');
const replace = require('gulp-replace');
const rename = require('gulp-rename');
const concat = require('gulp-concat');

const modName = path.basename(module.filename, '.js');
const modPath = path.relative(global.ME.WD, path.dirname(module.filename));

const modConfigFile = `config/${path.join(modPath, modName)}.json`;
const modConfig = require('read-config')(modConfigFile);

const utin = util.inspect;

//  ------------------------------------------------------------------------  //
//  -------------------------------  EXPOSES  ------------------------------  //
//  ------------------------------------------------------------------------  //

module.exports = function (gulp) {
  console.log(`[${new Date().toISOString()}][${modPath}/${modName}] INSTANCE ACTIVATED with modConfig = [${utin(modConfig)}]`);

  function replaceEnvironmentVariables (stream) {
    for (let cgv in modConfig) {
      let key = cgv.toUpperCase()
        , v   = modConfig[cgv]
      ;
      // v = _.isObject(v) ? v = JSON.stringify(v) : true;
      _.isObject(v) ? v = JSON.stringify(v) : true;

      stream = stream.pipe(replace('{{' + key + '}}', v));
      console.log(`[${new Date().toISOString()}][${modPath}/${modName}] Replace ${key}:\t ${v}`);
    }
    stream = stream.pipe(replace('{{APP_VERSION}}', global.ME.pkg.version));
    return stream;
  };

  let process = gulp.src([
      path.join(global.ME.SRC, `.env.rc.test`)
    ])
    .pipe(buffer());

  process = replaceEnvironmentVariables(process);
  return process.pipe(concat('.env.rc.test.concat'))
          .pipe(gulp.dest(global.ME.BUILD));

};
