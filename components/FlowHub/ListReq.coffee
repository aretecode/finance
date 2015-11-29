finance = require './../src/Finance.coffee'

exports.getComponent = ->
  c = new finance.ExtendedComponent

  c.inPorts.addOnData 'in', (dataIn) ->
    data =
      options:
        method: 'GET'
        path: '/api/expenses'
      statusCode: 200
      cb: (message, body) ->
        console.log body, message

    c.sendThenDisconnect data
  c
