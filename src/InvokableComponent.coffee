ExtendedComponent = require './ExtendedComponent.coffee'

# aka: DefaultInOutComponent
# could put async and forwardgroups and other things
# in here, but this should be as simple as possible
class InvokableComponent extends ExtendedComponent
  constructor: ->
    @inPorts = new noflo.InPorts
      in:
        datatype: inType or 'any'
        description: inDesc or 'default in port'

    @outPorts = new noflo.OutPorts
      out:
        datatype: @inType or 'any'
        description: @outDesc or 'default out port'
      error:
        datatype: 'object'

    @inPorts.in.on 'data', (data) =>
      @__invoke data


module.exports.InvokableComponent = InvokableComponent
