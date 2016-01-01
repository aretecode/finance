{ExtendedComponent} = require './../src/Finance.coffee'
cors = require 'cors'

exports.getComponent = ->
  c = new ExtendedComponent
    outPorts:
      app:
        datatype: 'object'
        required: true
        caching: true
        description: 'Configured Express Application'
      error:
        datatype: 'object'

  c.description = 'Enables Cross Origin Resource Sharing'
  c.icon = 'globe'

  c.addInOnData 'app',
    datatype: 'object'
    description: 'Express Application'
  , (app) ->
    try
      app.use cors()
      app.options '*', cors()

      c.sendThenDisc app
    catch e
      return c.error new Error "Could not setup (CORS) server: #{e.message}"

  c
