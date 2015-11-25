noflo = require 'noflo'
chai = require 'chai'
http = require 'http'
uuid = require 'uuid'
express = require 'express'
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
      throw new Error e.message + ". Body:" + data

optionsFrom = (method, path) ->
  options =
    hostname: 'localhost'
    port: 4011
    path: path
    method: method
    headers:
      'Pass': 'noflo'
      'Authorization': 'Bearer 123456789'
  return options

expectAllProperties = (data, properties) ->
  (expect(data).to.have.property property) for property in properties

describe 'Reports', ->
  net = null

  before (done) ->
    noflo.loadFile 'test_graphs/App.fbp', {}, (network) ->
      net = network
      done()
  after (done) ->
    net.stop()
    done()

  it 'should report balance trends', (done) ->
    options = optionsFrom 'GET', "/api/reports/trend"

    try
      req = http.request options, (res) ->
        if res.statusCode isnt 200
          return done new Error "Invalid status code: #{res.statusCode}"
        getResultJSON res, (json) ->
          jso = JSON.parse json
          expect(jso.body.successful).to.equal true
          expect(jso.body.data).to.be.an 'array'
          expectAllProperties(
            jso.body.data[0],
            ['income', 'expense', 'balance', 'month', 'year'])

          done()
      req.end()
    catch e
      done e
