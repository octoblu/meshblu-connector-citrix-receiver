{afterEach, beforeEach, describe, it} = global
{expect} = require 'chai'
sinon = require 'sinon'

Connector = require '../'

describe 'Connector', ->
  beforeEach (done) ->
    logger =
      info: =>
      debug: =>
      warn: =>

    @sut = new Connector {logger}
    {@receiver} = @sut
    @receiver.connect = sinon.stub().yields null
    @sut.start {}, done

  afterEach (done) ->
    @sut.close done

  describe '->isOnline', ->
    it 'should yield running true', (done) ->
      @sut.isOnline (error, response) =>
        return done error if error?
        expect(response.running).to.be.true
        done()

  describe '->onConfig', ->
    beforeEach (done) ->
      options =
        receiverPath: 'hello'
        linuxUser: 'kung-foo'
        homeDirectory: '/home/kung-foo'
        display: ':1'
        storeUrl: 'https://go.gone.biz'
      @sut.onConfig {options}, done

    it 'should call receiver.connect', ->
      expect(@receiver.connect).to.have.been.calledWith
        receiverPath: 'hello'
        linuxUser: 'kung-foo'
        homeDirectory: '/home/kung-foo'
        display: ':1'
        storeUrl: 'https://go.gone.biz'

  describe '->openApplication', ->
    beforeEach (done) ->
      @receiver.openApplication = sinon.stub().yields null
      @sut.openApplication application: 'app', done

    it 'should call receiver.openApplication', ->
      expect(@receiver.openApplication).to.have.been.calledWith application: 'app'

  describe '->startReceiver', ->
    beforeEach (done) ->
      @receiver.startReceiver = sinon.stub().yields null
      @sut.startReceiver  done

    it 'should call receiver.startReceiver', ->
      expect(@receiver.startReceiver).to.have.been.called

  describe '->disconnectApps', ->
    beforeEach (done) ->
      @receiver.disconnectApps = sinon.stub().yields null
      @sut.disconnectApps  done

    it 'should call receiver.disconnectApps', ->
      expect(@receiver.disconnectApps).to.have.been.called

  describe '->reconnectApps', ->
    beforeEach (done) ->
      @receiver.reconnectApps = sinon.stub().yields null
      @sut.reconnectApps  done

    it 'should call receiver.reconnectApps', ->
      expect(@receiver.reconnectApps).to.have.been.called

  describe '->logoff', ->
    beforeEach (done) ->
      @receiver.logoff = sinon.stub().yields null
      @sut.logoff  done

    it 'should call receiver.logoff', ->
      expect(@receiver.logoff).to.have.been.called

  describe '->poll', ->
    beforeEach (done) ->
      @receiver.poll = sinon.stub().yields null
      @sut.poll  done

    it 'should call receiver.poll', ->
      expect(@receiver.poll).to.have.been.called
