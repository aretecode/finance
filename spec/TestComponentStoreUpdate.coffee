chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'
c = require('./../components/StoreUpdate.coffee').getComponent()

###
describe 'Test StoreUpdate Component', ->
  t = new Tester c

  before (done) ->
    t.start ->
      done()

  it 'should send out correct params after storing UPDATED data', (done) ->
    d =
      id: '003125ad-d043-41d4-825d-958d54a89d4e'
      currency: 'AUS'
      amount: 20
      tags: 'component-store-update'

    t.receive 'out', (data) ->
      chai.expect(data.successful).to.equal true
      # body = data.data
      # chai.expect(data.successful).to.equal true
      # chai.expect(body.currency).to.equal d.currency
      # chai.expect(body.amount).to.equal d.amount
      # chai.expect(body.created_at).to.equal d.created_at
      done()

    t.send
      name: 'expense'
      in: d
###