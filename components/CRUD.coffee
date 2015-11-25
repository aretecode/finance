noflo = require 'noflo'
{ExtendedComponent} = require './../src/Finance.coffee'

class CRUD extends ExtendedComponent
  constructor: ->
    @pg = require('./../src/Persistence/connection.coffee').getPg()

    @inPorts = new noflo.InPorts
      name:
        datatype: 'string'
        description: 'The name of the operation -
        could just use this instead of individual components'
      req:
        datatype: 'object'
        required: true

    @outPorts = new noflo.OutPorts
      out:
        datatype: 'all'
      error:
        datatype: 'object'
      res:
        datatype: 'object'
        description: 'Response object'

    @inPorts.req.on 'data', (data) =>
      @outPorts.res.send data.res
      @outPorts.out.send data.params
      @outPorts.res.disconnect()
      @outPorts.out.disconnect()

exports.getComponent = -> new CRUD
exports.CRUD = CRUD