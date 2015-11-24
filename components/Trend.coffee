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
      if data.params.startMonth?
        range =
          startMonth: data.params.startMonth
          startYear: data.params.startYear
          endMonth: data.params.endMonth
          endYear: data.params.endYear
        @outPorts.res.send data.res
        @outPorts.withrange.send range
        @outPorts.res.disconnect()
        @outPorts.withrange.disconnect()
      else
        @outPorts.res.send data.res
        @outPorts.withoutrange.send data.params
        @outPorts.res.disconnect()
        @outPorts.withoutrange.disconnect()

exports.getComponent = -> new Trend