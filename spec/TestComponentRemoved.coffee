chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'
c = require('./../components/Removed.coffee').getComponent()

describe 'Test Removed Component', ->
  t = new Tester c

  before (done) ->
    t.start ->
      done()

  it 'should not be able to delete when it does not exist', (done) ->
    d =
      params:
        id: '3462fa39-37ea-4110-809f-fd82f74cff95'

    t.receive 'out', (data) ->
      chai.expect(data.success).to.equal false
      done()

    t.send
      type: 'expense'
      in: d
