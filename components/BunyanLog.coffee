{ExtendedComponent} = require './../src/Finance.coffee'
bunyan = require 'bunyan'

exports.getComponent = ->
  c = new ExtendedComponent
    inPorts:
      in:
        datatype: 'object'
        description: 'Data to log'
      level:
        datatype: 'string'
        description: 'enum: debug, info, fatal, error, warn, trace'
    outPorts:
      error:
        datatype: 'object'

  c.log = bunyan.createLogger
    name: 'finance'
    streams: [
      level: 'debug'
      path: '/var/tmp/financeinfo.json'
    ]

  c.addInOnData 'in', (level) ->
    c.level = level

  c.addInOnData 'in', (data) ->
    if c.level?
      c.log[c.level](data)
    else
      c.log.debug(data)

    c.sendIfConnected data

  c
