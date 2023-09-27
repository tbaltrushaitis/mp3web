/*!
 * Project:
 * File:        ASSETS/JS/APP/CLASSES/Abstract.class.js
 * Copyright(c) 2016-nowdays Baltrushaitis Tomas
 * License:     MIT
 */

'use strict';

/**
 * DEPENDENCIES
 * @private
 */

const fs        = require('fs');
const path      = require('path');
const util      = require('util');
const _         = require('lodash');
const md5       = require('md5');
const uuid      = require('uuid/v4');
const EE        = require('events').EventEmitter;
const utin      = util.inspect;


/**
 * CONFIGURATION
**/

let ME = {};
const appPath = path.dirname(require.main.filename);
const modName = path.basename(module.filename, '.js');
const modPath = path.relative(appPath, path.dirname(module.filename));
const modsPath = path.join(appPath, 'modules', path.sep);
const libsPath = path.normalize(path.join(appPath, '..', 'lib', path.sep));
const confBase = path.join(appPath, 'config');
const Config = require(confBase);

utin.defaultOptions = Object.assign({}, Config.get('iopts'));

/**
 * DECLARATION
 * @class
 */

const Abstract = class Abstract extends EE {

  /**
   * CONSTRUCTOR
   * @special
   */

  constructor (defs) {
    let p = Object.assign({},
      {
        base: path.relative(path.dirname(require.main.filename), path.dirname(module.filename))
      },
      defs || {});
    super(p);

    this.m = this.m || {};

    this.m._Config = Config;
    this.m._config = {};

    this.m._data = {};
    this.m._model = {};

    this.m._defs = this.m._defs || Object.assign({}, p);
    this.m._opts = Object.assign({}, this.m._defs, defs);

    this.m.base = this.m.base || this.m._opts.base;
    this.m._entity = this.m._entity || this.constructor.name;
    this.m._name = this.m._entity + '_' + md5(this.m._entity).substr(0, 15 - this.m._entity.length);
    this.m._name_ = this.m._entity + '.'.repeat(15 - this.m._entity.length)
    this.m._title = this.m._name.toUpperCase();
    this.m._defaults = this.m._defaults || Object.assign({}, defs);

    this.m._Id = null;
    this.m._entityId = null;
    this.m._instId = uuid();

    if (fs.existsSync(this._configFile)) {
      this.m._config = require(this._configFile);
    }


    this.m.lines = {
      slim: `${'-'.repeat(100)}`,
      bold: `${'='.repeat(100)}`,
      thin: `${'.'.repeat(100)}`
    };


    /**
     * EVENTS
     * @prototype
     */

    this.on('loaded', function () {
      this.emit('complete');
    });

    this.on('complete', function () {
      // this.emit('greet');
    });

    this.on('greet', function () {
      return this.greet();
    });

    this.on('feel', function (how) {
      this.noty(`Feel ${how.toUpperCase()}!`);
    });

    this.on('db', function (how) {
      this.noty(`Database ${how.toUpperCase()}!`);
    });

    this.on('adapt', function (how) {
      this.noty(`Data adaptation looks ${how.toUpperCase()}!`);
    });

    // this.emit('loaded');

  }


  /**
   * METHODS
   * @prototype
   */

  //  DEFAULT INIT
  init () {
    let self = this;
    // this.m.pref = path.basename(module.filename, '.js');

    return Promise.resolve().then(function () {
      return new Promise(function (resolve, reject) {
        self.emit('loaded');
        resolve(self);
      });
    })
    .catch(function (err) {
      self.noty(`[ERROR] FAILED to initialize [${self.m._entity}]: ${utin(err)}`);
      return self;
    });
  }


  //  ----------------------------------------------------------------------  //
  //  ----------------   CONFIGURATION GETTERS   ---------------------------  //
  //  ----------------------------------------------------------------------  //

  get _selfConfig () {
    let retConf = _.isObject(this.m._config[`${this.m._entity}`]) ? this.m._config[`${this.m._entity}`] : this.m._config;
    return retConf;
  }

  get _selfBase () {
    return this.m.base;
  }

  get _configFile () {
    let retfName = `${path.join(confBase, 'config', this._selfBase, this.m._entity)}.json`;
    return retfName;
  }

  set pref (v) {
    this.m.path = v || module.filename;
  }

  get pref () {
    return this.m.path;
  }


  //  ----------------------------------------------------------------------  //
  //  ----------------------------   HELPERS   -----------------------------  //
  //  ----------------------------------------------------------------------  //

  noty (mes) {
    let msg = mes || '[EMPTY MESSAGE]';
    console.log(`[${new Date().toISOString()}]${this.pref ? '[' + this.pref + ']' : ''}[${this.m._name_}] ${msg}`);
    return this;
  }


  greet () {
    let msg = `Iam [_instId:${this.m._instId}]` + (_.isEmpty(this._selfConfig.subs) ? `` : ` with [\n${utin(this._selfConfig.subs)}]`);
    return this.noty(msg);
  }


  line () {
    return this.noty(this.m.lines.slim);
  }


  head () {
    return this.noty(this.m.lines.bold);
  }


  header () {
    return this.noty(this.m.lines.slim);
  }


  footer () {
    return this.noty(`${this.m.lines.bold}\n`);
  }


};


/**
 * EXPOSE
 * @public
 */
exports = Abstract;


/**
 * EXPORTS
 * @module
 */
module.exports = exports;
