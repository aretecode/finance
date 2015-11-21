chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'
c = require('./../components/Store.coffee').getComponent()

describe 'Test Store Component', ->
  t = new Tester c

  before (done) ->
    t.start ->
      done()

  it 'should send out correct params after storing data
      @TODO: NOT SURE HOW TO TEST...', (done) ->
    d =
      currency: 'AUS'
      amount: 20
      tags: 'component-store'
      # created_at: new Date()

    t.receive 'out', (data) ->
      # body = data.data
      # chai.expect(data.successful).to.equal true
      # chai.expect(body.currency).to.equal d.currency
      # chai.expect(body.amount).to.equal d.amount
      # chai.expect(body.created_at).to.equal d.created_at
      done()

    t.send
      name: 'expense'
      in: d
