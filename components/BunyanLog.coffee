{ExtendedComponent} = require './../src/Finance.coffee'
bunyan = require 'bunyan'

exports.getComponent = ->
  c = new ExtendedComponent
    inPorts:
      in:
        datatype: 'object'
        description: 'Data to log'
    outPorts:
      error:
        datatype: 'object'


  c.log = bunyan.createLogger
    name: 'finance'
    streams: [
      level: 'debug'
      path: '/var/tmp/financeinfo.json'
    ]

  c.addInOnData 'in', (data) ->
    c.log.debug(data)
    c.sendIfConnected data

  c
