noflo = require 'noflo'
http = require 'http'
finance = require './../src/Finance.coffee'

getResultJSON = (res, callback) ->
  data = ''
  res.on 'data', (chunk) ->
    data += chunk
  res.on 'end', ->
    try
      json = JSON.parse data
      callback json
    catch e
      throw new Error e.message + '. Body:' + data

optionsFrom = (method, path) ->
  options =
    hostname: 'localhost'
    port: 5023
    path: path
    method: method
    headers:
      'Authorization': 'Bearer 123456789'
  return options

jsonOptions = (method, path, body) ->
  if typeof body isnt 'string'
    string = JSON.stringify body

  options =
    hostname: 'localhost'
    port: 5023
    path: path
    method: method
    headers:
      'Authorization': 'Bearer 123456789'
      'Content-Type': 'application/json'
      'Content-Length': Buffer.byteLength string||body
  return options

jsonReq = (statusCode, options, string, cb) ->
  try
    req = http.request options, (res) ->
      if res.statusCode isnt statusCode
        return cb new Error "Invalid status code: #{res.statusCode}"
      getResultJSON res, (json) ->
        data = JSON.parse json
        cb data.message, data.body
    req.end string
  catch e
    console.log e

requ = (statusCode, options, cb) ->
  try
    request = http.request options, (res) ->
      if res.statusCode isnt statusCode
        return cb new Error "Invalid status code: #{res.statusCode}"
      getResultJSON res, (json) ->
        data = JSON.parse json
        cb data.message, data.body
    request.end()
  catch e
    console.log e

class FlowHubReq extends finance.ExtendedComponent

  constructor: ->
    @inPorts = new noflo.InPorts
      in:
        datatype: 'all'

    @outPorts = new noflo.OutPorts
      out:
        datatype: 'all'
      error:
        datatype: 'object'

    @inPorts.in.on 'data', (data) =>
      if data.body?
        body = JSON.stringify data.body
        options = jsonOptions data.options.method, data.options.path, body
        jsonReq data.statusCode, options, body, data.cb
      else
        options = optionsFrom data.options.method, data.options.path
        requ data.statusCode, options, data.cb

      # @sendThenDiscon data

exports.getComponent = -> new FlowHubReq
exports.FlowHubReq = FlowHubReq
