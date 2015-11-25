chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'
c = require('./../components/Store.coffee').getComponent()
moment = require 'moment'
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
      chai.expect(data.successful).to.equal true
      chai.expect(data.data.currency).to.equal 'AUS'
      chai.expect(data.data.amount).to.equal 20
      chai.expect(data.data.description).to.equal undefined
      createdAt = moment(data.data.created_at)
      chai.expect(createdAt.isValid()).to.equal true
      done()

    t.send
      name: 'expense'
      in: d
