http = require 'http'

class StartReceiver
  constructor: ({@connector}) ->
    throw new Error 'StartReceiver requires connector' unless @connector?

  do: (message, callback) =>
    @connector.startReceiver callback

module.exports = StartReceiver
