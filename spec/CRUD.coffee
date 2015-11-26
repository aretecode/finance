noflo = require 'noflo'
chai = require 'chai'
http = require 'http'
uuid = require 'uuid'
express = require 'express'
moment = require 'moment'
expect = chai.expect
finance = require './../src/Finance.coffee'

try
  require './../.env.coffee'
catch e
  #

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
  net = null

  before (done) ->
    noflo.loadFile 'test_graphs/App.fbp', {}, (network) ->
      net = network
      done()
  after (done) ->
    net.stop()
    done()

  id = uuid.v4()

  it 'should be able to use `add` on an object', ->
    c = new finance.ExtendedComponent
    c.inPorts.addOn 'awesomein', (data) ->
      console.log data

  it 'should create using POST', (done) ->

    path = '/api/expenses/cad/100/canadian,eh/' +
    Date.now() +
    '/example-description/'+id

    options = optionsFrom 'POST', path

    try
      req = http.request options, (res) ->
        if res.statusCode isnt 201
          return done new Error "Invalid status code: #{res.statusCode}"
        getResultJSON res, (json) ->
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
    options = optionsFrom 'GET', '/api/expenses/retrieve/' + id

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
          expectValidDate(found.created_at)
          done()
      req.end()
    catch e
      done e

  it 'should update using PUT', (done) ->
    #  + id + '/NZD/70/new-tag,old-tag'
    # /new-created-at/new-description
    options = optionsFrom 'PUT', '/api/expenses/update/'+ id + '/NZD/70/new-tag,old-tag'

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
    options = optionsFrom 'GET', '/api/expenses/list'

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
    options = optionsFrom 'DELETE', '/api/expenses/delete/' + id

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

  it 'should be able to list expenses with tag', (done) ->
    options = optionsFrom 'GET', '/api/expenses/list/?tag=component-store'
    try
      req = http.request options, (res) ->
        getResultJSON res, (json) ->
          data = JSON.parse json
          list = data.body.data
          expect(list).to.be.an 'array'
          expectFinanceObject list[0]
          expect(list).to.have.length.of.at.least 1
          expect(res.statusCode).to.equal 200 #302
          done()
      req.end()
    catch e
      done e

  it 'should be able to list expenses with date (timestamp)', (done) ->
    options = optionsFrom 'GET', '/api/expenses/list/?date=' + new Date().getTime()
    try
      req = http.request options, (res) ->
        getResultJSON res, (json) ->
          data = JSON.parse json
          list = data.body.data
          expect(list).to.be.an 'array'
          expectFinanceObject list[0]
          expect(list).to.have.length.of.at.least 1
          expect(res.statusCode).to.equal 200 #302
          done()
      req.end()
    catch e
      done e

  it 'should be able to list expenses with date (y-m-d)', (done) ->
    date = new Date()
    month = date.getMonth()+1
    year = date.getFullYear()
    day = date.getDay()
    dateString = year + '-' + month + '-' + day
    options = optionsFrom 'GET', '/api/expenses/list/?date=' + dateString

    try
      req = http.request options, (res) ->
        getResultJSON res, (json) ->
          data = JSON.parse json
          list = data.body.data
          expect(list).to.be.an 'array'
          expectFinanceObject list[0]
          expect(list).to.have.length.of.at.least 1
          expect(res.statusCode).to.equal 200 #302
          done()
      req.end()
    catch e
      done e

  it 'should not allow unauthorized access', (done) ->
    options =
      hostname: 'localhost'
      port: 4011
      path: '/api/expenses/retrieve/' + id
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
      done()

  it 'should not be able to find a deleted finance operation', (done) ->
    options =
      hostname: 'localhost'
      port: 4011

      path: '/api/expenses/retrieve/' + id
      method: 'GET'
      headers:
        'Pass': 'noflo'
        'Authorization': 'Bearer 123456789'

    try
      req = http.request options, (res) ->
        if res.statusCode isnt 404
          return done new Error "Invalid status code: #{res.statusCode}"
        getResultJSON res, (json) ->

          done()
      req.end()
    catch e
      done e
