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
      error:
        datatype: 'object'

    @inPorts.in.on 'data', (data) =>
      @pg = require('./../src/Persistence/connection.coffee').getPg()

      {outPorts, pg} = {@outPorts, @pg}
      sortedBy = (sorted) ->
        '(SELECT created_at FROM expense LIMIT 1)
        UNION (SELECT created_at FROM income LIMIT 1)
        ORDER BY created_at ' + sorted
      earliestQ = sortedBy 'DESC'
      latestQ = sortedBy 'ASC'
      @pg.raw(earliestQ).then (earliest) ->
        pg.raw(latestQ).then (latest) ->
          outPorts.out.send
            earliest: new Date(earliest.rows[0].created_at)
            latest: new Date(latest.rows[0].created_at)
          outPorts.out.disconnect()

exports.getComponent = -> new AlphaOmegaEntries