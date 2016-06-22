http = require 'http'

class Logoff
  constructor: ({@connector}) ->
    throw new Error 'Logoff requires connector' unless @connector?

  do: (message, callback) =>
    @connector.logoff callback

module.exports = Logoff
