_ = require 'underscore'
noflo = require 'noflo'

validEvents = [
  'attach',
  'connect',
  'beginGroup',
  'data',
  'endGroup',
  'disconnect',
  'detach']

# @TODO: string in/out constructor for defaults
# akin to c.outPorts.add 'out'
class ExtendedComponent extends noflo.Component
  sendThenDisconnect: (name, data) ->
    @sendThenDiscon name, data
  sendThenDiscon: (name, data) ->
    # if we only have 1 arg
    unless data?
      data = name
      name = Object.keys(@outPorts)[0]

    @outPorts[name].send data
    @outPorts[name].disconnect()

    @ # chainable


  constructor: (options) ->
    super options

    classProperties =
      addOn: (name, opts, process) ->
        # meaning, only 2 params were sent in
        # insteadof an empty options
        if _.isFunction opts
          process = opts
          opts = {}

        # we know its not a func
        else
          for opt in Object.keys opts
            # and _.isFunction opts[opt]
            continue unless _.contains validEvents, opt
            # since it contains it, `opt` is the event we want to trigger on
            @add(name, opts, (event, data) ->
              return unless event is opt
              process data, event
            )

        @add(name, opts, (event, data) ->
          unless event is opts.on or (_.isArray opts.on and _.contains opts.on)
            return
          process data, event
        )

        @ # chainable

      addOnData: (name, opts, process) ->
        opts.data = process
        @addOn name, opts

    outPortProperties =
      sendThenDisconnect: (name, data) ->
        @sendThenDiscon name, data
      sendThenDiscon: (name, data) ->
        @[name].send data
        @[name].disconnect()

        @ # chainable

    _.extend @outPorts, outPortProperties
    _.extend @outPorts, classProperties
    _.extend @inPorts, classProperties

module.exports.ExtendedComponent = ExtendedComponent
