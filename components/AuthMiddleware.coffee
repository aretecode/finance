passport = require 'passport'
Strategy = require('passport-http-bearer').Strategy
{ExtendedComponent} = require './../src/Finance.coffee'

exports.getComponent = ->
  c = new ExtendedComponent
    outPorts:
      app:
        datatype: 'object'
        required: true
        caching: true
        description: 'Configured Express Application'
      error:
        datatype: 'object'

  c.description = 'Adds very basic auth'
  c.icon = 'lock'

  c.addInOnData 'app',
    datatype: 'object'
    description: 'Express Application'
  , (app) ->
    try
      records = [
        {
          id: 1,
          username: process.env.AUTH_USERNAME,
          token: process.env.AUTH_TOKEN,
          emails: [ { value: process.env.AUTH_EMAIL } ]
        }
      ]

      findByToken = (token, cb) ->
        process.nextTick ->
          for i in [0 .. records.length]
            if records[i]? and records[i].token is token
              return cb null, records[i]
          return cb null, null
      passport.use new Strategy (token, cb) ->
        findByToken token, (err, user) ->
          return cb err if err
          return cb null, false if !user
          return cb null, user
      app.all '*', passport.authenticate('bearer', session: false), (req, res, next) ->
        next()

      c.sendThenDisc app
    catch e
      return c.error new Error "Could not setup (Auth) server: #{e.message}"

  c
