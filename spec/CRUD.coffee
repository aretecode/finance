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

expectAllProperties = (data, properties) ->
  (chai.expect(data).to.have.property property) for property in properties 

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

describe 'CRUD', ->
  expect = chai.expect 
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

    options = optionsFrom 'POST', path
 
    try
      req = http.request options, (res) ->
        if res.statusCode isnt 201
          return done new Error "Invalid status code: #{res.statusCode}"
        getResultJSON res, (json) ->
          chai.expect(json).to.be.a 'string'
          data = JSON.parse json
          # expect it to equal the same parameters passed into url
          expect(data.message).to.equal 'created'
          expect(data.body.successful).to.equal true
          expect(data.body.data.currency).to.equal 'cad'
          expect(data.body.data.amount).to.equal '100'
          expect(data.body.data.description).to.equal 'example-description'
          expect(data.body.data.id).to.equal id
          # expect(data.tags).to.equal 'cad'
          done()
      req.end()
    catch e
      done e

  it 'should retrieve/find using GET', (done) ->
    options = optionsFrom 'GET', "/api/expenses/retrieve/" + id

    try
      req = http.request options, (res) ->
        if res.statusCode isnt 200
          return done new Error "Invalid status code: #{res.statusCode}"
        getResultJSON res, (json) ->
          chai.expect(json).to.be.a 'string'
          data = JSON.parse json
          found = data.body.data
          expect(data.message).to.equal 'found'
          expect(data.body.successful).to.equal true
          expect(found.money.currency).to.equal 'cad'
          expect(found.money.amount).to.equal 100
          expect(found.description).to.equal 'example-description'
          expect(found.id).to.equal id
          #expect(found.tags.toString()).to.equal
          #expect(found.created_at).to.be.a.valid.date
          done()
      req.end()
    catch e
      done e

  it 'should update using PUT', (done) ->
    #  + id + "/NZD/70/new-tag,old-tag"
    # /new-created-at/new-description
    options = optionsFrom 'PUT', "/api/expenses/update/"+ id + "/NZD/70/new-tag,old-tag"

    try
      req = http.request options, (res) ->
        if res.statusCode isnt 200
          return done new Error "Invalid status code: #{res.statusCode}"
        
        getResultJSON res, (json) ->
          expect(json).to.be.a 'string'
          data = JSON.parse json
          updated = data.body.data
          expect(data.message).to.equal 'updated'
          expect(data.body.successful).to.equal true
          expect(updated.currency).to.equal 'NZD'
          expect(updated.amount).to.equal '70'
          expect(updated.id).to.equal id
          # expect(updated.tags).to.equal 'new-tag,old-tag'
          done()

      req.end()
    catch e
      done e
  
  it 'should list using GET', (done) ->
    options = optionsFrom 'GET', "/api/expenses/list"

    try
      req = http.request options, (res) ->
        if res.statusCode isnt 200
          return done new Error "Invalid status code: #{res.statusCode}"
        
        getResultJSON res, (json) ->
          data = JSON.parse json
          list = data.body.data

          expect(json).to.be.a 'string'
          expect(data.message).to.equal 'found'
          expect(data.body.successful).to.equal true
          expect(list).to.be.an 'array'
          expect(list).to.have.length.of.at.least 1
      
          # expectAllProperties list[0], ['properties from Finance']          
          # expect(updated.tags).to.equal 'new-tag,old-tag'
          done()

      req.end()
    catch e
      done e

  it 'should give monthly report for expenses', (done) ->
    options = optionsFrom 'GET', '/api/reports/expenses/monthly' 

    try
      req = http.request options, (res) ->
        if res.statusCode isnt 302
          return done new Error "Invalid status code: #{res.statusCode}"
        getResultJSON res, (json) ->
          data = JSON.parse json
          report = data.body.data
          expect(json).to.be.a 'string'
          expect(data.message).to.equal 'found'
          expect(data.body.successful).to.equal true
          expect(report).to.be.an 'object'
          done()
      req.end()
    catch e
      done e


  it 'should delete using DELETE', (done) ->
    options = optionsFrom 'DELETE', "/api/expenses/delete/" + id

    try
      req = http.request options, (res) ->
        if res.statusCode isnt 200
          return done new Error "Invalid status code: #{res.statusCode}"
        getResultJSON res, (json) ->
          expect(json).to.be.a 'string'          
          data = JSON.parse json
          expect(data.message).to.equal 'deleted'
          expect(data.body.successful).to.equal true
          done()
      req.end()
    catch e
      done e

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
      # console.log e
      done()
  
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