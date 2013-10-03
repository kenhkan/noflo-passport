noflo = require 'noflo'
passport = require 'passport'
{ OAuth2Strategy } = require 'passport-oauth'

class OAuthTwoStrategy extends noflo.Component
  constructor: ->
    @inPorts =
      in: new noflo.Port 'string'
      return: new noflo.Port 'object'
      payload: new noflo.Port 'object'
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
    @inPorts.in.on 'data', (@name) =>
    @inPorts.in.on 'disconnect', =>
      payload = @payload

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
          payload: payload
          accessToken: accessToken
          refreshToken: refreshToken
          profile: profile
          callback: done
        @outPorts.out.disconnect()

      # Assign the strategy
      passport.use @name, strategy

    # Save all payload
    @inPorts.payload.on 'connect', =>
      @payload = []
    @inPorts.payload.on 'data', (data) =>
      @payload.push data

    # Continue with the request transaction
    @inPorts.return.on 'data', (data) =>
      data.callback data.error, data.user

exports.getComponent = -> new OAuthTwoStrategy
