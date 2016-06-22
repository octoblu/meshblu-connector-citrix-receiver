http = require 'http'

class Poll
  constructor: ({@connector}) ->
    throw new Error 'Poll requires connector' unless @connector?

  do: (message, callback) =>
    @connector.poll callback

module.exports = Poll
