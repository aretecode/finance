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
    console.log event
    return unless event is 'data'
    console.log 'is data, sending out'
    c.outPorts.out.send '5023'
    console.log 'socket-> to: ', c.outPorts.out.sockets[0].to

    console.log 'called after sending'

    c.outPorts.out.disconnect()
    runTests()

    # console.log c.outPorts.after
    c.outPorts.after.send '5023'
    console.log 'sent out after port'
    console.log 'socket-> after to: ', c.outPorts.after.sockets[0].to
    # console.log c.outPorts.after
    c.outPorts.after.disconnect()
    console.log 'disconnected after port'

  c.outPorts.add 'out'
  c.outPorts.add 'after'

  return c
