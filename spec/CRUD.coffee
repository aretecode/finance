noflo = require 'noflo'
chai = require 'chai'
http = require 'http'
uuid = require 'uuid'
express = require 'express'

require './../.env.coffee'

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

getResult = (res, callback) ->
  data = ''
  res.on 'data', (chunk) ->
    data += chunk
  res.on 'end', ->
    callback data

describe 'CRUD', ->
  net = null

  before (done) ->
    noflo.loadFile 'test_graphs/App.fbp', {}, (network) ->
      net = network
      done()
  after (done) ->
    net.stop()
    done()
  
  id = uuid.v4()

  it 'should create using POST', (done) ->

    path = "/api/expenses/cad/100/canadian,eh/" +
    Date.now() +
    "/example-description/"+id

    options =
      hostname: 'localhost'
      port: 4011
      path: path 
      method: 'POST'
      headers:
        'Pass': 'noflo'
        'Authorization': 'Bearer 123456789'

    try
      req = http.request options, (res) ->
        if res.statusCode isnt 201
          return done new Error "Invalid status code: #{res.statusCode}"
        getResultJSON res, (json) ->
          chai.expect(json).to.be.a 'string'
          # if not a string,
          # expect it to equal the same parameters passed into url
          # chai.expect(data.body.amount).to.equal 100
          # chai.expect(data.body.currency).to.equal 'cad'
          # chai.expect(data.tags).to.equal 'cad'

          done()
      req.end()
    catch e
      done e

  it 'should finding using GET', (done) ->
    options =
      hostname: 'localhost'
      port: 4011

      path: "/api/expenses/retrieve/" + id
      method: 'GET'
      headers:
        'Pass': 'noflo'
        'Authorization': 'Bearer 123456789'

    try
      req = http.request options, (res) ->
        if res.statusCode isnt 200
          return done new Error "Invalid status code: #{res.statusCode}"
        getResultJSON res, (json) ->
          chai.expect(json).to.be.a 'string'
          # chai.expect(json).to.equal 'Hello'
          # if not a string,
          # expect it to equal the same AS THE ONE SAVED

          done()
      req.end()
    catch e
      done e


  it 'should update using PUT', (done) ->
    #  + id + "/NZD/70/new-tag,old-tag"
    # /new-created-at/new-description
    options =
      hostname: 'localhost'
      port: 4011
      path: "/api/expenses/update/"+ id + "/NZD/70/new-tag,old-tag"
      method: 'PUT'
      headers:
        'Pass': 'noflo'
        'Authorization': 'Bearer 123456789'

    try
      req = http.request options, (res) ->
        if res.statusCode isnt 200
          return done new Error "Invalid status code: #{res.statusCode}"
        
        getResultJSON res, (json) ->
          # @TODO: retrieve same id and make sure it does not exist
          # chai.expect(json.body).to.be.a 'array'
          # chai.expect(json.body).to.have.length.of.at.least 2
          # console.log json
          # chai.expect(json).to.be.a 'string'
          done()

      req.end()
    catch e
      done e

  it 'should list using GET', (done) ->
    options =
      hostname: 'localhost'
      port: 4011
      path: "/api/expenses/list"
      method: 'GET'
      headers:
        'Pass': 'noflo'        
        'Authorization': 'Bearer 123456789'

    try
      req = http.request options, (res) ->
        if res.statusCode isnt 200
          return done new Error "Invalid status code: #{res.statusCode}"
        
        getResultJSON res, (json) ->
          # chai.expect(json.body).to.be.a 'array'
          # chai.expect(json.body).to.have.length.of.at.least 2
          # console.log json
          # chai.expect(json).to.be.a 'string'
          done()

      req.end()
    catch e
      done e

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
          done()
      req.end()
    catch e
      done e


  it 'should delete using DELETE', (done) ->
    options =
      hostname: 'localhost'
      port: 4011
      path: "/api/expenses/delete/" + id
      method: 'DELETE'
      headers:
        'Pass': 'noflo'        
        'Authorization': 'Bearer 123456789'

    try
      req = http.request options, (res) ->
        if res.statusCode isnt 200
          return done new Error "Invalid status code: #{res.statusCode}"
        getResultJSON res, (json) ->
          chai.expect(json).to.be.a 'string'
          done()
      req.end()
    catch e
      done e

  ###
  it 'should not allow unauthorized access', (done) ->
    options =
      hostname: 'localhost'
      port: 4011
      path: "/api/expenses/retrieve/" + id
      method: 'GET'
      headers:
        'Pass': 'noflo'
        'Authorization': 'Bearer WRONGPASS'

    try
      req = http.request options, (res) ->
        if res.statusCode isnt 401
          return done new Error "Invalid status code: #{res.statusCode}"
        
        done()
      req.end()
    catch e
      done e
  ###
  
  ###
  it 'should not be able to find a deleted finance operation', (done) ->
    options =
      hostname: 'localhost'
      port: 4011

      path: "/api/expenses/retrieve/" + id
      method: 'GET'
      headers:
        'Pass': 'noflo'
        'Authorization': 'Bearer 123456789'

    try
      req = http.request options, (res) ->
        if res.statusCode isnt 200
          return done new Error "Invalid status code: #{res.statusCode}"
        getResultJSON res, (json) ->
          chai.expect(json).to.be.a 'string'

          done()
      req.end()
    catch e
      done e
  ###