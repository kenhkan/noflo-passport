noflo = require 'noflo'
passport = require 'passport'
{ OAuth2Strategy } = require 'passport-oauth'

class OAuthTwoStrategy extends noflo.Component
  constructor: ->
    @inPorts =
      in: new noflo.Port 'object'
      user: new noflo.Port 'object'
      name: new noflo.Port 'string'
      access: new noflo.Port 'string'
      auth: new noflo.Port 'string'
      callback: new noflo.Port 'string'
      key: new noflo.Port 'string'
      secret: new noflo.Port 'string'
    @outPorts =
      out: new noflo.Port 'object'

    @inPorts.access.on 'data', (@accessUrl) =>
    @inPorts.auth.on 'data', (@authUrl) =>
    @inPorts.callback.on 'data', (@callbackUrl) =>
    @inPorts.key.on 'data', (@key) =>
    @inPorts.secret.on 'data', (@secret) =>

    # Provider name triggers strategy assignment
    @inPorts.name.on 'data', (@name) =>
    @inPorts.name.on 'disconnect', =>
      # Instantiate the strategy
      strategy = new OAuth2Strategy
        authorizationURL: @authUrl
        tokenURL: @accessUrl
        clientID: @key
        clientSecret: @secret
        callbackURL: @callbackUrl
      # Verify callback
      , (accessToken, refreshToken, profile, done) =>
        @outPorts.out.send
          incoming: @incoming
          accessToken: accessToken
          refreshToken: refreshToken
          profile: profile
          callback: done
        @outPorts.out.disconnect()

        # Clean up
        @accessUrl = @authUrl = @callbackUrl = @key = @secret = @name = null

      # Assign the strategy
      passport.use @name, strategy

    # Save all incoming
    @inPorts.in.on 'connect', =>
      @incoming = []
    @inPorts.in.on 'data', (data) =>
      @incoming.push data

    # Continue with the request transaction
    @inPorts.user.on 'data', (data) =>
      data.callback data.error, data.user

exports.getComponent = -> new OAuthTwoStrategy
