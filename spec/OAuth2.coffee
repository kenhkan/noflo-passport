noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai' unless chai
  OAuth2 = require '../components/OAuth2.coffee'
else
  OAuth2 = require 'passport/components/OAuth2.js'

describe 'OAuth2 component', ->
  globals =
    c: null
    ins: null
    out: null

  beforeEach ->
    globals.c = OAuth2.getComponent()
    globals.ins = noflo.internalSocket.createSocket()
    globals.out = noflo.internalSocket.createSocket()
    globals.c.inPorts.in.attach globals.ins
    globals.c.outPorts.out.attach globals.out

  describe 'when instantiated', ->
    it 'should have an input port', ->
      chai.expect(globals.c.inPorts.in).to.be.an 'object'
    it 'should have an output port', ->
      chai.expect(globals.c.outPorts.out).to.be.an 'object'
