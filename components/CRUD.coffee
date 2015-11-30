noflo = require 'noflo'
{ExtendedComponent} = require './../src/Finance.coffee'

class CRUD extends ExtendedComponent
  sendParams: false
  sendQuery: false
  sendBody: true
  constructor: ->
    @inPorts = new noflo.InPorts
      req:
        datatype: 'object'
        required: true

    @outPorts = new noflo.OutPorts
      out:
        datatype: 'all'
        required: true
      error:
        datatype: 'object'
      res:
        datatype: 'object'
        description: 'Response object'

    # it could also send them depending what is in them
    @inPorts.req.on 'data', (req) =>
      @outPorts.res.send req.res

      if @sendBody and @sendQuery isnt true
        @outPorts.out.send req.body

      else if @sendQuery and @sendBody isnt true
        @outPorts.out.send req.query

      else if @sendParams and @sendBody isnt true
        @outPorts.out.send req.params

      else if @sendBody and @sendQuery and @sendParams
        @outPorts.out.send
          body: req.body
          params: req.params
          query: req.query

      else if @sendBody and @sendQuery
        @outPorts.out.send
          body: req.body
          query: req.query

      else if @sendBody and @sendParams
        @outPorts.out.send
          params: req.params
          query: req.query

      @outPorts.res.disconnect()
      @outPorts.out.disconnect()

exports.getComponent = -> new CRUD
exports.CRUD = CRUD
