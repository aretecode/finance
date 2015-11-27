chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'
c = require('./../components/AlphaOmegaEntries.coffee').getComponent()
suite = require './testsuite'

describe 'Test AlphaOmegaEntries Component', ->
  t = new Tester c

  before (done) ->
    t.start ->
      done()

  it 'should send out earliest & latest', (done) ->
    t.receive 'out', (data) ->
      chai.expect(data).to.be.an 'object'
      suite.expectValidDate(data.earliest)
      suite.expectValidDate(data.latest)
      done()

    t.send
      in: ""
