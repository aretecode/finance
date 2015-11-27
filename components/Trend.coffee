noflo = require 'noflo'

class Trend extends noflo.Component
  description: 'Trend'
  icon: 'graph'

  constructor: ->
    @pg = require('./../src/Persistence/connection.coffee').getPg()

    @inPorts = new noflo.InPorts
      req:
        datatype: 'object'
    @outPorts = new noflo.OutPorts
      withrange:
        datatype: 'all'
      withoutrange:
        datatype: 'all'
      error:
        datatype: 'object'
      res:
        datatype: 'object'
        description: 'Response object'

    @inPorts.req.on 'data', (data) =>
      @outPorts.res.send data.res

      if data.query? and data.query.start?
        start = new Date(data.query.start)
        end = new Date(data.query.end)
        range =
          startMonth: start.getMonth()+1
          startYear: start.getFullYear()
          endMonth: end.getMonth()+1
          endYear: end.getFullYear()
        @outPorts.withrange.send
          earliest: start
          latest: end
          range: range

        @outPorts.res.disconnect()
        @outPorts.withrange.disconnect()
      else
        @outPorts.withoutrange.send data.query
        @outPorts.res.disconnect()
        @outPorts.withoutrange.disconnect()

exports.getComponent = -> new Trend
