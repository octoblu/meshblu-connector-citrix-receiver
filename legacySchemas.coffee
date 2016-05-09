MESSAGE_SCHEMA =
  type: 'object'
  properties:
    command:
      type: 'string'
      required: true
      enum: [
        'open-application'
        'disconnectapps'
        'poll'
        'logoff'
        'reconnectapps'
      ]
      default: 'open-application'
    application:
      type: 'array'
      items: type: 'string'
      required: false
OPTIONS_SCHEMA =
  type: 'object'
  properties: receiverPath:
    type: 'string'
    required: true
    default: DEFAULT_RECEIVER_PATH

module.exports = {
  messageSchema: MESSAGE_SCHEMA
  optionsSchema: OPTIONS_SCHEMA
}
