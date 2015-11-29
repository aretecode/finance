noflo = require 'noflo'
chai = require 'chai'
http = require 'http'
uuid = require 'uuid'
express = require 'express'
suite = require './testsuite'
expect = chai.expect
Promise = require 'bluebird'

try require './../.env.coffee' catch e

describe 'App (AllNew)', ->
  net = null
  pg = require('./../src/Persistence/connection.coffee').getPg()
  id = uuid.v4()

  before (done) ->
    createFinanceOp = new Promise (resolve, reject) ->
      pg.schema.hasTable('finance_op').then (exists) ->
        return resolve('exists') if exists
        pg.schema.createTableIfNotExists 'finance_op', (table) ->
          # uuid('id')
          table.string('id', 36).primary()
          table.string('currency').notNullable()
          table.integer('amount').notNullable()
          table.timestamp('created_at') # .defaultTo(pg.fn.now())
          table.string('description').nullable().defaultTo(null)
          table.enu('type', ['income', 'expense']).notNullable()
        .then (created) ->
          resolve(created)

    createTags = new Promise (resolve, reject) ->
      pg.schema.hasTable('tags').then (exists) ->
        return resolve('exists') if exists
        pg.schema.createTableIfNotExists 'tags', (table) ->
          table.string('id', 36)
          table.string('tag').notNullable()
          table.primary(['id', 'tag'])
        .then (created) ->
          resolve(created)

    Promise.settle([createFinanceOp, createTags]).then (settled) ->
      noflo.loadFile 'test_graphs/App.fbp', {}, (network) ->
        net = network
        done()

  after (done) ->
    net.stop()
    pg.raw('TRUNCATE tags, finance_op').then (truncated) ->
      done()

  it 'should create using POST', (done) ->
    body =
      currency: 'cad'
      amount: 100
      tags: ['canadian', 'eh', 'beginning']
      created_at: Date('2004-10-01')
      type: 'expense'
    string = JSON.stringify body
    options = suite.jsonOptions 'POST', '/api/expenses', body
    suite.jsonReq 201, options, string, done, (message, body) ->
      suite.expectFinanceObject body
      done()

  it 'should create using POST (using specified id)', (done) ->
    body =
      currency: 'cad'
      amount: 100
      tags: ['canadian', 'eh']
      created_at: Date.now()
      description: 'example-description'
      type: 'expense'
      id: id
    string = JSON.stringify body
    options = suite.jsonOptions 'POST', '/api/expenses', body
    suite.jsonReq 201, options, string, done, (message, body) ->
      suite.expectFinanceObject body
      done()

  it 'should retrieve/find using GET', (done) ->
    options = suite.optionsFrom 'GET', '/api/expenses/' + id
    suite.req 200, options, done, (message, body) ->
      suite.expectFinanceObject body
      done()
      ###
      expect(data.message).to.equal 'found'
      expect(data.body.successful).to.equal true
      expect(found.money.currency).to.equal 'cad'
      expect(found.money.amount).to.equal 100
      expect(found.description).to.equal 'example-description'
      expect(found.id).to.equal id
      ###

  it 'should update using PUT', (done) ->
    body =
      currency: 'nzd'
      amount: 70
      tags: ['canadian', 'eh', 'updated']
      created_at: Date.now()
      description: 'updated-example-description'
      type: 'expense'
      id: id

    string = JSON.stringify body
    options = suite.jsonOptions 'PUT', '/api/expenses', body
    suite.jsonReq 200, options, string, done, (message, body) ->
      suite.expectFinanceObject body
      expect(message).to.equal 'updated'
      expect(body.currency).to.equal 'nzd'
      expect(body.amount).to.equal 70
      expect(body.id).to.equal id
      done()

  it 'should list using GET', (done) ->
    options = suite.optionsFrom 'GET', '/api/expenses'

    suite.req 200, options, done, (message, body) ->
      expect(message).to.equal 'found'
      expect(body).to.be.an 'array'
      expect(body).to.have.length.of.at.least 1

      for financeOp in body
        suite.expectFinanceObject financeOp
      # expect(updated.tags).to.equal 'new-tag,old-tag'
      done()

  it 'should be able to list expenses with tag', (done) ->
    options = suite.optionsFrom 'GET', '/api/expenses/?tag=eh' #component-store
    suite.req 200, options, done, (message, list) ->
      expect(message).to.equal 'found'
      expect(list).to.be.an 'array'
      expect(list).to.have.length.of.at.least 1
      suite.expectFinanceObject list[0]
      done()
      #302

  it 'should be able to list expenses with date (timestamp)', (done) ->
    options = suite.optionsFrom 'GET', '/api/expenses/?date=' + new Date().getTime()

    suite.req 200, options, done, (message, list) ->
      expect(message).to.equal 'found'
      expect(list).to.be.an 'array'
      expect(list).to.have.length.of.at.least 1
      suite.expectFinanceObject list[0]
      done()
      #302

  it 'should be able to list expenses with date (y-m-d)', (done) ->
    date = new Date()
    month = date.getMonth()+1
    year = date.getFullYear()
    day = date.getDay()
    dateString = year + '-' + month + '-' + day
    options = suite.optionsFrom 'GET', '/api/expenses/?date=' + dateString

    suite.req 200, options, done, (message, list) ->
      expect(message).to.equal 'found'
      expect(list).to.be.an 'array'
      expect(list).to.have.length.of.at.least 1
      suite.expectFinanceObject list[0]
      done()
      #302

  it 'should give monthly report for expenses', (done) ->
    options = suite.optionsFrom 'GET', '/api/reports/expenses/monthly'
    suite.req 302, options, done, (message, report) ->
      expect(message).to.equal 'found'
      expect(report).to.be.an 'object'
      done()

  it 'should give monthly report for expenses (with month filter)', (done) ->
    options = suite.optionsFrom 'GET', '/api/reports/expenses/monthly/?year=2009&month=10'
    suite.req 302, options, done, (message, report) ->
      expect(message).to.equal 'found'
      expect(report).to.be.an 'object'
      done()

  it 'should report balance trends', (done) ->
    options = suite.optionsFrom 'GET', '/api/reports/trend'

    suite.req 200, options, done, (message, reports) ->
      expect(reports).to.be.an 'array'
      expect(reports).to.have.length.of.at.least 1
      for report in reports
        suite.expectAllProperties(
          report, ['income', 'expense', 'balance', 'month', 'year'])

      done()

  it 'should report balance trends (specified date)', (done) ->
    options = suite.optionsFrom 'GET', '/api/reports/trend/?start=2004-01-01&end=2015-12-30'

    suite.req 200, options, done, (message, reports) ->
      expect(reports).to.be.an 'array'
      expect(reports).to.have.length.of.at.least 1
      for report in reports
        suite.expectAllProperties(
          report, ['income', 'expense', 'balance', 'month', 'year'])

      done()

  it 'should test all component tests', (done) ->

    require './TestExtendedComponent.coffee'
    require './TestComponentCreate.coffee'
    require './TestComponentStore.coffee'
    require './TestComponentStoreUpdate.coffee'
    require './TestComponentValidate.coffee'
    require './TestComponentFetchWithMY.coffee'
    require './TestComponentAOE.coffee'
    require './TestComponentFetch.coffee'
    require './TestComponentTrend.coffee'
    require './TestComponentBalanceTrend.coffee'
    require './TestComponentList.coffee'
    require './TestComponentReports.coffee'
    done()

  it 'should not allow unauthorized access', (done) ->
    options = suite.optionsFrom 'GET', '/api/expenses/' + id
    options.headers =
      'Authorization': 'Bearer WRONGPASS'
    try
      req = http.request options, (res) ->
        if res.statusCode isnt 401
          return done new Error "Invalid status code: #{res.statusCode}"
        done()
      req.end()
    catch e
      done()

    suite.req 401, options, done, (message, body) ->
      done()

  it 'should delete using DELETE', (done) ->
    options = suite.optionsFrom 'DELETE', '/api/expenses/' + id
    suite.req 200, options, done, (message, body) ->
      expect(message).to.equal 'deleted'
      done()

  it 'should not be able to find a deleted finance operation', (done) ->
    options = suite.optionsFrom 'GET', '/api/expenses/' + id
    suite.req 404, options, done, (message, body) ->
      done()
