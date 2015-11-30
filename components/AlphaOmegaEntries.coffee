noflo = require 'noflo'

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
      @pg = require('./../src/Persistence/connection.coffee').getPg()
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
