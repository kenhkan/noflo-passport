noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai' unless chai
  OAuth2Init = require '../components/OAuth2Init.coffee'
else
  OAuth2Init = require 'passport/components/OAuth2Init.js'

describe 'OAuth2Init component', ->
  globals = {}

  beforeEach ->
    globals.c = OAuth2Init.getComponent()
    globals.in = noflo.internalSocket.createSocket()
    globals.provider = noflo.internalSocket.createSocket()
    globals.c.inPorts.in.attach globals.in
    globals.c.inPorts.in.attach globals.provider
    globals.c.outPorts.out.attach globals.out

  describe 'when intantiated', ->
    it 'should have an input port', ->
      chai.expect(globals.c.inPorts.in).to.be.an 'object'
      chai.expect(globals.c.inPorts.provider).to.be.an 'object'
    it 'should have an output port', ->
      chai.expect(globals.c.outPorts.out).to.be.an 'object'
