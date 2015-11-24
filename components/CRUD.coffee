noflo = require 'noflo'

class CRUD extends noflo.Component
  constructor: ->
    @pg = require('./../src/Persistence/connection.coffee').getPg()

    @inPorts = new noflo.InPorts
      name:
        datatype: 'string'
        description: 'The name of the operation -
        could just use this instead of individual components'
      req:
        datatype: 'object'

    @outPorts = new noflo.OutPorts
      out:
        datatype: 'all'
      tags:
        datatype: 'all'
      error:
        datatype: 'object'
      res:
        datatype: 'object'
        description: 'Response object'

    error: (msg) ->
      if @outPorts.error.isAttached()
        @outPorts.error.send new Error msg
        @outPorts.error.disconnect()
        return
      throw new Error msg

    @inPorts.req.on 'data', (data) =>
      @outPorts.res.send data.res
      @outPorts.out.send data.params
      @outPorts.res.disconnect()
      @outPorts.out.disconnect()

exports.getComponent = -> new CRUD
exports.CRUD = CRUD