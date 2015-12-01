noflo = require 'noflo'
moment = require 'moment'

class AlphaOmegaEntries extends noflo.Component
  description: 'Earliest & latest dates'
  icon: 'database'

  constructor: ->
    @inPorts = new noflo.InPorts
      in:
        datatype: 'all'
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'object'
        required: true
      error:
        datatype: 'object'

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

      sortedBy = (sorted) ->
        '(SELECT created_at FROM "finance_op" LIMIT 1)
        ORDER BY created_at ' + sorted
      earliestQ = sortedBy 'ASC'
      latestQ = sortedBy 'DESC'
      @pg.raw(earliestQ).then (earliest) ->
        _this.pg.raw(latestQ).then (latest) ->
          _this.outPorts.out.send
            earliest: earliest.rows[0].created_at
            latest: latest.rows[0].created_at
          _this.outPorts.out.disconnect()
      .catch (e) ->
        _this.error
          error: e
          component: 'AlphaOmega'

exports.getComponent = -> new AlphaOmegaEntries
