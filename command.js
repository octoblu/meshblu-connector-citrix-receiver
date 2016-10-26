#!/usr/bin/env node
'use strict';
require('coffee-script/register');
require('fs-cson/register');

var ConnectorRunner = require('meshblu-connector-runner');
var MeshbluConfig   = require('meshblu-config');
var bunyan          = require('bunyan');
var path            = require('path');

var connectorRunner = new ConnectorRunner({
  connectorPath: __dirname,
  meshbluConfig: new MeshbluConfig().toJSON(),
  logger:        bunyan.createLogger({
    name: 'command.js',
    streams: [
      {
        level: 'info',
        type: 'rotating-file',
        path: path.join(__dirname, 'log', 'connector.log'),
        period: '1d',
        count: 3
      },
      {
        level: 'warn',
        type: 'rotating-file',
        path: path.join(__dirname, 'log', 'connector-warn.log'),
        period: '1d',
        count: 3
      },
      {
        level: 'error',
        type: 'rotating-file',
        path: path.join(__dirname, 'log', 'connector-error.log'),
        period: '1d',
        count: 3
      }
    ]
  })
});
connectorRunner.run()
