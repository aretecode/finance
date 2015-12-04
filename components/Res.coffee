noflo = require 'noflo'

class Res extends noflo.Component
  description: 'Send a Response.'
  icon: 'send'

  constructor: ->
    @inPorts = new noflo.InPorts
      created:
        datatype: 'object'
      updated:
        datatype: 'object'
      deleted:
        datatype: 'object'
      retrieved:
        datatype: 'object'
      monthly:
        datatype: 'object'
      trend:
        datatype: 'object'
      error:
        datatype: 'object'

    @outPorts = new noflo.OutPorts
      error:
        datatype: 'object'

    sendRes = (data, passCode, passMsg, failCode, failMsg) =>
      if data.res?
        res = data.res
      else if data.req?
        res = data.req.res
      else
        throw new Error(data)
        return

      if data.success is true
        res.status(passCode).json
          message: passMsg
          body: data.data
      else
        res.status(failCode).json
          message: failMsg
          body: data.data

    @inPorts.created.on 'data', (data) =>
      sendRes data, 201, 'created', 500, 'couldNotCreate'
    @inPorts.retrieved.on 'data', (data) =>
      sendRes data, 200, 'found', 404, 'not found'
    @inPorts.deleted.on 'data', (data) =>
      sendRes data, 200, 'deleted', 500, 'not able to delete'
    @inPorts.updated.on 'data', (data) =>
      sendRes data, 200, 'updated', 500, 'not updated'
    @inPorts.monthly.on 'data', (data) =>
      sendRes data, 302, 'found', 404, 'not found (month & yr)'
    @inPorts.trend.on 'data', (data) =>
      sendRes data, 200, 'found', 404, 'not found'
    @inPorts.error.on 'data', (data) =>
      console.log data
      sendRes data, 500, 'server error',  500, 'server error'

exports.getComponent = -> new Res
