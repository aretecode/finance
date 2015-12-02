noflo = require 'noflo'
http = require 'http'
finance = require './../src/Finance.coffee'

exports.getComponent = ->
  c = new finance.ExtendedComponent
  c.description = 'start the server, then trigger after'
  c.icon = 'cloud'

  c.addInOnData 'in', (payload) ->
    port = (process.env.PORT||5023)
    c.sendThenDisc port

  c.outPorts.add 'out'

  c
