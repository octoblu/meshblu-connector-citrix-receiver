http = require 'http'

class OpenApplication
  constructor: ({@connector}) ->
    throw new Error 'OpenApplication requires connector' unless @connector?

  do: ({data}, callback) =>
    return callback @_userError(422, 'data.application is required') unless data?.application?

    {application} = data
    @connector.openApplication {application}, callback

  _userError: (code, message) =>
    error = new Error message
    error.code = code
    return error

module.exports = OpenApplication
