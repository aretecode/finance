noflo = require 'noflo'
{Database} = require './Database.coffee'

class Removed extends Database
  description: 'Find a finance operation.'
  icon: 'trash'

  constructor: ->
    super()
    @inPorts.in.on 'data', (data) =>
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

      hasId = id: data.id
      @pg('finance_op').where(hasId).del().then (result) ->
        _this.pg('tags').where(hasId).del()
        .then (tagResult) ->
          _this.outPorts.out.send
            success: result is 1
            data: result, tagResult
          _this.outPorts.out.disconnect()
      .catch (e) ->
        _this.error
          data: data
          error: e
          component: 'Removed'

exports.getComponent = -> new Removed
