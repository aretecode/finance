chai = require 'chai'
suite = require './testsuite'
Tester = require 'noflo-tester'
c = require('./../components/BalanceTrend.coffee').getComponent()

describe 'Test BalanceTrend Component', ->
  t = new Tester c

  before (done) ->
    t.start ->
      done()

  it 'should send out object with expenses and income arrays', (done) ->
    d =
      query:
        start: new Date('2000-1-1')
        end: new Date()

    t.receive 'out', (data) ->
      chai.expect(data).to.be.an 'object'
      chai.expect(data.incomes).to.be.an 'array'
      chai.expect(data.expenses).to.be.an 'array'
      suite.expectValidDate(data.created_at)
      done()

    t.send
      in: d
