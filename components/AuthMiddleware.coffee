noflo = require 'noflo'
passport = require 'passport'
Strategy = require('passport-http-bearer').Strategy

exports.getComponent = ->
  c = new noflo.Component
  c.description = "Adds very basic auth"

  c.inPorts.add 'app',
    datatype: 'object'
    description: 'Express Application'
  , (event, app) ->
    return unless event is 'data'
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
            return cb(null, records[i]) if records[i].token is token
          return cb(null, null)
      passport.use new Strategy (token, cb) ->
        findByToken token, (err, user) ->
          return cb err if err
          return cb null, false if !user
          return cb null, user
      app.get '*', passport.authenticate('bearer', session: false),
      (req, res, next) ->
        next()

      c.outPorts.app.send app
      c.outPorts.app.disconnect()
    catch e
      return c.error new Error "Could not setup server: #{e.message}"

  c.outPorts.add 'app',
    datatype: 'object'
    required: true
    caching: true
    description: 'Configured Express Application'
  c.outPorts.add 'error', datatype: 'object'

  return c