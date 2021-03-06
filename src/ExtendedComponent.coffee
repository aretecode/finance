_ = require 'underscore'
noflo = require 'noflo'

validEvents = [
  'attach'
  'connect'
  'beginGroup'
  'data'
  'endGroup'
  'disconnect'
  'detach']

invalidPorts = [
  'ports'
  'sendThenDisconnect'
  'sendThenDiscon'
  'addOn'
  'addOnData'
  'sendThenDisc',
  'error']

# could rename ComponentAdapter|ComponentDecorator
# @TODO: string in/out constructor for defaults
# akin to c.outPorts.add 'out'
# @TODO: default to `out` if it exists?
class ExtendedComponent extends noflo.Component
  sendThenDisc: (name, data) ->
    @sendThenDiscon name, data
  sendThenDisconnect: (name, data) ->
    @sendThenDiscon name, data
  sendThenDiscon: (name, data) ->
    # if we only have 1 arg
    unless data?
      data = name

      # filter out all built in ports
      ports = Object.keys @outPorts
      ports = ports.filter (port) ->
        return true unless invalidPorts.indexOf(port) > -1

      name = ports[0]

    @outPorts[name].send data
    @outPorts[name].disconnect()

    @ # chainable

  sendIfConnected: (name, data) ->
    return unless @outPorts[name]?

    if @outPorts[name].isConnected()
      @outPorts[name].send data

  sendIfConnectedThenDisconnect: (name, data) ->
    if @outPorts[name].isConnected()
      @sendThenDiscon name, data
  sendIfConnectedThenDisc: (name, data) ->
    if @outPorts[name].isConnected()
      @sendThenDiscon name, data
  sendIfConThenDisc: (name, data) ->
    if @outPorts[name].isConnected()
      @sendThenDiscon name, data

  addInOn: (name, opts, process) ->
    @inPorts.addOn name, opts, process
    @

  addInOnData: (name, opts, process) ->
    @inPorts.addOnData name, opts, process
    @

  setInPorts: (inPorts) ->
    @inPorts = new noflo.InPorts(inPorts)
  setOutPorts: (outPorts) ->
    @outPorts = new noflo.OutPorts(outPorts)

  constructor: (options) ->
    super options

    inPortProperties =
      addOn: (name, opts, process) ->
        # meaning, only 2 params were sent in
        # insteadof an empty options
        if typeof opts is 'function'
          process = opts
          opts = {}

        # we know its not a func
        else
          for opt in Object.keys opts
            # and _.isFunction opts[opt]
            # console.log opt

            continue unless validEvents.indexOf(opt) > -1
            addedHere = true
            # since it contains it, `opt` is the event we want to trigger on
            @add name, opts, (event, data) ->
              return unless event is opt
              opts[opt](data, event)

        unless addedHere?
          @add name, opts, (event, data) ->
            unless event is opts.on or
            (Array.isArray(opts.on) and event.indexOf(opts.on) > -1)
              return

            process data, event
        @

      addOnData: (name, opts, process) ->
        unless process? # _.isFunction opts
          process = opts
          opts = {}
        opts.data = process
        @addOn name, opts, process

    outPortProperties =
      sendThenDisconnect: (name, data) ->
        @sendThenDiscon name, data
      sendThenDiscon: (name, data) ->
        @[name].send data
        @[name].disconnect()
      sendThenDisc: (name, data) ->
        @sendThenDiscon name, data
        @

    _.extend @outPorts, outPortProperties
    _.extend @inPorts, inPortProperties

module.exports.ExtendedComponent = ExtendedComponent
