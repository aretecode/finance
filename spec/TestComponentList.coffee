chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'
c = require('./../components/FetchList.coffee').getComponent()

describe 'Test List Component', ->
  t = new Tester c

  before (done) ->
    t.start ->
      done()

  it 'should send the results from the db', (done) ->
    t.receive 'out', (data) ->
      chai.expect(data).to.be.a 'object'
      done()

    t.send
      type: 'expense'
      in: 'empty input?'
