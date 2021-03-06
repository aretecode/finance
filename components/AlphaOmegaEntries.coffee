moment = require 'moment'
finance = require './../src/Finance.coffee'

class AlphaOmegaEntries extends finance.ExtendedComponent
  description: 'Earliest & latest dates'
  icon: 'database'

  constructor: ->
    @setInPorts
      in:
        datatype: 'all'
    @setOutPorts
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
          if earliest.rows.length is 0 or latest.rows.length is 0
            return @error
              message: 'could not find any with that range'
              req: data.req
              data: [earliest, latest]
              component: 'AlphaOmega'

          @sendThenDisc
            req: data.req
            earliest: earliest.rows[0].created_at
            latest: latest.rows[0].created_at
      .catch (e) =>
        @error
          req: data.req
          error: e
          component: 'AlphaOmega'

exports.getComponent = -> new AlphaOmegaEntries
