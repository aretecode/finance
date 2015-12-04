noflo = require 'noflo'
moment = require 'moment'
finance = require './../src/Finance.coffee'

class AlphaOmegaEntries extends finance.ExtendedComponent
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
      @pg = finance.getConnection()

      sortedBy = (sorted) ->
        '(SELECT created_at FROM "finance_op" LIMIT 1)
        ORDER BY created_at ' + sorted
      earliestQ = sortedBy 'ASC'
      latestQ = sortedBy 'DESC'
      @pg.raw(earliestQ).then (earliest) =>
        @pg.raw(latestQ).then (latest) =>
          @sendThenDisc
            req: data.req
            earliest: earliest.rows[0].created_at
            latest: latest.rows[0].created_at
          @pg.destroy()
      .catch (e) =>
        @pg.destroy()
        @error
          req: data.req
          error: e
          component: 'AlphaOmega'

exports.getComponent = -> new AlphaOmegaEntries
