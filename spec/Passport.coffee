noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai' unless chai
  Passport = require '../components/Passport.coffee'
else
  Passport = require 'passport/components/Passport.js'

describe 'Passport component', ->
  globals = {}

  beforeEach ->
    globals.c = Passport.getComponent()
    globals.in = noflo.internalSocket.createSocket()
    globals.session = noflo.internalSocket.createSocket()
    globals.c.inPorts.in.attach globals.in
    globals.c.inPorts.in.attach globals.session
    globals.c.outPorts.out.attach globals.out

  describe 'when instantiated', ->
    it 'should have an input port', ->
      chai.expect(globals.c.inPorts.in).to.be.an 'object'
      chai.expect(globals.c.inPorts.session).to.be.an 'object'
    it 'should have an output port', ->
      chai.expect(globals.c.outPorts.out).to.be.an 'object'
