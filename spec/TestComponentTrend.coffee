noflo = require 'noflo'
Tester = require 'noflo-tester'
chai = require 'chai'
chai.use require('chai-datetime')
c = require('./../components/Trend.coffee').getComponent()

describe 'Test Trend Component', ->
  t = new Tester c

  before (done) ->
    t.start ->
      done()

  it 'should send out (query) params (with range)', (done) ->
    d =
      query:
        start: new Date('2000-1-2')
        end: new Date()

    t.receive 'withrange', (data) ->
      chai.expect(data.earliest).to.be.afterDate(new Date('2000-1-1'))
      chai.expect(data.latest).to.be.afterDate(new Date('2000-1-1'))

      chai.expect(data.latest).to.be.beforeDate(new Date('2025-1-1'))
      chai.expect(data.earliest).to.be.beforeDate(new Date('2025-1-1'))
      done()

    t.send
      in: d

  it 'should send out params (without range)', (done) ->
    t.receive 'withoutrange', (data) ->
      done()

    t.send
      in: {}
