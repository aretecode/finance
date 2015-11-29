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
    c.inPorts.addOn 'arrayinwoev', {on: ['data', 'connect']}, (data) ->
      console.log data
