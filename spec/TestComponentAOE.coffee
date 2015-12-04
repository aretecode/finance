chai = require 'chai'
suite = require './testsuite'
Tester = require 'noflo-tester'
c = require('./../components/AlphaOmegaEntries.coffee').getComponent()

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

    # @TODO: truncate table, then do this test again
    t.receive 'error', (data) ->
      done(throw new Error('error port triggered'))

    t.send
      in: ""
