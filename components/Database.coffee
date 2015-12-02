noflo = require 'noflo'
finance = require './../src/Finance.coffee'

class Database extends finance.ExtendedComponent
  icon: 'database'

  setPg: ->
    @pg = finance.getConnection()

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
