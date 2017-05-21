/*  BOF: ROOT/gulpfile.js  */

//##  Make sure that jQuery included  ##//
//const   jQuery  =   jQuery  ||  require('jquery')(require('jsdom').jsdom().parentWindow)
const   jQuery  =   require('jquery')
      , $       =   $   ||  jQuery
      , _       =   require('underscore')
;

const fs    =   require('fs');
const del   =   require('del');
const path  =   require('path');
const util  =   require('util');
const merge =   require('merge-stream');

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
const dirSync       =   require('gulp-directory-sync');
const exec          =   require('gulp-exec');
const filter        =   require('gulp-filter');
const gulpif        =   require('gulp-if');
const header        =   require('gulp-header');
const jscs          =   require('gulp-jscs');
const jshint        =   require('gulp-jshint');
const stylish       =   require('jshint-stylish');
const rename        =   require('gulp-rename');
const template      =   require('gulp-template');
const uglify        =   require('gulp-uglify');
const gulpSequence  =   require('gulp-sequence');
//const util      =   require('gulp-util');
//const livereload    =   require('gulp-livereload');

// const Config    =   require('./app-config.json');
const Config    =   require('nconf');
const pkg       =   require('./package.json');
const ENGINE    =   path.join('laravel-5.2');
const BOWER     =   JSON.parse(fs.readFileSync('./.bowerrc')).directory;

const SRC   =   path.join('src');
const BUILD =   path.join('build');
const DIST  =   path.join('dist');
const WEB   =   path.join('webroot', path.sep);

const bowerOptions  =   pkg.options.bower;
const execOptions   =   pkg.options.exec;
const fileOptions   =   pkg.options.file;
const reportOptions =   pkg.options.reporting;
const syncOptions   =   pkg.options.sync;
const watchOptions  =   pkg.options.watch;
const uglifyOptions =   pkg.options.uglify;

const VERSION   =   fs.readFileSync('./VERSION', fileOptions).trim();

var now     =   new Date();
const   Banner  =   {
            header: '\n/*!\n'
                  + ' * Package:\t <%= pkg.name %>@<%= pkg.version %>' + '\n'
                  + ' * Name:\t <%= pkg.title %> \n'
                  + ' * Version:\t ' + VERSION + '\n'
                  + ' * Description:\t <%= pkg.description %>' + '\n'
                  + ' * Built:\t ' + dateFormat(now, 'yyyy-mm-dd HH:MM:ss') + '\n'
                  + ' * Copyright:\t ' + '2016 - ' + dateFormat(now, 'yyyy') + ' <%= pkg.author.name %>' + '\n'
                  + ' * Visit:\t <%= pkg.homepage %>' + '\n'
                  + '**/\n\n'
          , footer: '\n\n/*!\n'
                  + ' * EOF: <%= pkg.name %> v<%= pkg.version %>: <%= pkg.title %>' + '\n'
                  + ' */\n'
        };

var envConfig = {
    string:     'env'
  , default:    {env: process.env.NODE_ENV || 'empty'}
};
envConfig   =   parseArgs(process.argv.slice(2), envConfig);

console.log('\n\n\n', 'envConfig = [', util.inspect(envConfig), ']\n\n\n');
console.log('\n\n\n', 'VERSION = [', util.inspect(VERSION), ']\n\n\n');
console.log('\n\n\n', 'Config = [', util.inspect(Config), ']\n\n\n');

//  ENV ROUTER
gulp.task('default', function () {

    //  DEFAULT Scenario Route
    (function () {
        switch (envConfig.env) {
            case 'empty': {
                gulpSequence('files:src', 'usage')();
                break;
            }
            case 'test': {
                gulpSequence('lint')();
                break;
            }
            case 'dev': {
                //gulpSequence('clean:build', 'build:dev', 'deploy', 'watch')();
                gulpSequence('build:dev')();
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
//gulp.task('bower',      gulpSequence(['bower:fonts'], ['bower:css:fonts', 'bower:css:plugins'], ['bower:js'], ['bower:plugins']));
//gulp.task('build:dev',  gulpSequence(['clean:resources', 'clean:public'], ['sync:src'], ['sync:media', 'bower'], 'sync:assets:fonts', ['build:css', 'build:scripts']));
gulp.task(  'build:dev',  gulpSequence(
            ['clean:build']
          , ['sync:engine']
          , ['sync:src']
          , ['lint']
          , ['bower:collect']
          , ['fixPermissions']
    ));
gulp.task('build',      gulpSequence(
                            ['clean:build']
                          , ['sync:engine']
                          , ['sync:src']
                          , ['bower:collect']
                        //  , ['artisan:vendor:publish']
                       //   , ['sync:media', 'bower']
                   //       , ['sync:assets:fonts']
                     //     , ['build:css', 'build:scripts']
                          , ['fixPermissions']
                        ));
gulp.task('dist',       gulpSequence(['clean:dist'], ['sync:dist']));
gulp.task('deploy',     gulpSequence('sync:web', 'artisan:clear'));
//gulp.task('watch',      gulpSequence('watch:src:views', 'watch:src:css', 'watch:src:js'));
gulp.task('watch',      gulpSequence('watch:src:php', 'watch:src:css', 'watch:src:js'));


//  BOWER
gulp.task('bower:collect', function () {

    var mBower      =   mainBowerFiles(bowerOptions);   //  , {base: BOWER}

    var DEST    =   path.join(BUILD, 'public/assets');
    var KEEP    =   path.join(BUILD, 'resources/bower');
    var JS      =   path.join('js/lib');
    var CSS     =   path.join('css');
    var FONT    =   path.join('fonts');
    var IMG     =   path.join('img');

    var bowerJS     =   gulp.src(mBower)
                            .pipe(filter([
                                '**/*.js'
                              , '!**/*.min.js'
                              , '!**/npm.js'
                            ]))
                            // .pipe(changed(path.resolve(KEEP, JS)))
                            .pipe(gulp.dest(path.resolve(DEST, JS)))
                            .pipe(filter([
                                '**/*.js'
                              , '!**/require.js'
                              , '!**/*-bundle.js'
                            ]))
                            .pipe(concat('bower-bundle.js'))
                            .pipe(gulp.dest(path.resolve(DEST, JS)))
                            .pipe(gulpif('production' === envConfig.env, uglify(uglifyOptions)))
                            .pipe(rename('bower-bundle.min.js'))
                            .pipe(header(Banner.header, {pkg: pkg}))
                            .pipe(gulp.dest(path.resolve(DEST, JS)));

    var bowerCSS    =   gulp.src(mBower)
                            .pipe(filter([
                                '**/*.css'
                              , '!**/*.min.css'
                              , "!**/AdminLTE-*.css"
                              , "!**/skin-*.css"
                              , '!**/*-bundle.css'
                            ]))
                            // .pipe(changed(path.resolve(KEEP, CSS)))
                            .pipe(gulpif('production' === envConfig.env, cleanCSS({debug: true, processImport: true}, function (d) {
                                console.info(d.name + ': ' + d.stats.originalSize + ' -> ' + d.stats.minifiedSize + ' [' + d.stats.timeSpent + 'ms] [' + d.stats.efficiency.toFixed(2) + ']');
                            }), false))
                            //.pipe(gulp.dest(DEST_CSS))
                            .pipe(gulp.dest(path.resolve(DEST, CSS)))
                            .pipe(concatCSS('bower-bundle.css', {rebaseUrls: true}))
                            .pipe(header(Banner.header, {pkg: pkg}))
                            .pipe(gulp.dest(path.resolve(DEST, CSS)))
                            .pipe(rename('bower-bundle.min.css'))
                            .pipe(gulp.dest(path.resolve(DEST, CSS)));

    var bowerFonts  =   gulp.src(mBower)
                            .pipe(filter(['**/fonts/*.*']))
                            .pipe(changed(path.resolve(DEST, FONT)))
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


gulp.task('watch:src:views', function () {
    var wViews  =   gulp.watch([path.join(SRC, 'resources/views/**/*.blade.php')]
                      , watchOptions
                      , function () {
                            gulpSequence('sync:views', 'sync:web', 'artisan:clear')();
                    });
    wViews.on('change', function (event) {
        console.log('View ' + event.path + ' was ' + event.type + ', running tasks...');
    });
});
gulp.task('watch:src:css', function () {
    var wCSS    =   gulp.watch([path.join(SRC, 'resources/assets/css/**/*.css')]
                  , watchOptions
                  , function () {
                        gulpSequence('sync:assets:css', 'build:css', 'sync:web')();
                    });
    wCSS.on('change', function (event) {
        console.log('Style ' + event.path + ' was ' + event.type + ', running tasks...');
    });
});
gulp.task('watch:src:js', function () {
    var wScripts    =   gulp.watch([path.join(SRC, 'resources/assets/js/**/*.js')]
                      , watchOptions
                      , function () {
                            gulpSequence('sync:assets:js', 'build:scripts', 'sync:web')();
                        });
    wScripts.on('change', function (event) {
        console.log('Script ' + event.path + ' was ' + event.type + ', running tasks...');
    });
});

//  CLEAN
gulp.task('clean:build', function () {
    return  gulp.src([BUILD]).pipe(vinylPaths(del));
});
gulp.task('clean:dist', function () {
    return  gulp.src([DIST]).pipe(vinylPaths(del));
});

/* gulp.task('clean:resources', function () {
    return  gulp.src([
                path.join(BUILD, 'resources', '.*')
              , path.join(WEB,   'resources', '.*')
//              , path.join(BUILD, 'resources', '*')
//              , path.join(WEB,   'resources', '*')
            ])
            .pipe(vinylPaths(del));
});
gulp.task('clean:public', function () {
    return  gulp.src([
//                path.join(BUILD, 'resources/assets',  '.*')
//              , path.join(WEB,   'resources/assets',  '.*')
                path.join(BUILD, 'public/assets',   '.*')
              , path.join(WEB,   'public/assets',   '.*')
            ])
            .pipe(vinylPaths(del));
});*/

//  SYNC
gulp.task('sync:engine', function () {
    return  gulp.src('')
                .pipe(dirSync(ENGINE, BUILD, _.extend(syncOptions, {ignore: [/^\.env(.*)?$/i, /^(.*)\.md$/i]})))
                .on('error', console.error.bind(console));
});
gulp.task('sync:src', function () {
    return  gulp.src('')
                .pipe(dirSync(SRC, BUILD, {
                        printSummary:   true
                      , nodelete:       true
                      , ignore:         ['.env']
                }))
                .on('error', console.error.bind(console));
});
gulp.task('sync:media', function () {
    return  gulp.src('')
                .pipe(dirSync(
                    path.join(BUILD, 'resources/assets/img')
                  , path.join(BUILD, 'public/assets/img')
                  , syncOptions
                ))
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
gulp.task('sync:assets:css', function () {
    return  gulp.src('')
                .pipe(dirSync(
                    path.join(SRC, 'resources/assets/css')
                  , path.join(BUILD, 'resources/assets/css')
                  , syncOptions
                ))
                .on('error', console.error.bind(console));
});
gulp.task('sync:assets:fonts', function () {
    return  gulp.src('')
                .pipe(dirSync(
                    path.join(BUILD, 'resources/assets/fonts')
                  , path.join(BUILD, 'public/assets/fonts')
                  , syncOptions
                ))
                .on('error', console.error.bind(console));
});
gulp.task('sync:assets:js', function () {
    return  gulp.src('')
                .pipe(dirSync(
                    path.join(SRC, 'resources/assets/js')
                  , path.join(BUILD, 'resources/assets/js')
                  , syncOptions
                ))
                .on('error', console.error.bind(console));
});
gulp.task('sync:views', function () {
    return  gulp.src('')
                .pipe(dirSync(
                    path.join(SRC, 'resources/views')
                  , path.join(BUILD, 'resources/views')
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
gulp.task('sync:web:dev', function () {
    return  gulp.src('')
                .pipe(dirSync(BUILD, WEB + '.dev', syncOptions))
                .on('error', console.error.bind(console));
});

//  BUILD
gulp.task('build:css', function () {
    var DEST    =   path.join(BUILD, 'public/assets/css');
    return  gulp.src([
                path.join(BUILD, 'resources/assets/css/*.css')
              , '!**/errors.css'
              , '!**/styles.css'
              // , '!**/fonts-cdn.css'
            ])
            .pipe(concatCSS('styles.css', {rebaseUrls: false}))
            .pipe(gulpif('production' === envConfig.env, cleanCSS({debug: true, processImport: false}, function (details) {
                console.info(details.name + ': ' + details.stats.originalSize + ' -> ' + details.stats.minifiedSize + ' [' + details.stats.timeSpent + 'ms] [' + details.stats.efficiency.toFixed(2) + '%]');
            }), false))
            .pipe(header(Banner.header, {pkg: pkg}))
            .pipe(gulp.dest(DEST));
});
gulp.task('build:scripts', function () {
    var DEST = path.join(BUILD, 'public/assets/js');
    return gulp.src(path.join(BUILD, 'resources/assets/js/**/*.js'))
        .pipe(jscs())
        .pipe(jscs.reporter())
        .pipe(changed(DEST))
        .pipe(gulpif('production' === envConfig.env, uglify(uglifyOptions), false))
        .pipe(header(Banner.header, {pkg: pkg}))
        .pipe(gulp.dest(DEST));
});

//  BOWER
gulp.task('bower:fonts', function () {
    var RESO = path.join(BUILD, 'resources/assets/fonts');
    // var DEST = path.join(BUILD, 'public/assets/fonts');
    return  gulp.src([
                path.join(BOWER, 'bootstrap/dist/fonts/*.*')
              , path.join(BOWER, 'font-awesome/fonts/*.*')
              , path.join(BOWER, 'lato-font/fonts/**/*.*')
              , path.join(BOWER, 'raty/lib/fonts/*.*')
            ])
            // .pipe(changed(DEST))
            .pipe(changed(RESO))
            .pipe(gulp.dest(RESO));
            // .pipe(gulp.dest(DEST));
});
gulp.task('bower:css:fonts', function () {
    return  gulp.src([
                path.join(BOWER, 'ionicons/css/ionicons.css')
              /* , path.join(BOWER, 'font-awesome/css/font-awesome.css')
              // , path.join(BOWER, 'font-roboto/dist/styles/roboto.css')
              // , path.join(BOWER, 'glyphicons-halflings/css/glyphicons-halflings.css')
              // , path.join(BOWER, 'lato-font/css/lato-font.css') */
            ])
            .pipe(gulpif('production' === envConfig.env, cleanCSS({debug: true, processImport: false}, function (details) {
                console.info(details.name + ': ' + details.stats.originalSize + ' -> ' + details.stats.minifiedSize + ' [' + details.stats.timeSpent + 'ms] [' + details.stats.efficiency.toFixed(2) + '%]');
            })))
            .pipe(gulp.dest(path.join(BUILD, 'resources/assets/css/fonts')))
            .pipe(concatCSS('fonts-bundle.css', {rebaseUrls: false}))
            .pipe(header(Banner.header, {pkg: pkg}))
            .pipe(gulpif('production' === envConfig.env, cleanCSS({debug: true, processImport: false}, function (details) {
                console.info(details.name + ': ' + details.stats.originalSize + ' -> ' + details.stats.minifiedSize + ' [' + details.stats.timeSpent + 'ms] [' + details.stats.efficiency.toFixed(2) + '%]');
            })))
            .pipe(gulp.dest(path.join(BUILD, 'public/assets/css')));
});
gulp.task('bower:css:plugins', function () {
    return  gulp.src([
                path.join(BOWER, 'animate.css/animate.css')
              , path.join(BOWER, 'raty/lib/jquery.raty.css')
              /* , path.join(BOWER, 'bootstrap/dist/css/bootstrap.css')
              // , path.join(BOWER, 'bootstrap/dist/css/bootstrap-theme.css') */
              , path.join(BOWER, 'bootstrap-tagsinput/dist/bootstrap-tagsinput.css')
              // , path.join(BOWER, 'normalize.css/normalize.css') */
            ])
            .pipe(gulpif('production' === envConfig.env, cleanCSS({debug: true, processImport: false}, function (details) {
                console.info(details.name + ': ' + details.stats.originalSize + ' -> ' + details.stats.minifiedSize + ' [' + details.stats.timeSpent + 'ms] [' + details.stats.efficiency.toFixed(2) + '%]');
            })))
            .pipe(gulp.dest(path.join(BUILD, 'resources/assets/css/plugins')))
            .pipe(concatCSS('plugins-bundle.css', {rebaseUrls: false}))
            .pipe(header(Banner.header, {pkg: pkg}))
            .pipe(gulpif('production' === envConfig.env, cleanCSS({debug: true, processImport: false}, function (details) {
                console.info(details.name + ': ' + details.stats.originalSize + ' -> ' + details.stats.minifiedSize + ' [' + details.stats.timeSpent + 'ms] [' + details.stats.efficiency.toFixed(2) + '%]');
            })))
            .pipe(gulp.dest(path.join(BUILD, 'public/assets/css')));
});
gulp.task('bower:js', function () {
    var RESO = path.join(BUILD, 'resources/assets/js/lib');
    var DEST = path.join(BUILD, 'public/assets/js/lib');
    return  gulp.src([
                path.join(BOWER, 'bootstrap/dist/js/bootstrap.js')
              , path.join(BOWER, 'jquery/dist/jquery.js')
              , path.join(BOWER, 'jquery-tmpl/jquery.tmpl.js')
              , path.join(BOWER, 'lodash/lodash.js')
              , path.join(BOWER, 'requirejs/require.js')
              , path.join(BOWER, 'underscore/underscore.js')
            ])
            .pipe(gulp.dest(RESO))
            .pipe(changed(DEST))
            .pipe(gulpif('production' === envConfig.env, uglify(uglifyOptions)))
            .pipe(gulp.dest(DEST));
});
gulp.task('bower:plugins', function () {
    var RESO = path.join(BUILD, 'resources/assets/js/plugins');
    var DEST = path.join(BUILD, 'public/assets/js/plugins');

    var RATY =  gulp.src([
                    path.join(BOWER, 'raty/lib/**/*.*')
                ])
                .pipe(gulp.dest( path.join(RESO, 'raty') ))
                .pipe(changed( path.join(DEST, 'raty') ))
                .pipe(gulp.dest( path.join(DEST, 'raty') ));

    var TAGS =  gulp.src([
                    path.join(BOWER, 'bootstrap-tagsinput/dist/*.*')
                ])
                .pipe(gulp.dest( path.join(RESO, 'bootstrap-tagsinput') ))
                .pipe(changed( path.join(DEST, 'bootstrap-tagsinput') ))
                .pipe(gulp.dest( path.join(DEST, 'bootstrap-tagsinput') ));

    var MISC =  gulp.src([
                    path.join(BOWER, 'html5shiv/dist/html5shiv.min.js')
                  , path.join(BOWER, 'respond/dest/respond.min.js')
                ])
                .pipe(gulp.dest( path.join(RESO, 'misc') ))
                .pipe(changed( path.join(DEST, 'misc') ))
                .pipe(gulp.dest( path.join(DEST, 'misc') ));

    return merge(RATY, TAGS, MISC);
});

//  ARTISAN
gulp.task('artisan:vendor:publish', function () {
    gulp.src('')
        .pipe(exec('cd ' + BUILD + ' && php artisan vendor:publish'))
        .pipe(exec.reporter(reportOptions));
});
gulp.task('artisan:migrate', function () {
    gulp.src('')
        .pipe(exec('php artisan migrate'))
        .pipe(exec.reporter(reportOptions));
});
gulp.task('artisan:clear', function () {
    return gulp.src('')
            // .pipe(exec('cd ' + WEB + ' && php artisan clear-compiled -vvv && cd ..'))
            // .pipe(exec('cd ' + WEB + ' && php artisan auth:clear-resets -vvv && cd ..'))
            // .pipe(exec('cd ' + WEB + ' && php artisan cache:clear -vvv && cd ..'))
            // .pipe(exec('cd ' + WEB + ' && php artisan config:clear -vvv && cd ..'))
            // .pipe(exec('cd ' + WEB + ' && php artisan route:clear -vvv && cd ..'))
            .pipe(exec('cd ' + WEB + ' && php artisan view:clear && cd ..'))
            // .pipe(exec('cd ' + WEB + ' && php artisan optimize -vvv && cd ..'))
            // .pipe(exec('cd ' + WEB + ' && php artisan migrate:status -vvv && cd ..'))
            .pipe(exec('cd ' + WEB + ' && php artisan route:list && cd ..'))
            .pipe(exec.reporter(reportOptions));
});
gulp.task('artisan:key:generate', function () {
    return gulp.src('')
            .pipe(exec('cd ' + BUILD + ' && php artisan key:generate && cd ..'))
            .pipe(exec.reporter(reportOptions));
});


gulp.task('jscs', function () {
    return  gulp.src( path.join(SRC, 'resources/assets/js/', '**/*.js') )
                .pipe(jscs('.jscsrc'))
                .pipe(jscs.reporter());
});
gulp.task('jshint', function () {
    return  gulp.src( path.join(SRC, 'resources/assets/js/', '**/*.js') )
                .pipe( jshint('.jshintrc') )
                .pipe( gulpif('production' === envConfig.env
                  , jshint.reporter('jshint-stylish',   {verbose: true})
                  , jshint.reporter('default',          {verbose: true})
                ));
                //  , jshint.reporter('fail',           {verbose: true})
                //  , jshint.reporter('default',        { verbose: true })
                //  , jshint.reporter('jshint-stylish', { verbose: true })
});

gulp.task('fixPermissions', function () {
    return  gulp.src([
                path.join(BUILD, '**')
            ])
            .pipe(vinylPaths(function (vPath) {
                console.log('Chown:', vPath);
                exec('sudo chown www-data:www-data ' + vPath);
                return Promise.resolve();
            }));
});
//.pipe(chown(48))

// Log file paths in the stream
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
    //console.info('APP Config: [', Config, ']');
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
