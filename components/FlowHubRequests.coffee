uuid = require 'uuid'
finance = require './../src/Finance.coffee'
id = uuid.v4()

# @TODO
# [ ] create FlowHubRequests ports dynamically
# [x] change FlowHubRequests ports to go into the facade instead
# [ ] change to use a group?
# [ ] add filters
exports.getComponent = ->
  c = new finance.ExtendedComponent
  c.description = 'send basic prebuilt test requests'
  c.icon = 'street-view'

  c.addInOnData 'create', (data) ->
    c.sendThenDisconnect 'create',
      body:
        currency: 'cad'
        amount: 100
        tags: ['canadian', 'eh', 'beginning']
        created_at: Date('2004-10-01')
        type: 'expense'
        id: id
      cb: (message, body) ->

  c.addInOnData 'retrieve', (data) ->
    c.sendThenDisconnect 'retrieve',
      id: id
      cb: (message, body) ->

  c.addInOnData 'update', (data) ->
    c.sendThenDisconnect 'update',
      body:
        currency: 'eur'
        amount: 50
        tags: ['canadian', 'eh', 'updated', 'euro']
        type: 'expense'
        id: id
      cb: (message, body) ->

  c.addInOnData 'delete', (data) ->
    c.sendThenDisconnect 'delete',
      id: id
      cb: (message, body) ->

  c.addInOnData 'list', (data) ->
    c.sendThenDisconnect 'delete',
      cb: (message, body) ->

  c.addInOnData 'monthly', (data) ->
    c.sendThenDisconnect 'monthly',
      cb: (message, body) ->

  c.addInOnData 'trend', (data) ->
    c.sendThenDisconnect 'trend',
      cb: (message, body) ->

  c.outPorts.add 'create'
  c.outPorts.add 'retrieve'
  c.outPorts.add 'update'
  c.outPorts.add 'delete'
  c.outPorts.add 'list'
  c.outPorts.add 'monthly'
  c.outPorts.add 'trend'

  c
