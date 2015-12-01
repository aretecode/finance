noflo = require 'noflo'

class Database extends noflo.Component
  icon: 'database'

  setPg: ->
    conn =
      host: process.env.DATABASE_HOST
      user: process.env.DATABASE_USER
      password: process.env.DATABASE_PASSWORD
      database: process.env.DATABASE_NAME
      charset: 'utf8'
      port: 5432
    pool =
      min: 2
      max: 20
    @pg = require('knex')(client: 'pg', connection: conn, pool, debug: true)

  constructor: ->
    @inPorts = new noflo.InPorts
      in:
        datatype: 'object'
        description: 'Object being Stored'
      name:
        datatype: 'all'
        description: 'The name of the database
        /type-of-finance-operation (income, or expense)'
        required: true
      pg:
        datatype: 'object'
        description: 'Postgres knex database connection'

    @outPorts = new noflo.OutPorts
      out:
        datatype: 'object'
      error:
        datatype: 'object'
        description: 'sent through the error port
        if not valid. @TODO: add port for each param'

    @inPorts.name.on 'data', (@table) =>
    @inPorts.pg.on 'data', (@pg) =>

exports.getComponent = -> new Database
exports.Database = Database
