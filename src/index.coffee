{EventEmitter}  = require 'events'
debug           = require('debug')('meshblu-connector-citrix-receiver:index')
ReceiverManager = require './receiver-manager'

class Connector extends EventEmitter
  constructor: ({@logger})->
    throw 'Connector requires logger' unless @logger?
    @receiver = new ReceiverManager {@logger}

  isOnline: (callback) =>
    callback null, running: true

  close: (callback) =>
    debug 'on close'
    callback()

  disconnectApps: (callback) =>
    @receiver.disconnectApps callback

  logoff: (callback) =>
    @receiver.logoff callback

  openApplication: ({application}, callback) =>
    @receiver.openApplication {application}, callback

  onConfig: (device={}, callback=->) =>
    { @options } = device
    debug 'on config', @options
    { receiverPath } = @options ? {}
    @receiver.connect { receiverPath }, callback

  poll: (callback) =>
    @receiver.poll callback

  reconnectApps: (callback) =>
    @receiver.reconnectApps callback

  start: (device, callback) =>
    debug 'started'
    @onConfig device, callback

  startReceiver: (callback) =>
    @receiver.startReceiver callback

module.exports = Connector
