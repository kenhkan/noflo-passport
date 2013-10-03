noflo = require 'noflo'
passport = require 'passport'

class OAuthTwoHandler extends noflo.Component
  constructor: ->
    @session = true

    @inPorts =
      in: new noflo.Port 'object'
      provider: new noflo.Port 'string'
      session: new noflo.Port 'string'
      success: new noflo.Port 'string'
      failure: new noflo.Port 'string'
      scope: new noflo.Port 'string'
    @outPorts =
      out: new noflo.Port 'object'

    @inPorts.provider.on 'data', (@provider) =>
    @inPorts.success.on 'data', (@success) =>
    @inPorts.failure.on 'data', (@failure) =>

    @inPorts.session.on 'data', (session) =>
      @session = session is 'true'

    @inPorts.scope.on 'connect', =>
      @scopes = []
    @inPorts.scope.on 'disconnect', =>
      delete @scopes unless @scopes.length > 0
    @inPorts.scope.on 'data', (scope) =>
      @scopes.push scope

    @inPorts.in.on 'data', (@request) =>
    @inPorts.in.on 'disconnect', =>
      throw new Error 'Missing provider' unless @provider?

      # Save for later
      { req, res } = @request
      provider = @provider
      session = @session
      scopes = @scopes
      success = @success
      failure = @failure

      # Patch to placate Passport.js
      @patch req, res

      # Initialize
      passport.initialize() req, res, =>
        # Authenticate
        authenticate = =>
          options =
            session: session
            scope: scopes
            success: success
            failure: failure

          # Authenticate the request
          passport.authenticate(provider, options) req, res, (e) =>
            # Redirect based on success or failure
            res.redirect if e then failure else success

            # Forward regardless though
            @outPorts.out.send
              req: req
              res: res
            @outPorts.out.disconnect()

        # Use Passport.js session middleware if desired
        if session
          passport.session() req, res, (e) =>
            throw e if e?
            authenticate()
        # Simply authenticate otherwise
        else
          authenticate()

  # Deal with bugs arising from inconsiderate libraries
  patch: (req, res) ->
    # Add `redirect(1)` support provided by Express that Passport.js requires
    res.redirect = (url) ->
      res.writeHead 302,
        'Location': url
      res.end()

exports.getComponent = -> new OAuthTwoHandler
