switch process.platform
  when 'linux'
    module.exports = require './receiver-managers/linux-receiver-manager'
    return
  else
    module.exports = require './receiver-managers/windows-receiver-manager'
    return
