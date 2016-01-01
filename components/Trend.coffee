finance = require './../src/Finance.coffee'

exports.getComponent = ->
  c = new finance.ExtendedComponent()
  c.description = 'Trend'
  c.icon = 'line-chart'

  c.addInOnData 'in',
  datatype: 'object'
  , (data) ->
    unless data.query? and data.query.start?
      c.sendThenDisc 'withoutrange',
        req: data
      return

    start = new Date(data.query.start)
    end = new Date(data.query.end)
    range =
      startMonth: start.getMonth()+1
      startYear: start.getFullYear()
      endMonth: end.getMonth()+1
      endYear: end.getFullYear()

    c.sendThenDisc 'withrange',
      req: data
      latest: end
      range: range
      earliest: start

  c.outPorts.add 'withoutrange',
    datatype: 'object'
    required: true
  c.outPorts.add 'withrange',
    datatype: 'object'
    required: true

  c
