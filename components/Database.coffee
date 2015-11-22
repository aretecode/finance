noflo = require 'noflo'

class Database extends noflo.Component
  icon: 'database'

  constructor: ->
    @inPorts = new noflo.InPorts
      in:
        datatype: 'object'
        description: 'Object being Stored'
      name:
        datatype: 'all'
        description: 'The name of the database
        /type-of-finance-operation (income, or expense)'
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

    @inPorts.name.on 'data', (data) =>
      @table = data

    @inPorts.pg.on 'data', (data) =>
      @pg = data

    @inPorts.in.on 'connect', =>
      @outPorts.out.connect()
    @inPorts.in.on 'begingroup', (group) =>
      @outPorts.out.beginGroup group
    @inPorts.in.on 'endgroup', =>
      @outPorts.out.endGroup()

    unless typeof @childConstructor "undefined"
      @childConstructor()

exports.getComponent = -> new Database
exports.Database = Database