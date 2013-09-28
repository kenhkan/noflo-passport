# Passport.js on NoFlo <br/>[![Build Status](https://secure.travis-ci.org/kenhkan/noflo-passport.png?branch=master)](http://travis-ci.org/kenhkan/noflo-passport) [![Dependency Status](https://david-dm.org/kenhkan/noflo-passport.png)](https://david-dm.org/kenhkan/noflo-passport) [![NPM version](https://badge.fury.io/js/noflo-passport.png)](http://badge.fury.io/js/noflo-passport) [![Stories in Ready](https://badge.waffle.io/kenhkan/noflo-passport.png)](http://waffle.io/kenhkan/noflo-passport)

Wrapper around [Passport.js](http://passportjs.org/)

This package adheres to
[noflo-webserver](https://github.com/noflo/noflo-webserver/) convention of a
request object:

    {
      "req": <the request>
      "res": <the response>
    }

## Installation

`npm install --save noflo-passport`

## Usage

* [passport/Passport](#Passport)
* [passport/OAuth2](#OAuth2)
* [passport/OAuth2Init](#OAuth2Init)
* [passport/OAuth2Callback](#OAuth2Callback)

Listed in-ports in bold are required and out-ports in bold always produce IPs.


### Passport

This must be placed after your
[noflo-webserver](https://github.com/noflo/noflo-webserver/) instance to use
Passport.js.

#### In-Ports

* *IN*: The incoming request, middleware-style
* SESSION: `true` if session is enabled. Default to `false`

#### Out-Ports

* *OUT*: The outgoing request, middleware-style


### OAuth2

Implements OAuth 2.0 using `passport-oauth` strategy as outlined
[here](http://passportjs.org/guide/oauth/). This component configures a
provider for use.

#### In-Ports

* *IN*: IPs passed here will be forwarded as-is to OUT with the resulting tokens.
* *USER*: Passport.js expects a user object to be passed to it when the token is
  consumed. For each OUT it must eventually return to USER to complete the
  transaction!
* *NAME*: The name to assign an OAuth2 strategy with Passport.js
* REQUEST: The URL to request a new token. See "requestTokenURL" in Passport.js
  documentation
* *ACCESS*: The URL to request the access token. See "accessTokenURL" in
  Passport.js documentation
* *AUTH*: The URL to authenticate the user. See "userAuthorizationURL" in
  Passport.js documentation
* *CALLBACK*: The URL for the provider to call back. This should ultimately lead
  to an `passport/OAuth2Callback` process
* *KEY*: The consumer key
* *SECRET*: The consumer secret

#### Out-Ports

* *OUT*: The IPs passed from IN
* *TOKEN*: The access token
* SECRET: The corresponding secret
* PROFILE: User profile if any

### OAuth2Init

OAuth2 takes two steps. The first is when user initiates authentication. This
component expects a request object, middleware-style.

#### In-Ports

* *IN*: The equivalent of invoking `passport.authenticate()` on the incoming
  request object
* *PROVIDER*: The name of the provider to authenticate against

#### Out-Ports

* *OUT*: The request object

### OAuth2Callback

This receives callback requests (the second step) from the identity provider to
complete the auth transaction. This component expects a request object,
middleware-style.

#### In-Ports

* *IN*: The equivalent of invoking `passport.authenticate()` on the incoming
  request object
* *PROVIDER*: The name of the provider to authenticate against
* SUCCESS: The URL to redirect upon success
* FAILURE: The URL to redirect upon failure

#### Out-Ports

* *OUT*: The request object
