finance = require './../src/Finance.coffee'

describe 'NoFlo extension', ->
  it '`ExtendedComponent` should be able to use `addOn` an object', ->
    c = new finance.ExtendedComponent
    c.inPorts.addOn 'awesomein', (data) ->
      console.log data
