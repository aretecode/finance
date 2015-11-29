finance = require './../src/Finance.coffee'

# @TODO
# [ ] on *any* disconnect, outPorts.out.disconnect?
# [x] change to allow for failures
# [ ] change to detect failure again with statusCode
# [ ] pass in a failure cb
#     > could pass code back
# [ ] pass in port (server) ~
#       c.addInOnData 'name', (data) ->
#       c.addInOnData 'port', (data) ->
# [ ] add auth inPort to req
exports.getComponent = ->
  c = new finance.ExtendedComponent
  c.description = 'an easy way into the app'
  c.icon = 'dollar'

  c.addInOnData 'create', (data) ->
    c.sendThenDisconnect 'create',
      body: data.body
      options:
        method: 'POST'
        path: '/api/' + data.type||'expenses'
      statusCode: 201
      cb: data.cb

  # different as an example
  c.addInOn 'retrieve',
    data: (data) ->
      c.sendThenDisconnect 'retrieve',
        options:
          method: 'GET'
          path: '/api/' + data.type||'expenses' + '/' + data.id
        statusCode: 200
        cb: data.cb

  c.addInOnData 'update', (data) ->
    c.sendThenDisconnect 'update',
      body: data.body
      options:
        method: 'PUT'
        path: '/api/' + data.type||'expenses'
      statusCode: 200
      cb: data.cb

  c.addInOnData 'delete', (data) ->
    c.sendThenDisconnect 'delete',
      options:
        method: 'DELETE'
        path: '/api/'  + data.type||'expenses' + '/' + data.id
      statusCode: 200
      cb: data.cb

  c.addInOnData 'list', (data) ->
    filter = null

    # @TODO: (later) could do both, but not now
    if data.tag?
      filter = '/tag=' + data.tag
    else if data.date?
      filter = '/date=' + data.date

    c.sendThenDisconnect 'list',
      options:
        method: 'GET'
        path: '/api/' + data.type||'expenses' + filter
      statusCode: 200
      cb: data.cb

  c.addInOnData 'monthly', (data) ->
    filter = null

    # @TODO: (later) could do .date & extract mm-yyyy, but now now
    # if data.year? and !data.month? or versa, err
    # could also change reports to filter more than just a month
    if data.year? and data.month?
      filter = '/year=' + data.year + '&month=' + data.month

    c.sendThenDisconnect 'monthly',
      options:
        method: 'GET'
        path: '/api/' + data.type||'expenses' + filter
      statusCode: 302
      cb: data.cb

  c.addInOnData 'trend', (data) ->
    filter = null

    # @TODO: could transform it from an object into a str
    if data.start? and data.end?
      filter = '/start=' + data.start + '&end=' + data.end

    c.sendThenDisconnect 'trend',
      options:
        method: 'GET'
        path: '/api/' + data.type||'expenses' + filter
      statusCode: 200
      cb: data.cb

  c.outPorts.add 'create'
  c.outPorts.add 'retrieve'
  c.outPorts.add 'update'
  c.outPorts.add 'delete'
  c.outPorts.add 'list'
  c.outPorts.add 'monthly'
  c.outPorts.add 'trend'

  c
