noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai' unless chai
  OAuth2 = require '../components/OAuth2.coffee'
else
  OAuth2 = require 'passport/components/OAuth2.js'

describe 'OAuth2 component', ->
  globals = {}

  beforeEach ->
    globals.c = OAuth2.getComponent()
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
    globals.c.inPorts.in.attach globals.user
    globals.c.inPorts.in.attach globals.name
    globals.c.inPorts.in.attach globals.access
    globals.c.inPorts.in.attach globals.auth
    globals.c.inPorts.in.attach globals.callback
    globals.c.inPorts.in.attach globals.key
    globals.c.inPorts.in.attach globals.secret
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
