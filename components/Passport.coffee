noflo = require 'noflo'
passport = require 'passport'

class Passport extends noflo.Component
  constructor: ->
    @session = false

    @inPorts =
      in: new noflo.Port
      session: new noflo.Port
    @outPorts =
      out: new noflo.Port

    @inPorts.session.on 'data', (session) =>
      @session = session is 'true'

    @inPorts.in.on 'begingroup', (group) =>
      @outPorts.out.beginGroup group
    @inPorts.in.on 'endgroup', (group) =>
      @outPorts.out.endGroup()

    @inPorts.in.on 'data', (@request) =>

    @inPorts.in.on 'disconnect', =>
      { req, res } = @request

      passport.initialize() req, res, (e) =>
        throw e if e?

        # Apply session middleware
        if @session
          passport.session() req, res, (e) =>
            throw e if e?
            @forward()

        else
          @forward()

  forward: ->
    @outPorts.out.send @request
    @outPorts.out.disconnect()
    @request = null

exports.getComponent = -> new Passport