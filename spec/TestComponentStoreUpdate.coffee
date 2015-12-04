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
      body:
        id: '003125ad-d043-41d4-825d-958d54a89d4e'
        currency: 'AUS'
        amount: 20
        tags: 'component-store-update'
      req: {}
    t.receive 'out', (data) ->
      done()
    t.receive 'error', (data) ->
      done()

    t.send
      type: 'expense'
      in: d
