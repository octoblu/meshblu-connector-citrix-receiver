_               = require 'lodash'
spawn           = require 'cross-spawn'

DEFAULT_DISPLAY = ':0'
DEFAULT_LINUX_RECEIVER_PATH = '/opt/Citrix/ICAClient/util/storebrowse'
DEFAULT_HOME_DIRECTORY = '/home/pi'

class LinuxReceiverManager
  constructor: ({ @logger })->
    throw new Error 'LinuxReceiverManager requires logger' unless @logger?
    # hook for testing
    @spawn = spawn

  connect: ({@display, @receiverPath, @storeUrl, @homeDirectory, @linuxUser}, callback) =>
    @logger.debug 'connect', JSON.stringify {@display, @receiverPath, @storeUrl, @homeDirectory, @linuxUser}
    @receiverPath  ?= DEFAULT_LINUX_RECEIVER_PATH
    @homeDirectory ?= DEFAULT_HOME_DIRECTORY
    @display       ?= DEFAULT_DISPLAY
    callback()

  _execute: ({receiverArgs}, callback) =>
    callback = _.once callback

    fullCommand = _.concat [@receiverPath], receiverArgs
    unless _.isEmpty(@linuxUser) || process.env.USER == @linuxUser
      fullCommand = _.concat ['sudo', '--non-interactive', '--user', @linuxUser], fullCommand

    [command, args...] = fullCommand
    env = {DISPLAY: @display, HOME: @homeDirectory}
    @logger.debug 'spawn', {command, args, env}
    proc = @spawn command, args, {env}

    stdout = ''
    stderr = ''

    proc.on 'error', (error) =>
      @logger.error error, 'spawn error'
      callback error

    proc.stdout.on 'data', (data) =>
      stdout += data.toString()

    proc.stderr.on 'data', (data) =>
      stderr += data.toString()

    proc.on 'close', (exitCode) =>
      @logger.debug 'exit', JSON.stringify({exitCode, stdout, stderr})
      callback null, {exitCode, stdout, stderr}

  disconnectApps: (callback) =>
    @_runCommand '--disconnect', callback

  logoff: (callback) =>
    @_runCommand command: 'logoff', callback

  openApplication: ({application}, callback) =>
    console.log 'openApplication', JSON.stringify {application}
    @_runCommand ['--launch', application], callback

  poll: (callback) =>
    callback new Error('poll command is not supported on Linux')

  reconnectApps: (callback) =>
    @_runCommand ['--reconnect', 'r'], callback

  _getStoreUrl: (callback) =>
    return callback null, @storeUrl if @storeUrl
    @_execute receiverArgs: ['--liststores'], (error, {exitCode, stdout}={}) =>
      return callback error if error?
      return callback new Error "received non 0 exit code: #{exitCode}" unless exitCode == 0
      urlWithQuotes = _.first _.split(stdout, '\t')
      storeUrl = _.replace urlWithQuotes, /'/g, ''
      @logger.info 'getStoreUrl', storeUrl
      return callback null, storeUrl

  _runCommand: (command, callback) =>
    @_getStoreUrl (error, storeUrl) =>
      return callback error if error?

      receiverArgs = _.concat _.castArray(command), storeUrl
      @_execute {receiverArgs}, callback

  startReceiver: (callback) =>
    @_execute {}, callback

module.exports = LinuxReceiverManager
