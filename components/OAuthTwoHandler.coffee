noflo = require 'noflo'
passport = require 'passport'

class OAuthTwoHandler extends noflo.Component
  constructor: ->
    @session = true

    @inPorts =
      in: new noflo.Port
      provider: new noflo.Port
      session: new noflo.Port
      success: new noflo.Port
      failure: new noflo.Port
      scope: new noflo.Port
    @outPorts =
      out: new noflo.Port

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

      { req, res } = @request

      # Patch to placate Passport.js
      @patch req, res

      # Initialize
      passport.initialize() req, res, (e) =>
        throw e if e?

        # Authenticate
        authenticate = =>
          options =
            session: @session
            scope: @scopes
            successRedirect: @success
            failureRedirect: @failure

          passport.authenticate(@provider, options) req, res, (e) =>
            throw e if e?
            @outPorts.out.send @request
            @outPorts.out.disconnect()

        # Use Passport.js session middleware if desired
        if @session
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
