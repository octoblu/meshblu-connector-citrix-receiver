{job} = require '../../jobs/start-receiver'

describe 'StartReceiver', ->
  context 'when given a valid message', ->
    beforeEach (done) ->
      @connector =
        startReceiver: sinon.stub().yields null
      message = {}
      @sut = new job {@connector}
      @sut.do message, (@error) =>
        done()

    it 'should not error', ->
      expect(@error).not.to.exist

    it 'should call connector.startReceiver', ->
      expect(@connector.startReceiver).to.have.been.called
