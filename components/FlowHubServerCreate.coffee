noflo = require 'noflo'
chai = require 'chai'
http = require 'http'
uuid = require 'uuid'

done = -> console.log ''
runTests = ->
  console.log 'run tests called'

exports.getComponent = ->
  c = new noflo.Component

  c.inPorts.add 'in', (event, payload) ->
    console.log 'started'
    return unless event is 'data'
    console.log 'is data, sending out'
    c.outPorts.out.send 5023

    console.log 'called after sending'

    c.outPorts.out.disconnect()
    runTests()

    c.outPorts.after.send 5023
    c.outPorts.after.disconnect()
    console.log 'sent out after port'

  c.outPorts.add 'out'
  c.outPorts.add 'after'

  return c
