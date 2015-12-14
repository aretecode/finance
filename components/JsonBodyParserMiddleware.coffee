bodyParser = require 'body-parser'
{ExtendedComponent} = require './../src/Finance.coffee'

exports.getComponent = ->
  c = new ExtendedComponent
  c.description = 'Adds JSON body parsing'
  c.icon = 'gears'

  c.addInOnData 'app',
    datatype: 'object'
    description: 'Express Application'
  , (app) ->
    try
      app.use bodyParser.json(type: 'application/json')
      c.outPorts.app.send app
      c.outPorts.app.disconnect()
    catch e
      return c.error new Error "Could not setup server: #{e.message}"

  c.outPorts.add 'app',
    datatype: 'object'
    required: true
    caching: true
    description: 'Express Application that Parses JSON'
  c.outPorts.add 'error', datatype: 'object'

  c
