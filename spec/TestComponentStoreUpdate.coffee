chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'
c = require('./../components/StoreUpdate.coffee').getComponent()

describe 'Test StoreUpdate Component', ->
  t = new Tester c

  before (done) ->
    t.start ->
      done()

  it 'should send out correct params after not updating data', (done) ->
    d =
      id: '003125ad-d043-41d4-825d-958d54a89d4e'
      currency: 'AUS'
      amount: 20
      tags: 'component-store-update'

    t.receive 'out', (data) ->
      chai.expect(data.data.currency).to.equal d.currency
      chai.expect(data.data.amount).to.equal d.amount
      # chai.expect(data.data.tags).to.equal d.tags
      # chai.expect(data.data.created_at).to.equal d.created_at
      done()

    t.send
      name: 'expense'
      in: d
