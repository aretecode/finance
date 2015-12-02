finance = require './../src/Finance.coffee'

describe 'NoFlo extension', ->
  it '`ExtendedComponent` should be able to use `addOn` an object', ->
    c = new finance.ExtendedComponent
    c.inPorts.addOn 'awesomein', (data) ->
      console.log data
    c.inPorts.addOn 'objin', {on: 'data'}, (data) ->
      console.log data
    c.inPorts.addOn 'microin',
      data: (data) ->
        console.log data
        c.outPorts.sendThenDiscon 'out', data

    c.inPorts.addOn 'arrayin', {on: ['data', 'connect']}, (data, event) ->
      console.log data
    c.inPorts.addOn 'arrayinwoevent', {on: ['data', 'connect']}, (data) ->
      console.log data
    c.addInOn 'short', {on: 'data'}, (data) ->
      c.sendThenDiscon 'out', data
    c.addInOnData 'favorite', (data) ->
      # automatically chooses first valid outport, useful with only 1
      c.sendThenDiscon data

    c.outPorts.add 'out'
