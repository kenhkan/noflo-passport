noflo = require 'noflo'
passport = require 'passport'
#passportOAuth = require 'passport-oauth'
passportOAuth =
  OAuth2Strategy: require 'passport-oauth2'

class OAuthTwo extends noflo.Component
  constructor: ->
    @inPorts =
      in: new noflo.Port
      user: new noflo.Port
      name: new noflo.Port
      access: new noflo.Port
      auth: new noflo.Port
      callback: new noflo.Port
      request: new noflo.Port # TODO: implement this
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
        authorizationURL: 'https://pixbi.myshopify.com/admin/oauth/authorize'
        tokenURL: 'https://pixbi.myshopify.com/admin/oauth/access_token'
        clientID: @key
        clientSecret: @secret
        callbackURL: 'http://localhost:5000/shopify/callback'
      #strategy = new passportOAuth.OAuth2Strategy
      #  authorizationURL: @authUrl
      #  tokenURL: @accessUrl
      #  clientID: @key
      #  clientSecret: @secret
      #  callbackURL: @callbackUrl
      # Verify callback
      , (accessToken, refreshToken, profile, done) =>
        console.log '*** VERIFYING'
        console.log refreshToken
        console.log profile
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
      console.log '*** RETURNING'
      data.callback null, false
      #id: '5243adbf5d6be77b3101bac5'
      #name: 'Pixbi store'
      # TODO: restore
      #data.callback data.error, data.user
      console.log 'RETURN DONE'

exports.getComponent = -> new OAuthTwo
