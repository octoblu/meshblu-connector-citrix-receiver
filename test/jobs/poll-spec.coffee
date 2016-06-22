{job} = require '../../jobs/poll'

describe 'Poll', ->
  context 'when given a valid message', ->
    beforeEach (done) ->
      @connector =
        poll: sinon.stub().yields null
      message = {}
      @sut = new job {@connector}
      @sut.do message, (@error) =>
        done()

    it 'should not error', ->
      expect(@error).not.to.exist

    it 'should call connector.poll', ->
      expect(@connector.poll).to.have.been.called
