noflo = require 'noflo'
passport = require 'passport'
passportOAuth = require 'passport-oauth'

class OAuth2Handler extends noflo.Component
  constructor: ->
    @inPorts =
      in: new noflo.Port
      user: new noflo.Port
      name: new noflo.Port
      access: new noflo.Port
      auth: new noflo.Port
      callback: new noflo.Port
      key: new noflo.Port
      secret: new noflo.Port
    @outPorts =
      out: new noflo.Port

    @inPorts.access.on 'data', (@accessUrl) =>
    @inPorts.auth.on 'data', (@authUrl) =>
    @inPorts.callback.on 'data', (@callbackUrl) =>
    @inPorts.key.on 'data', (@key) =>
    @inPorts.secret.on 'data', (@secret) =>

    # Provider name triggers strategy assignment
    @inPorts.name.on 'data', (@name) =>
    @inPorts.name.on 'disconnect', =>
      # Instantiate the strategy
      strategy = new passportOAuth.OAuth2Strategy
        authorizationURL: @authUrl
        tokenURL: @accessUrl
        clientID: @key
        clientSecret: @secret
        callbackURL: @callbackUrl

      # Assign the strategy
      passport.use @name, strategy, (accessToken,
                                     refreshToken,
                                     profile,
                                     done) =>
        # Forward object out
        @outPorts.out.send
          incoming: @incoming
          accessToken: accessToken
          refreshToken: refreshToken
          profile: profile
          callback: done
        @outPorts.out.disconnect()

        # Clean up
        @accessUrl = @authUrl = @callbackUrl = @key = @secret = @name = null

    # Save all incoming
    @inPorts.in.on 'connect', =>
      @incoming = []
    @inPorts.in.on 'data', (data) =>
      @incoming.push data

    # Continue with the request transaction
    @inPorts.user.on 'data', (data) =>
      data.callback data.error, data.user

exports.getComponent = -> new OAuth2Handler
