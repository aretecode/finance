chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'
c = require('./../components/Reports.coffee').getComponent()

describe 'Test Reports Component', ->
  t = new Tester c

  before (done) ->
    t.start ->
      done()

  it 'should send out false with no incomes and expenses', (done) ->
    t.receive 'out', (data) ->
      chai.expect(data.successful).to.equal false
      done()

    t.send
      in: ""
