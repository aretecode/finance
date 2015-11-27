chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'
c = require('./../components/Fetch.coffee').getComponent()

describe 'Test Fetch Component', ->
  t = new Tester c

  before (done) ->
    t.start ->
      done()

  it 'should not be able to find when it does not exist', (done) ->
    d =
      id: '3462fa39-37ea-4110-809f-fd82f74cff95'

    t.receive 'out', (data) ->
      chai.expect(data.success).to.equal false
      # chai.expect(data.data.id).to.equal d.id
      done()

    t.send
      name: 'expense'
      in: d
