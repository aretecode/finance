uuid = require 'uuid'
finance = require './../src/Finance.coffee'

exports.getComponent = ->
  c = new finance.ExtendedComponent

  c.inPorts.addOnData 'in', (dataIn) ->
    id = uuid.v4()
    body =
      currency: 'cad'
      amount: 100
      tags: ['canadian', 'eh']
      created_at: Date.now()
      description: 'example-description'
      type: 'expense'
      id: id

    data =
      body: body
      options:
        method: 'POST'
        path: '/api/expenses'
      statusCode: 201
      cb: (message, body) ->
        console.log body, message

    c.sendThenDisconnect data
  c
