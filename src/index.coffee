_               = require 'lodash'
{EventEmitter}  = require 'events'
{ exec }        = require 'child_process'
spawn           = require 'cross-spawn'
path            = require 'path'
debug           = require('debug')('meshblu-connector-citrix-receiver:index')

WINDOWS_RECEIVER_PATH = path.join 'C', 'Program Files (x86)', 'Citrix', 'SelfServicePlugin', 'SelfService.exe'
macPath = path.join 'Applications', 'TextEdit.app'
MAC_RECEIVER_PATH = "/#{macPath}"

class CitrixReceiver extends EventEmitter
  constructor: ->
    debug 'CitrixReceiver constructed'
    @isWindows = process.platform == 'win32' || process.platform == 'win64'
    @DEFAULT_RECEIVER_PATH = WINDOWS_RECEIVER_PATH if @isWindows
    @DEFAULT_RECEIVER_PATH = MAC_RECEIVER_PATH unless @isWindows

  onMessage: (message={}) =>
    { command, application } = message.payload ? {}
    return @openApplication { command, application } if @isOpenApplicationCommand({ command })
    @runCommand { command }

  emitMessage: (topic, payload) =>
    @emit 'message', {
      devices: ['*'],
      topic,
      payload,
    }

  runCommand: ({ command }) =>
    return @emitMessage 'error', { error: "#{command} is only available on windows" } unless @isWindows
    @execute(["-#{command}"])

  isOpenApplicationCommand: ({ command }) =>
    return true if command == 'start-receiver'
    return true if command == 'open-application'
    return false

  execute: (options=[]) =>
    debug "spawn: #{@receiverPath} #{options.join(' ')}"
    child = spawn @receiverPath, options, { env: process.env }

    child.on 'error', (error) =>
      debug 'error', error
      @emitMessage 'error', { error }

    child.on 'close', (code) =>
      return unless code
      @emitMessage 'error', { error: { 'exit-code': code } }

  openApplication: ({ command, application }) =>
    return @openOnMac() unless @isWindows
    return @execute() unless application
    options = [
      '-launch',
      '-name',
      application
    ]
    @execute options

  openOnMac: =>
    openCommand = "open \"#{@receiverPath}\""
    debug "open on mac", openCommand
    exec openCommand, (error) =>
      @emitMessage 'error', { error } if error?

  onConfig: (device={}) =>
    @receiverPath = device.options?.receiverPath ? @DEFAULT_RECEIVER_PATH

  start: (device) =>
    @onConfig device

module.exports = CitrixReceiver
