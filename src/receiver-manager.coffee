_               = require 'lodash'
spawn           = require 'cross-spawn'
path            = require 'path'

WINDOWS_RECEIVER_PATH = path.join 'C', 'Program Files (x86)', 'Citrix', 'SelfServicePlugin', 'SelfService.exe'
MAC_RECEIVER_PATH = '/Applications/Citrix Receiver.app'

class ReceiverManager
  constructor: ->
    # hook for testing
    @spawn = spawn
    @IS_WINDOWS = process.platform == 'win32' || process.platform == 'win64'
    if @IS_WINDOWS
      @DEFAULT_RECEIVER_PATH = WINDOWS_RECEIVER_PATH
    else
      @DEFAULT_RECEIVER_PATH = MAC_RECEIVER_PATH

  connect: ({@receiverPath}, callback) =>
    @receiverPath ?= @DEFAULT_RECEIVER_PATH
    callback()

  _getOSCommand: ({args}) =>
    return {command: @receiverPath, args} if @IS_WINDOWS
    args = [@receiverPath]
    return {command: '/usr/bin/open', args}

  _execute: ({args}, callback) =>
    callback = _.once callback
    {command, args} = @_getOSCommand {args}
    proc = @spawn command, args

    stdout = ''
    stderr = ''

    proc.on 'error', callback

    proc.stdout.on 'data', (data) =>
      stdout += data.toString()

    proc.stderr.on 'data', (data) =>
      stderr += data.toString()

    proc.on 'close', (exitCode) =>
      callback null, {exitCode, stdout, stderr}

  disconnectApps: (callback) =>
    @_runCommand command: 'disconnectapps', callback

  logoff: (callback) =>
    @_runCommand command: 'logoff', callback

  openApplication: ({application}, callback) =>
    args = [
      '-launch'
      '-name'
      application
    ]
    @_execute {args}, callback

  poll: (callback) =>
    @_runCommand command: 'poll', callback

  reconnectApps: (callback) =>
    @_runCommand command: 'reconnectapps', callback

  _runCommand: ({command}, callback) =>
    @_execute args: ["-#{command}"], callback

  startReceiver: (callback) =>
    @_execute {}, callback

module.exports = ReceiverManager
