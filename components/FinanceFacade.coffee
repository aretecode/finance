uuid = require 'uuid'
finance = require './../src/Finance.coffee'

exports.getComponent = ->
  c = new finance.ExtendedComponent

  # @TODO
  # [ ] on *any* disconnect, outPorts.out.disconnect?
  # [x] change to allow for failures
  # [ ] change to detect failure again with statusCode
  # [ ] pass in a failure cb
  #     > could pass code back
  # [ ] pass in port
  # [ ] add auth inPort to req
  # [ ] add inPort f
  # [ ] create these ports dynamically
  c.addInOnData 'create', (data) ->
    c.outPorts.out.send
      body: data.body
      options:
        method: 'POST'
        path: '/api/expenses'
      statusCode: 201
      cb: data.cb

  c.addInOnData 'retrieve', (data) ->
    c.sendThenDisconnect
      options:
        method: 'GET'
        path: '/api/expenses/' + data.id
      statusCode: 200
      cb: data.cb

  c.addInOnData 'update', (data) ->
    c.outPorts.out.send
      body: data.body
      options:
        method: 'PUT'
        path: '/api/expenses'
      statusCode: 200
      cb: data.cb

  c.addInOnData 'delete', (data) ->
    c.outPorts.out.send
      options:
        method: 'DELETE'
        path: '/api/expenses/' + data.id
      statusCode: 200
      cb: data.cb

  c.addInOnData 'list', (data) ->
    filter = null

    # @TODO: (later) could do both, but not now
    if data.tag?
      filter = '/tag=' + data.tag
    else if data.date?
      filter = '/date=' + data.date

    c.outPorts.out.send
      options:
        method: 'GET'
        path: '/api/expenses' + filter
      statusCode: 200
      cb: data.cb

  c.addInOnData 'monthly', (data) ->
    filter = null

    # @TODO: (later) could do .date & extract mm-yyyy, but now now
    # if data.year? and !data.month? or versa, err
    # could also change reports to filter more than just a month
    if data.year? and data.month?
      filter = '/year=' + data.year + '&month=' + data.month

    c.outPorts.out.send
      options:
        method: 'GET'
        path: '/api/expenses' + filter
      statusCode: 302
      cb: data.cb

  c.addInOnData 'trend', (data) ->
    filter = null

    # @TODO: could transform it from an object into a str
    if data.start? and data.end?
      filter = '/start=' + data.start + '&end=' + data.end

    c.sendThenDisconnect 'out',
      options:
        method: 'GET'
        path: '/api/expenses' + filter
      statusCode: 200
      cb: data.cb

  c.outPorts.add 'out'
  c
