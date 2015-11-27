chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'
c = require('./../components/Store.coffee').getComponent()
suite = require './testsuite'
describe 'Test Store Component', ->
  t = new Tester c

  before (done) ->
    t.start ->
      done()

  it 'should send out correct params after storing data
    (without specifying created_at or description)', (done) ->
    d =
      currency: 'AUS'
      amount: 20
      tags: 'component-store'

    t.receive 'out', (data) ->
      chai.expect(data.success).to.equal true
      chai.expect(data.data.currency).to.equal 'AUS'
      chai.expect(data.data.amount).to.equal 20
      chai.expect(data.data.description).to.equal undefined
      suite.expectValidDate(data.data.created_at)
      done()

    t.send
      name: 'expense'
      in: d
