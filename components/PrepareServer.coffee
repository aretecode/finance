noflo = require 'noflo'
http = require 'http'
finance = require './../src/Finance.coffee'

exports.getComponent = ->
  c = new finance.ExtendedComponent
  c.description = 'start the server, then trigger after'
  c.icon = 'cloud'

  c.addInOnData 'in', (payload) ->
    c.outPorts.out.send '5023'
    c.outPorts.out.disconnect()

    c.outPorts.after.send '5023'
    c.outPorts.after.disconnect()

  c.outPorts.add 'out'
  c.outPorts.add 'after'

  c
