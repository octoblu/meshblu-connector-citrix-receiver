http = require 'http'

class DisconnectApps
  constructor: ({@connector}) ->
    throw new Error 'DisconnectApps requires connector' unless @connector?

  do: (message, callback) =>
    @connector.disconnectApps callback

module.exports = DisconnectApps
