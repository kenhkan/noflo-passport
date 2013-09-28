noflo = require 'noflo'
passport = require 'passport'
passportOAuth = require 'passport-oauth'

class OAuth2 extends noflo.Component
  constructor: ->
    @inPorts =
      in: new noflo.Port
    @outPorts =
      out: new noflo.Port

exports.getComponent = -> new OAuth2
