finance = require './../src/Finance.coffee'

# @TODO: move this
formattedReq = (data) ->
  req = data.req or data

  error: data.error
  data: data.data
  component: 'FetchList'
  reqData:
    url: req.url
    route: req.route
    xhr: req.xhr
    method: req.method
    params: req.params
    query: req.query
    body: req.body
    uuid: req.uuid

class Res extends finance.ExtendedComponent
  description: 'Send a Response.'
  icon: 'send'

  constructor: ->
    @setInPorts
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

    @setOutPorts
      error:
        datatype: 'object'

    sendRes = (data, passCode, passMsg, failCode, failMsg) =>
      if data.res?
        res = data.res
      else if data.req?
        res = data.req.res
      else
        return throw new Error(data)

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
      sendRes data, 200, 'found', 404, 'trends not found'
    @inPorts.error.on 'data', (data) =>
      @sendThenDisc 'error', formattedReq(data)
      sendRes (data.data or data), 500, 'server error',  500, 'server error'

  shutdown = ->
    @started = false
    finance.getConnection().destroy()
    throw new Error('res shutdown... destroy connection')

exports.getComponent = -> new Res
