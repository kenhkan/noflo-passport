noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai' unless chai
  OAuth2Handler = require '../components/OAuth2Handler.coffee'
else
  OAuth2Handler = require 'passport/components/OAuth2Handler.js'

describe 'OAuth2Handler component', ->
  globals = {}

  beforeEach ->
    globals.c = OAuth2Handler.getComponent()
    globals.in = noflo.internalSocket.createSocket()
    globals.provider = noflo.internalSocket.createSocket()
    globals.success = noflo.internalSocket.createSocket()
    globals.failure = noflo.internalSocket.createSocket()
    globals.c.inPorts.in.attach globals.in
    globals.c.inPorts.in.attach globals.provider
    globals.c.inPorts.in.attach globals.success
    globals.c.inPorts.in.attach globals.failure
    globals.c.outPorts.out.attach globals.out

  describe 'when intantiated', ->
    it 'should have an input port', ->
      chai.expect(globals.c.inPorts.in).to.be.an 'object'
      chai.expect(globals.c.inPorts.provider).to.be.an 'object'
      chai.expect(globals.c.inPorts.success).to.be.an 'object'
      chai.expect(globals.c.inPorts.failure).to.be.an 'object'
    it 'should have an output port', ->
      chai.expect(globals.c.outPorts.out).to.be.an 'object'
