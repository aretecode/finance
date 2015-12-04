noflo = require 'noflo'
finance = require './../src/Finance.coffee'

class Connection extends finance.ExtendedComponent
  description: 'Pass a database connection.'
  icon: 'database'

  constructor: ->
    @inPorts = new noflo.InPorts
      type:
        datatype: 'string'
        description: '(income or expense)'
        required: true
      in:
        datatype: 'object'
        description: 'Request (validated)'
        required: true

    @outPorts = new noflo.OutPorts
      out:
        datatype: 'object'
      error:
        datatype: 'object'

    noflo.helpers.WirePattern @,
      in: ['in', 'type']
      out: []
      params: ['req', 'type']
      async: true
      forwardGroups: true
    , (params) ->
      c.sendThenDisc
        db:
          pg: finance.getConnection()
          type: params.type
        req: params.req

exports.getComponent = -> new Removed
