chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'
c = require('./../components/BalanceTrend.coffee').getComponent()
moment = require 'moment'

describe 'Test BalanceTrend Component', ->
  t = new Tester c

  before (done) ->
    t.start ->
      done()

  it 'should send out object with expenses and income arrays', (done) ->
    t.receive 'out', (data) ->
      chai.expect(data).to.be.an 'object'
      chai.expect(data.incomes).to.be.an 'array'
      chai.expect(data.expenses).to.be.an 'array'
      createdAt = moment(data.created_at)
      chai.expect(createdAt.isValid()).to.equal true
      done()

    t.send
      in:
        startMonth: 1
        startYear: 2000
        endMonth: 12
        endYear: 2050
