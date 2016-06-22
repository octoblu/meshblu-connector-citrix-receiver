{EventEmitter} = require 'events'
ReceiverManager = require '../src/receiver-manager'

describe 'ReceiverManager', ->
  beforeEach (done) ->
    @sut = new ReceiverManager
    @sut.IS_WINDOWS = true
    @proc = new EventEmitter
    @proc.stdout = new EventEmitter
    @proc.stderr = new EventEmitter
    @sut.spawn = sinon.spy (command, args) =>
      setTimeout (=> @proc.emit 'close'), 10
      @proc
    {@spawn} = @sut
    @sut.connect receiverPath: 'hi', done

  describe '->disconnectApps', ->
    beforeEach (done) ->
      @sut.disconnectApps (error, @data) =>
        done error

    it 'should call spawn', ->
      expect(@spawn).to.have.been.calledWith 'hi', ['-disconnectapps']

    it 'should return data', ->
      expect(@data).to.exist

  describe '->logoff', ->
    beforeEach (done) ->
      @sut.logoff (error, @data) =>
        done error

    it 'should call spawn', ->
      expect(@spawn).to.have.been.calledWith 'hi', ['-logoff']

    it 'should return data', ->
      expect(@data).to.exist

  describe '->openApplication', ->
    beforeEach (done) ->
      @sut.openApplication application: 'app', (error, @data) =>
        done error

    it 'should call spawn', ->
      expect(@spawn).to.have.been.calledWith 'hi', ['-launch', '-name', 'app']

    it 'should return data', ->
      expect(@data).to.exist

  describe '->poll', ->
    beforeEach (done) ->
      @sut.poll (error, @data) =>
        done error

    it 'should call spawn', ->
      expect(@spawn).to.have.been.calledWith 'hi', ['-poll']

    it 'should return data', ->
      expect(@data).to.exist

  describe '->reconnectApps', ->
    beforeEach (done) ->
      @sut.reconnectApps (error, @data) =>
        done error

    it 'should call spawn', ->
      expect(@spawn).to.have.been.calledWith 'hi', ['-reconnectapps']

    it 'should return data', ->
      expect(@data).to.exist

  describe '->startReceiver', ->
    beforeEach (done) ->
      @sut.startReceiver (error, @data) =>
        done error

    it 'should call spawn', ->
      expect(@spawn).to.have.been.calledWith 'hi'

    it 'should return data', ->
      expect(@data).to.exist
