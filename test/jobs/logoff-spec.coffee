{job} = require '../../jobs/logoff'

describe 'Logoff', ->
  context 'when given a valid message', ->
    beforeEach (done) ->
      @connector =
        logoff: sinon.stub().yields null
      message = {}
      @sut = new job {@connector}
      @sut.do message, (@error) =>
        done()

    it 'should not error', ->
      expect(@error).not.to.exist

    it 'should call connector.logoff', ->
      expect(@connector.logoff).to.have.been.called
