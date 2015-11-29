noflo = require 'noflo'
{ExtendedComponent} = require './../src/Finance.coffee'

exports.getComponent = ->
  c = new ExtendedComponent
  c.icon = "database"
  c.description = "PostgreSQL Knexjs Connection"

  c.inPorts.addOn 'any',
    datatype: 'object'
    description: '@TODO: use nothing (on outPorts.connect?)'
    on: 'connect'
  , (app) ->
    conn =
      host: process.env.DATABASE_HOST
      user: process.env.DATABASE_USER
      password: process.env.DATABASE_PASSWORD
      database: process.env.DATABASE_NAME
      charset: 'utf8'
    pg = require('knex')(client: 'pg', connection: conn, debug: false)
    c.outPorts.out.send pg
    c.outPorts.out.disconnect()

  c.outPorts.add 'conn',
    datatype: 'object'
    required: true
    caching: true
    description: 'Connection obj'
  c.outPorts.add 'error', datatype: 'object'

  c
