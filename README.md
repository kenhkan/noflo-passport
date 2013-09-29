# Passport.js on NoFlo <br/>[![Build Status](https://secure.travis-ci.org/kenhkan/noflo-passport.png?branch=master)](http://travis-ci.org/kenhkan/noflo-passport) [![Dependency Status](https://david-dm.org/kenhkan/noflo-passport.png)](https://david-dm.org/kenhkan/noflo-passport) [![NPM version](https://badge.fury.io/js/noflo-passport.png)](http://badge.fury.io/js/noflo-passport) [![Stories in Ready](https://badge.waffle.io/kenhkan/noflo-passport.png)](http://waffle.io/kenhkan/noflo-passport)

Authenticate your users with NoFlo! This is built on top of
[Passport.js](http://passportjs.org/) for basic HTTP authentication with
username/password, OpenID, OAuth, etc.

This package adheres to
[noflo-webserver](https://github.com/noflo/noflo-webserver/) convention of a
request object:

    {
      "req": <the request>
      "res": <the response>
    }

*NOTE*: you MUST enable querystring by passing incoming requests through a
`webserver/Query` for noflo-passport to work!

## Installation

`npm install --save noflo-passport`

## Usage

* [passport/OAuthTwoStrategy](#OAuthTwoStrategy)
* [passport/OAuthTwoHandler](#OAuthTwoHandler)

Listed in-ports in bold are required and out-ports in bold always produce IPs.


### OAuthTwoStrategy

Implements OAuth 2.0 using `passport-oauth` strategy as outlined
[here](http://passportjs.org/guide/oauth/). This component configures a
provider for use.

Most of the ports accept configuration packets, most likely only once in the
lifetime of the program. However, they may also be sent new configuration
packets dynamically for situations like when the provider's authentication URLs
are dependent upon the user's ID in their identity database.

The 'IN' in-port takes whatever you feed it and spits that out along with the
tokens and profile upon every authentication. This is to provide a mechanism to
identify a transaction when the provider does not return anything in the
profile along with the tokens. The data it receives persists until new data is
fed to it.

Because Passport.js requires a user object to be returned, there is a 'RETURN'
in-port accepting the user object, the one sent by 'OUT' with a 'user'
attribute. It then closes the connection by continuing with the HTTP request
flow.

#### In-Ports

* *IN*: IPs passed here will be forwarded as an array of IPs to OUT with the
  resulting tokens.
* *RETURN*: Passport.js expects a user object to be passed to it when the token
  is consumed. For each OUT it must eventually return to RETURN to complete the
  transaction!
* *NAME*: The name to assign an OAuth2 strategy with Passport.js. Pass this in
  *last* as this would perform the assignment.
* *ACCESS*: The URL to request the access token. See "accessTokenURL" in
  Passport.js documentation
* *AUTH*: The URL to authenticate the user. See "userAuthorizationURL" in
  Passport.js documentation
* *CALLBACK*: The URL for the provider to call back. This should ultimately lead
  to an `passport/OAuthTwoHandler` process
* *KEY*: The consumer key
* *SECRET*: The consumer secret

#### Out-Ports

* *OUT*: An object containing the IPs sent to 'IN', the access token, the
  refresh token, the profile, and the verify callback.

### OAuthTwoHandler

This component handles incoming request in the OAuth handshake. it expects a
request object, middleware-style. Attach this to a `webserver/Server` instance.

*NOTE*: you MUST enable querystring by passing incoming requests through a
`webserver/Query` for noflo-passport to work!

#### In-Ports

* *IN*: The request object
* *PROVIDER*: The name of the provider to authenticate against
* SESSION: Whether to enable session. Default to true
* SCOPE: Specify OAuth2 scopes. Each IP is one scope.
* SUCCESS: The URL to redirect upon success
* FAILURE: The URL to redirect upon failure

#### Out-Ports

* *OUT*: The request object
