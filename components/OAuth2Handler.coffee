noflo = require 'noflo'
passport = require 'passport'

class OAuth2Handler extends noflo.Component
  constructor: ->
    @inPorts =
      in: new noflo.Port
      provider: new noflo.Port
      success: new noflo.Port
      failure: new noflo.Port
    @outPorts =
      out: new noflo.Port

    @inPorts.provider.on 'data', (@provider) =>
    @inPorts.success.on 'data', (@success) =>
    @inPorts.failure.on 'data', (@failure) =>

    @inPorts.in.on 'begingroup', (group) =>
      @outPorts.out.beginGroup group
    @inPorts.in.on 'endgroup', (group) =>
      @outPorts.out.endGroup()

    @inPorts.in.on 'data', (data) =>
      throw new Error 'Missing provider' unless @provider?

      options = {}
      options.successRedirect = @success if @success?
      options.failureRedirect = @failure if @failure?

      passport.authenticate @provider, options

      @outPorts.out.send data

    @inPorts.in.on 'disconnect', =>
      @outPorts.out.disconnect()

exports.getComponent = -> new OAuth2Handler
