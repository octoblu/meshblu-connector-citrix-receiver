CitrixReceiver = require '../'

describe 'CitrixReceiver', ->
  beforeEach ->
    @sut = new CitrixReceiver

  describe '->start', ->
    it 'should be a method', ->
      expect(@sut.start).to.be.a 'function'

    describe 'when called with nothing', ->
      it 'should throw an error', ->
        expect(@sut.start).to.throw(Error)

    describe 'when called with a device', ->
      it 'should not throw an error', ->
        expect(=> @sut.start({ uuid: 'hello' })).to.not.throw(Error)


  describe '->onMessage', ->
    it 'should be a method', ->
      expect(@sut.onMessage).to.be.a 'function'


  describe '->onConfig', ->
    it 'should be a method', ->
      expect(@sut.onConfig).to.be.a 'function'

    describe 'when called with a config', ->
      it 'should not throw an error', ->
        expect(=> @sut.onConfig { type: 'hello' }).to.not.throw(Error)
