http = require 'http'

class ReconnectApps
  constructor: ({@connector}) ->
    throw new Error 'ReconnectApps requires connector' unless @connector?

  do: (message, callback) =>
    @connector.reconnectApps callback

module.exports = ReconnectApps
