_ = require 'underscore'
noflo = require 'noflo'

class ExtendedComponent extends noflo.Component
  constructor: (options) ->
    super options

    classProperties = 
      addOn: (name, options, process) ->
        # meaning, only 2 params were sent in
        # insteadof an empty options
        if typeof options is 'function'
          process = options
          options = {}

        @add(name, options, (event, data) ->
          # @TODO: or IS IN 
          return unless event is options.on
          process data
        )

    _.extend(@outPorts, classProperties) 
    _.extend(@inPorts, classProperties) 
      
module.exports.ExtendedComponent = ExtendedComponent
