noflo = require 'noflo'
chai = require 'chai'
http = require 'http'
uuid = require 'uuid'
express = require 'express'

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

describe 'Reports', ->
  net = null

  before (done) ->
    noflo.loadFile 'test_graphs/App.fbp', {}, (network) ->
      net = network
      done()
  after (done) ->
    net.stop()
    done()
  
  it 'should give monthly report for expenses', (done) ->
    options =
      hostname: 'localhost'
      port: 4011
      path: '/api/reports/expenses/monthly' 
      method: 'GET'
      headers:
        'Pass': 'noflo'
        'Authorization': 'Bearer 123456789'

    try
      req = http.request options, (res) ->
        if res.statusCode isnt 302
          return done new Error "Invalid status code: #{res.statusCode}"
        getResultJSON res, (json) ->
          chai.expect(json).to.be.a 'string'
          done()
      req.end()
    catch e
      done e