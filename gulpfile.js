/*  BOF: ROOT/gulpfile.js  */

/*!
 * ./gulpfile.js
 * Copyright(c) 2016-2017 Baltrushaitis Tomas
 * MIT Licensed
 */

'use strict';

//##  Make sure that jQuery included  ##//
const $         =   require('jquery');
const _         =   require('lodash');

const fs        =   require('fs');
const del       =   require('del');
const path      =   require('path');
const util      =   require('util');
const merge     =   require('merge-stream');

const parseArgs         =   require('minimist');
const vinylPaths        =   require('vinyl-paths');
const dateFormat        =   require('dateformat');
const mainBowerFiles    =   require('main-bower-files');

const gulp          =   require('gulp');
const aglio         =   require('gulp-aglio');
const changed       =   require('gulp-changed');
const chmod         =   require('gulp-chmod');
const chown         =   require('gulp-chown');
const concat        =   require('gulp-concat');
const cleanCSS      =   require('gulp-clean-css');
const concatCSS     =   require('gulp-concat-css');
const minifyCSS     =   require('gulp-minify-css');
const dirSync       =   require('gulp-directory-sync');
const exec          =   require('gulp-exec');
const filter        =   require('gulp-filter');
const gulpif        =   require('gulp-if');
const header        =   require('gulp-header');
const headfoot      =   require('gulp-headerfooter');
const jscs          =   require('gulp-jscs');
const jshint        =   require('gulp-jshint');
const stylish       =   require('jshint-stylish');
const rename        =   require('gulp-rename');
const template      =   require('gulp-template');
const uglify        =   require('gulp-uglify');
const gulpSequence  =   require('gulp-sequence');

const Config    =   require('nconf');
const pkg       =   require('./package.json');
const ENGINE    =   path.join('laravel-5.2');
const BOWER     =   JSON.parse(fs.readFileSync('./.bowerrc')).directory;

const SRC       =   path.join('src');
const BUILD     =   path.join('build', path.sep);
const DIST      =   path.join('dist');
const WEB       =   path.join('webroot', path.sep);
const CURDIR    =   path.join(__dirname, path.sep);

const bowerOptions  =   _.extend({}, pkg.options.bower);
const cleanOptions  =   _.extend({}, pkg.options.clean);
const execOptions   =   _.extend({}, pkg.options.exec);
const fileOptions   =   _.extend({}, pkg.options.file);
const minifyOptions =   _.extend({}, pkg.options.minify);
const reportOptions =   _.extend({}, pkg.options.reporting);
const syncOptions   =   _.extend({}, pkg.options.sync);
const uglifyOptions =   _.extend({}, pkg.options.uglify);
const watchOptions  =   _.extend({}, pkg.options.watch);

const VERSION   =   fs.readFileSync('./VERSION', fileOptions).trim();
const COMMIT    =   fs.readFileSync('./COMMIT', fileOptions).trim();

var now     =   new Date();
var headerTpl   =   _.template( '\n/*!\n'
                              + ' * Package:\t <%= pkg.name %>@<%= pkg.version %>' + '\n'
                              + ' * Name:\t <%= pkg.title %> \n'
                              + ' * Version:\t ' + VERSION + '\n'
                              + ' * Commit:\t ' + COMMIT + '\n'
                              + ' * Description:\t <%= pkg.description %>' + '\n'
                              + ' * Built:\t ' + dateFormat(now, 'yyyy-mm-dd HH:MM:ss') + '\n'
                              + ' * Copyright:\t ' + '2016 - ' + dateFormat(now, 'yyyy') + ' <%= pkg.author.name %>' + '\n'
                              + ' * Visit:\t <%= pkg.homepage %>' + '\n'
                              + '**/\n\n'
                    );
var footerTpl   =   _.template( '\n\n/*!\n'
                              + ' * EOF: <%= pkg.name %> v<%= pkg.version %>: <%= pkg.title %>' + '\n'
                              + ' * Commit:\t ' + COMMIT + '\n'
                              + ' */\n'
                    );

const   Banner  =   {
            header: headerTpl({pkg: pkg})
          , footer: footerTpl({pkg: pkg})
        };

var envConfig = {
    string:     'env'
  , default:    {env: process.env.NODE_ENV || 'test'}
};
envConfig   =   parseArgs(process.argv.slice(2), envConfig);

console.log('\n\n\n');
console.log('envConfig = [', util.inspect(envConfig), ']');
console.log('NODE_ENV = [', util.inspect(envConfig.env), ']');
console.log('VERSION = [', util.inspect(VERSION), ']');
console.log('COMMIT = [', util.inspect(COMMIT), ']');
console.log('\n\n\n');

//  ENV ROUTER
gulp.task('default', function () {

    //  DEFAULT Scenario Route
    (function () {
        switch (envConfig.env) {
            case 'test': {
                gulpSequence('lint');
                break;
            }
            case 'dev': {
                //gulpSequence('clean:build', 'build:dev', 'deploy', 'watch')();
                gulpSequence('build:dev', 'watch')();
                break;
            }
            case 'production': {
                //gulpSequence('test', 'build', 'dist', 'deploy')();
                //gulpSequence(['clean'], ['sync:engine'], ['sync:src'], ['sync:assets'], ['lint'], ['bower'], ['fixPermissions'])();
                gulpSequence('build')();
                break;
            }
            default: {
                // gulpSequence('test', 'show:config', 'watch')();
                gulpSequence('usage')();
                break;
            }
        }
    })();

});

gulp.task('test',       gulpSequence(['jscs'], ['usage']));
gulp.task('lint',       gulpSequence('jscs', 'jshint'));
gulp.task('clean',      gulpSequence(['clean:build', 'clean:dist']));

gulp.task('artisan',    gulpSequence('artisan:vendor:publish', 'artisan:migrate', 'artisan:clear'));

gulp.task(  'build:dev',  gulpSequence(
    'clean:build'
  , 'sync:engine'
  , 'sync:src'
  , 'artisan:key:generate'
  , 'bower'
  , 'sync:resources'
  , 'sync:assets'
  , ['build:css', 'build:js']
));

gulp.task('build',      gulpSequence(
                            'clean:build'
                          , 'sync:engine'
                          , 'sync:src'
                          , 'artisan:key:generate'
                          , 'bower'
                          , 'sync:resources'
                          , 'sync:assets'
                          , ['build:css', 'build:js']
                        ));
gulp.task('dist',       gulpSequence(['clean:dist'], ['sync:dist']));
gulp.task('deploy',     gulpSequence('sync:web', 'artisan:clear'));
gulp.task('watch',      gulpSequence('watch:src:views', 'watch:src:css', 'watch:src:js'));


//  BOWER
gulp.task('bower', function () {

    var mBower      =   mainBowerFiles(bowerOptions, {base: BOWER});   //  , {base: BOWER}

    var DEST    =   path.join(BUILD, 'public/assets');
    //var KEEP    =   path.join(BUILD, 'resources/bower');
    var KEEP    =   path.join(BUILD, 'resources/assets');
    var JS      =   path.join('js/lib');
    var CSS     =   path.join('css');
    var FONT    =   path.join('fonts');
    var IMG     =   path.join('img');

    var bowerJS =   gulp.src(mBower)
                        .pipe(filter([
                            '**/*.js'
                          //, '!**/require.js'
                          , '!**/*.min.js'
                          , '!**/npm.js'
                        ]))
                        .pipe(changed(path.resolve(KEEP, JS)))
                        .pipe(gulp.dest(path.resolve(KEEP, JS)))
                        .pipe(gulp.dest(path.resolve(DEST, JS)))
                        .pipe(gulpif('production' === envConfig.env, uglify(uglifyOptions)))
                        .pipe(concat('bower-bundle.js'))
                        //.pipe(header(Banner.header, {pkg: pkg}))
                        .pipe(headfoot.header(Banner.header))
                        .pipe(headfoot.footer(Banner.footer))
                        .pipe(rename({suffix: minifyOptions.suffix}))
                        .pipe(gulp.dest(path.resolve(DEST, JS)));

    var bowerCSS    =   gulp.src(mBower)
                            .pipe(filter([
                                '**/*.css'
                              , '!**/*.min.css'
                              //, "!**/AdminLTE-*.css"
                              , "!**/skin-*.css"
                            ]))
                            .pipe(changed(path.resolve(KEEP, CSS)))
                            .pipe(gulpif('production' === envConfig.env, cleanCSS(cleanOptions, function (d) {
                                console.info(d.name + ':\t' + d.stats.originalSize + '\t->\t' + d.stats.minifiedSize + '\t[' + d.stats.timeSpent + 'ms]\t[' + 100 * d.stats.efficiency.toFixed(2) + '%]');
                            }), false))
                            // Writing minified version.
                            .pipe(gulp.dest(path.resolve(KEEP, CSS)))
                            .pipe(concatCSS('bower-bundle.css', {rebaseUrls: true}))
                            .pipe(minifyCSS())
                            //.pipe(header(Banner.header, {pkg: pkg}))
                            .pipe(headfoot.header(Banner.header))
                            .pipe(headfoot.footer(Banner.footer))
                            .pipe(rename({suffix: minifyOptions.suffix}))
                            .pipe(gulp.dest(path.resolve(DEST, CSS)));

    var bowerFonts  =   gulp.src(mBower)
                            .pipe(filter(['**/fonts/**/*.*']))
                            //.pipe(changed(path.resolve(DEST, FONT)))
                            .pipe(vinylPaths(function (paths) {
                                //console.info('FONT Paths:', paths);
                                return Promise.resolve();
                            }))
                            .pipe(gulp.dest(path.resolve(DEST, FONT)));

    var bowerImg    =   gulp.src(mBower)
                            .pipe(filter([
                                '**/img/*.*'
                              , '**/image/*.*'
                              , '**/images/*.*'
                              , '**/*.png'
                              , '**/*.jpg'
                              , '**/*.jpeg'
                              , '**/*.gif'
                              , '**/*.ico'
                            ]))
                            .pipe(changed(path.resolve(DEST, IMG)))
                            .pipe(gulp.dest(path.resolve(DEST, IMG)));

    return  merge(bowerJS, bowerCSS, bowerFonts, bowerImg);
});

//  WATCHERS
gulp.task('watch:src:views', function () {
    var wViews  =   gulp.watch([
                            path.join(SRC, 'resources/views', '**/*.blade.php')
                        ]
                      , watchOptions
                      , function () {
                            gulpSequence('sync:src', 'sync:web', 'artisan:clear')();
                    });
    wViews.on('change', function (event) {
        console.info('View ' + event.path + ' was ' + event.type + ', running tasks...');
    });
});

gulp.task('watch:src:css', function () {
    var wCSS    =   gulp.watch([
                        path.join(SRC, 'resources/assets/css', '**/*.css')
                    ]
                  , watchOptions
                  , function () {
                        gulpSequence('sync:src', 'sync:resources', 'build:css', 'sync:web')();
                    });
    wCSS.on('change', function (event) {
        console.info('CSS ' + event.path + ' was ' + event.type + ', running tasks...');
    });
});

gulp.task('watch:src:js', function () {
    var wScripts    =   gulp.watch([path.join(SRC, 'resources/assets/js', '**/*.js')]
                      , watchOptions
                      , function () {
                            gulpSequence('sync:src', 'sync:resources', 'lint', 'build:js', 'sync:web')();
                        });
    wScripts.on('change', function (event) {
        console.info('JS ' + event.path + ' was ' + event.type + ', running tasks...');
    });
});


//  CLEAN
gulp.task('clean:build', function () {
    return  gulp.src([BUILD]).pipe(vinylPaths(del));
});
gulp.task('clean:dist', function () {
    return  gulp.src([DIST]).pipe(vinylPaths(del));
});


//  SYNC
gulp.task('sync:resources', function () {

    var DEST    =   path.resolve(path.join(BUILD, 'public'));

    var resAssets   =   gulp.src([
                                path.join(BUILD, 'resources/assets', '*.*')
                            ])
                            .pipe(changed(path.join(DEST, 'assets')))
                            .pipe(gulp.dest(path.join(DEST, 'assets')))
                            .on('error', console.error.bind(console));

    var resStuff    =   gulp.src([
                                path.join(BUILD, 'resources', '*.*')
                              , path.join(BUILD, 'resources', '.*')
                            ])
                            .pipe(changed(DEST))
                            .pipe(gulp.dest(DEST))
                            .on('error', console.error.bind(console));

    return merge(resAssets, resStuff);
});

/* gulp.task('sync:views', function () {
    return  gulp.src('')
                .pipe(dirSync(
                    path.join(SRC,   'resources/views')
                  , path.join(BUILD, 'resources/views')
                  , syncOptions
                ))
                .on('error', console.error.bind(console));
}); */

gulp.task('sync:engine', function () {
    return  gulp.src('')
                .pipe(dirSync(
                    ENGINE
                  , BUILD
                  , _.extend({}, syncOptions, {ignore: [
                        /^\.env(.*)?$/i
                      , /^(.*)\.md$/i
                      , /^(.*)\.lock$/i
                    ]})
                ))
                .on('error', console.error.bind(console));
});

gulp.task('sync:src', function () {
    return  gulp.src('')
                .pipe(dirSync(SRC, BUILD, syncOptions))
                .on('error', console.error.bind(console));
});

gulp.task('sync:assets', function () {
    return  gulp.src('')
                .pipe(dirSync(
                    path.join(BUILD, 'resources/assets')
                  , path.join(BUILD, 'public/assets')
                  , syncOptions
                ))
                .on('error', console.error.bind(console));
});

gulp.task('sync:dist', function () {
    return  gulp.src('')
                .pipe(dirSync(BUILD, DIST, syncOptions))
                .on('error', console.error.bind(console));
});

gulp.task('sync:web', function () {
    return  gulp.src('')
                .pipe(dirSync(BUILD, WEB, syncOptions))
                .on('error', console.error.bind(console));
});


//  BUNDLE CSS and JS
gulp.task('build:css', function () {
    var DEST    =   path.join(BUILD, 'public/assets/css');
    var FROM    =   path.join(BUILD, 'resources/assets/css');
    var frontCSS    =    gulp.src([
                            path.join(FROM, 'frontend', '*.css')
                        ])
                        .pipe(gulpif('production' === envConfig.env, cleanCSS(cleanOptions, function (d) {
                            console.info(d.name + ': ' + d.stats.originalSize + ' -> ' + d.stats.minifiedSize + ' [' + d.stats.timeSpent + 'ms] [' + 100 * d.stats.efficiency.toFixed(2) + '%]');
                        }), false))
                        .pipe(concatCSS('frontend-bundle.css', {rebaseUrls: true}))
                        .pipe(minifyCSS())
                        .pipe(headfoot.header(Banner.header))
                        .pipe(headfoot.footer(Banner.footer))
                        .pipe(rename({suffix: minifyOptions.suffix}))
                        .pipe(gulp.dest(DEST));
    var backCSS =   gulp.src([
                        path.join(FROM, 'cabinet', '*.css')
                    ])
                    .pipe(gulpif('production' === envConfig.env, cleanCSS(cleanOptions, function (d) {
                        console.info(d.name + ': ' + d.stats.originalSize + ' -> ' + d.stats.minifiedSize + ' [' + d.stats.timeSpent + 'ms] [' + 100 * d.stats.efficiency.toFixed(2) + '%]');
                    }), false))
                    .pipe(concatCSS('cabinet-bundle.css', {rebaseUrls: true}))
                    .pipe(minifyCSS())
                    //.pipe(header(Banner.header, {pkg: pkg}))
                    .pipe(headfoot.header(Banner.header))
                    .pipe(headfoot.footer(Banner.footer))
                    .pipe(rename({suffix: minifyOptions.suffix}))
                    .pipe(gulp.dest(DEST));

    return merge(frontCSS, backCSS);
});

gulp.task('build:js', function () {
    var DEST = path.join(BUILD, 'public/assets/js');
    return  gulp.src(path.join(BUILD, 'resources/assets/js', '**/*.js'))
                //.pipe(jscs('.jscsrc'))
                //.pipe(jscs.reporter())
                .pipe(changed(DEST))
                .pipe(gulpif('production' === envConfig.env, uglify(uglifyOptions), false))
                //.pipe(header(Banner.header, {pkg: pkg}))
                .pipe(headfoot.header(Banner.header))
                .pipe(headfoot.footer(Banner.footer))
                .pipe(gulp.dest(DEST));
});

//  ARTISAN
gulp.task('artisan:vendor:publish', function () {
    gulp.src('')
        .pipe(exec('cd ' + BUILD + ' && php artisan -vvv vendor:publish'))
        .pipe(exec.reporter(reportOptions));
});

gulp.task('artisan:migrate', function () {
    gulp.src('')
        .pipe(exec('php artisan -vvv migrate'))
        .pipe(exec.reporter(reportOptions));
});

gulp.task('artisan:clear', function () {
    return gulp.src('')
            .pipe(exec('cd ' + CURDIR + WEB + ' && php artisan -vvv view:clear && cd ..'))
            .pipe(exec('cd ' + CURDIR + WEB + ' && php artisan -vvv route:list && cd ..'))
            .pipe(exec.reporter(reportOptions));
});

gulp.task('artisan:key:generate', function () {
    //console.info('reportOptions = [', util.inspect(reportOptions), ']');
    return gulp.src('')
            .pipe(exec('cd ' + BUILD + ' && php artisan -vvv key:generate && cd ..'))
            .pipe(exec.reporter(reportOptions));
});


//  LINTERS
gulp.task('jscs', function () {
    return  gulp.src([
                    path.join(SRC, 'resources/assets/js/', '*.js')
                  , path.join(SRC, 'resources/assets/js/app', '**/*.js')
                ])
                .pipe(jscs('.jscsrc'))
                .pipe(jscs.reporter());
});
gulp.task('jshint', function () {
    return  gulp.src([
                    path.join(SRC, 'resources/assets/js/', '*.js')
                  , path.join(SRC, 'resources/assets/js/app', '**/*.js')
                ])
                .pipe(jshint('.jshintrc'))
                .pipe(gulpif('production' === envConfig.env
                  , jshint.reporter('jshint-stylish',   {verbose: true})
                  , jshint.reporter('default',          {verbose: true})
                ));
                //  , jshint.reporter('fail',           {verbose: true})
});


//  Log file paths in the stream
gulp.task('files:src', function () {
    return  gulp.src([
                path.join(SRC, '**/*')
              , path.join(SRC, '**/*.*')
              , path.join(SRC, '**/.*')
            ])
            .pipe(changed(BUILD))
            .pipe(vinylPaths(function (paths) {
                console.info('Changed:', paths);
                return Promise.resolve();
            }));
});

gulp.task('show:config', function () {
    console.warn('ENV Config: [', util.inspect(envConfig), ']');
});

gulp.task('usage', function () {
    console.log('\n' + (new Array(50).join('-')));
    console.info('\nUsage: gulp <task>\t-\tRun gulp task(s) specified');
    console.info('\nwhere <task> is one of:\n');
    console.warn('\tusage' + '\t', 'Show this topic');
    console.warn('\tshow:config' + '\t', 'Show Configuration file');
    console.warn('\tfiles:src' + '\t', 'Log File Paths in the Stream');
    console.warn('\n\tclean' + '\t\t', 'Empty given folders and Delete files');
    console.warn('\tclean:build' + '\t', 'Clean directory with BUILD');
    console.warn('\tclean:dist' + '\t', 'Distro files');
    console.warn('\tclean:resources' + '\t', 'Static CSS, JS and Images');
    console.warn('\tclean:public' + '\t', 'Directory visible from Internet');
    console.log('\n' + (new Array(50).join('-')));
    console.warn('\n');
});

/*  EOF: ROOT/gulpfile.js  */
