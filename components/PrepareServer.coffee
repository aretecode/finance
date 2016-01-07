http = require 'http'
finance = require './../src/Finance.coffee'

exports.getComponent = ->
  c = new finance.ExtendedComponent
  c.description = 'start the server, then trigger after'
  c.icon = 'cloud'

  c.addInOnData 'in', (payload) ->
    c.sendThenDisc process.env.PORT or 5023

  c.outPorts.add 'out', datatype: 'integer'

  c
