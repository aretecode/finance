ExtendedComponent = require './ExtendedComponent.coffee'

# could put async and forwardgroups and other things
# in here, but this should be as simple as possible
class DefaultInOutComponent extends ExtendedComponent
  constructor: ->
    @inPorts = new noflo.InPorts
      in:
        datatype: (@inType||'any')
        description: (@inDesc||'default in port')

    @outPorts = new noflo.OutPorts
      out:
        datatype: (@inType||'any')
        description: (@outDesc||'default out port')
      error:
        datatype: 'object'

module.exports.DefaultInOutComponent = DefaultInOutComponent
