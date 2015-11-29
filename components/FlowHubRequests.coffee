uuid = require 'uuid'
finance = require './../src/Finance.coffee'

# insteadof using a cb, could pass it onto a receive but eh
exports.getComponent = ->
  id = uuid.v4()

  c = new finance.ExtendedComponent
  c.inPorts.addOn 'facader', {on: 'data'}, (payload) ->
    c.sendThenDisconnect 'create',
      body:
        currency: 'cad'
        amount: 100
        tags: ['canadian', 'eh']
        created_at: Date.now()
        description: 'example-description'
        type: 'expense'
        id: id
      cb: (message, body) ->
        console.log body, message

    c.sendThenDisconnect 'update',
      body:
        currency: 'usd'
        amount: 10
        tags: ['canadian', 'eh', 'updared']
        created_at: Date.now()
        description: 'example-updated-description'
        type: 'expense'
        id: id
      cb: (message, body) ->
        console.log body, message

    c.sendThenDisconnect 'retrieve',
      id: id
      cb: (message, body) ->
        console.log body, message

    c.sendThenDisconnect 'delete',
      id: id
      cb: (message, body) ->
        console.log body, message

    c.sendThenDisconnect 'list',
      cb: (message, body) ->
        # console.log body, message

    c.sendThenDisconnect 'monthly',
      cb: (message, body) ->
        console.log body, message

    c.sendThenDisconnect 'trend',
      cb: (message, body) ->
        console.log body, message
  c
