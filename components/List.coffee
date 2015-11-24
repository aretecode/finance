noflo = require 'noflo'
{CRUD} = require './CRUD.coffee'

class List extends CRUD
  description: 'List finance operations.'
  icon: 'list'
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
      error:
        datatype: 'object'
      res:
        datatype: 'object'
        description: 'Response object'

    @inPorts.req.on 'data', (data) =>
      @outPorts.res.send data.res
      @outPorts.out.send
        params: data.params
        query: data.query
      @outPorts.res.disconnect()
      @outPorts.out.disconnect()

exports.getComponent = -> new List
