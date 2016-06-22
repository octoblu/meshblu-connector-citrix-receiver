{job} = require '../../jobs/disconnect-apps'

describe 'DisconnectApps', ->
  context 'when given a valid message', ->
    beforeEach (done) ->
      @connector =
        disconnectApps: sinon.stub().yields null
      message = {}
      @sut = new job {@connector}
      @sut.do message, (@error) =>
        done()

    it 'should not error', ->
      expect(@error).not.to.exist

    it 'should call connector.disconnectApps', ->
      expect(@connector.disconnectApps).to.have.been.called
