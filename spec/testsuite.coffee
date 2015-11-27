http = require 'http'
moment = require 'moment'
chai = require 'chai'
expect = chai.expect

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

expectValidDate = (data) ->
  expect(moment(data).isValid()).to.equal true

expectFinanceObject = (data) ->
  expect(data).to.be.an 'object'
  if data.currency?
    expect(data.currency).to.be.a 'string'
    expect(parseInt(data.amount)).to.be.at.least 0
  else if data.money?
    expect(data.money.currency).to.be.a 'string'
    expect(parseInt(data.money.amount)).to.be.at.least 0
  expectValidDate data.created_at
  expect(data.id).to.be.a 'string'
  # expectAllProperties data, ['description', 'tags', 'created_at']
  # expect(data).to.have.property 'description'
  # expect(data.tag).to.be.a 'string' # or an array, or object...

# @TODO: any, or all (param)
expectAllProperties = (data, properties) ->
  (chai.expect(data).to.have.property property) for property in properties

optionsFrom = (method, path) ->
  options =
    hostname: 'localhost'
    port: 4011
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
    port: 4011
    path: path
    method: method
    headers:
      'Authorization': 'Bearer 123456789'
      'Content-Type': 'application/json'
      'Content-Length': Buffer.byteLength string||body
  return options

jsonReq = (statusCode, options, string, done, cb) ->
  try
    req = http.request options, (res) ->
      if res.statusCode isnt statusCode
        return done new Error "Invalid status code: #{res.statusCode}"
      getResultJSON res, (json) ->
        data = JSON.parse json
        cb data.message, data.body, done
    req.end string
  catch e
    done e

req = (statusCode, options, done, cb) ->
  try
    request = http.request options, (res) ->
      if res.statusCode isnt statusCode
        return done new Error "Invalid status code: #{res.statusCode}"
      getResultJSON res, (json) ->
        data = JSON.parse json
        cb data.message, data.body, done
    request.end()
  catch e
    done e

module.exports.req = req
module.exports.jsonReq = jsonReq
module.exports.optionsFrom = optionsFrom
module.exports.jsonOptions = jsonOptions
module.exports.expectAllProperties = expectAllProperties
module.exports.getResultJSON = getResultJSON
module.exports.expectValidDate = expectValidDate
module.exports.expectFinanceObject = expectFinanceObject
