{job} = require '../../jobs/reconnect-apps'

describe 'ReconnectApps', ->
  context 'when given a valid message', ->
    beforeEach (done) ->
      @connector =
        reconnectApps: sinon.stub().yields null
      message = {}
      @sut = new job {@connector}
      @sut.do message, (@error) =>
        done()

    it 'should not error', ->
      expect(@error).not.to.exist

    it 'should call connector.reconnectApps', ->
      expect(@connector.reconnectApps).to.have.been.called
