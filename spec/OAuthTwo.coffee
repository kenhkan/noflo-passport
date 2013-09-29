noflo = require 'noflo'
chai = require 'chai' unless chai
OAuthTwo = require '../components/OAuthTwo.coffee'

describe 'OAuthTwo component', ->
  globals = {}

  beforeEach ->
    globals.c = OAuthTwo.getComponent()
    globals.in = noflo.internalSocket.createSocket()
    globals.user = noflo.internalSocket.createSocket()
    globals.name = noflo.internalSocket.createSocket()
    globals.access = noflo.internalSocket.createSocket()
    globals.auth = noflo.internalSocket.createSocket()
    globals.callback = noflo.internalSocket.createSocket()
    globals.key = noflo.internalSocket.createSocket()
    globals.secret = noflo.internalSocket.createSocket()
    globals.out = noflo.internalSocket.createSocket()
    globals.c.inPorts.in.attach globals.in
    globals.c.inPorts.user.attach globals.user
    globals.c.inPorts.name.attach globals.name
    globals.c.inPorts.access.attach globals.access
    globals.c.inPorts.auth.attach globals.auth
    globals.c.inPorts.callback.attach globals.callback
    globals.c.inPorts.key.attach globals.key
    globals.c.inPorts.secret.attach globals.secret
    globals.c.outPorts.out.attach globals.out

  describe 'when instantiated', ->
    it 'should have an input port', ->
      chai.expect(globals.c.inPorts.in).to.be.an 'object'
      chai.expect(globals.c.inPorts.user).to.be.an 'object'
      chai.expect(globals.c.inPorts.name).to.be.an 'object'
      chai.expect(globals.c.inPorts.access).to.be.an 'object'
      chai.expect(globals.c.inPorts.auth).to.be.an 'object'
      chai.expect(globals.c.inPorts.callback).to.be.an 'object'
      chai.expect(globals.c.inPorts.key).to.be.an 'object'
      chai.expect(globals.c.inPorts.secret).to.be.an 'object'
    it 'should have an output port', ->
      chai.expect(globals.c.outPorts.out).to.be.an 'object'
