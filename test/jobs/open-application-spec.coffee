{job} = require '../../jobs/open-application'

describe 'OpenApplication', ->
  context 'when given a valid message', ->
    beforeEach (done) ->
      @connector =
        openApplication: sinon.stub().yields null
      message =
        data:
          application: 'app'
      @sut = new job {@connector}
      @sut.do message, (@error) =>
        done()

    it 'should not error', ->
      expect(@error).not.to.exist

    it 'should call connector.openApplication', ->
      expect(@connector.openApplication).to.have.been.calledWith application: 'app'

  context 'when given an invalid message', ->
    beforeEach (done) ->
      @connector = {}
      message = {}
      @sut = new job {@connector}
      @sut.do message, (@error) =>
        done()

    it 'should error', ->
      expect(@error).to.exist
