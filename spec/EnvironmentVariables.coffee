noflo = require 'noflo'

exports.getComponent = ->
  c = new noflo.Component
  c.inPorts.add 'in', (event, payload) ->
    return unless event is 'data'
      
      # console.log process.env
      console.log process.env['DATABASE_NAME']
      console.log process.env['DATABASE_PASSWORD']
      console.log process.env['DATABASE_USER']
      console.log process.env['DATABASE_HOST']
      console.log process.env['AUTH_USERNAME']
      console.log process.env['AUTH_TOKEN']
      console.log process.env['AUTH_EMAIL']
      ###
      process.env['DATABASE_NAME'] = "postgres"
      process.env['DATABASE_PASSWORD'] = "___personalfinancepass123"
      process.env['DATABASE_USER'] = "postgres"
      process.env['DATABASE_HOST'] = "localhost"

      process.env['AUTH_USERNAME'] = "jack"
      process.env['AUTH_TOKEN'] = "123456789"
      process.env['AUTH_EMAIL'] = "jack@null.com"
      ###
      c.outPorts.out.send payload
  c.outPorts.add 'out'
  c