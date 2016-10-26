{beforeEach, describe, it} = global
{expect} = require 'chai'
{EventEmitter} = require 'events'
sinon = require 'sinon'

LinuxReceiverManager = require '../src/receiver-managers/linux-receiver-manager'

describe 'LinuxReceiverManager', ->
  beforeEach (done) ->
    logger =
      info: =>
      debug: =>
      warn: =>

    @sut = new LinuxReceiverManager {logger}
    @sut.IS_WINDOWS = true
    @sut.spawn = sinon.spy =>
      proc = new EventEmitter
      proc.stdout = new EventEmitter
      proc.stderr = new EventEmitter
      setTimeout (=> proc.emit 'close', 0), 10
      proc
    {@spawn} = @sut
    @sut.connect receiverPath: '/bin/hi', linuxUser: 'foo', homeDirectory: '/home/foo', display: ':0', done

  describe '->disconnectApps', ->
    beforeEach (done) ->
      @sut.disconnectApps (error, @data) =>
        done error

    it 'should call spawn twice', ->
      expect(@spawn).to.have.been.calledWith 'sudo', [
        '--non-interactive'
        '--user', 'foo'
        '/bin/hi', '--liststores'
      ], {env: {DISPLAY: ':0', HOME: '/home/foo'}}
      # expect(@spawn).to.have.been.calledWith 'sudo', [
      #   '--non-interactive'
      #   '--user', 'foo'
      #   '--disconnect'
      # ], {env: {DISPLAY: ':0', HOME: '/home/foo'}}

    it 'should return data', ->
      expect(@data).to.exist
