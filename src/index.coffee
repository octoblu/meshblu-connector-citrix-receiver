{EventEmitter}  = require 'events'
debug           = require('debug')('meshblu-connector-citrix-receiver:index')
exec            = require('child_process').exec;
_               = require 'lodash'

class CitrixReceiver extends EventEmitter
  constructor: ->
    debug 'CitrixReceiver constructed'
    @options = {}
    @isWindows = process.platform == 'win32' || process.platform == 'win64'
    @DEFAULT_RECEIVER_PATH = undefined
    if @isWindows
      @DEFAULT_RECEIVER_PATH = 'C:\\Program Files (x86)\\Citrix\\SelfServicePlugin\\SelfService.exe'
    else
      @DEFAULT_RECEIVER_PATH = '/Applications/Citrix\\ Receiver.app'

    schemas.optionsSchema.properties.receiverPath.default = @DEFAULT_RECEIVER_PATH

  onMessage: (message) =>
    return unless message?

    { payload } = message || {}
    { command } = payload

    if command == 'start-receiver' || command == 'open-application'
      if Array.isArray(payload.application)
        payload.application.forEach (app) =>
          debug 'Launching: ', app
          @openApplication(app)
      else
        debug 'Launching: ', payload.application
        @openApplication payload.application

    @runCmd(command);

  runCmd: (cmd) =>
    if !@isWindows
      @emit 'message', {devices: '*', topic: 'error', payload: {error: cmd + ' is only available for Windows'}}

    command = '"' + @options.receiverPath + '"'
    command += ' -' + cmd
    debug 'executing command', command
    exec command

  openApplication: (application) =>
    fullCommand = ''
    command = @options.receiverPath
    if @isWindows
      fullCommand = '"' + command + '"'
      if application
        fullCommand += ' -launch -name "' + application + '"'
    else
      fullCommand = 'open ' + command

    debug 'fullCommand to exec', fullCommand
    exec fullCommand

  onConfig: (config) =>
    return unless config?
    debug 'on config', @uuid
    @setOptions config.options

  setOptions: (options) =>
    @options = _.extend { receiverPath: @DEFAULT_RECEIVER_PATH }, options

  start: (device) =>
    { @uuid } = device
    debug 'started', @uuid
    @setOptions device.options

module.exports = CitrixReceiver
