chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'
c = require('./../components/Create.coffee').getComponent()

describe 'Test Create Component', ->
  t = new Tester c

  before (done) ->
    t.start ->
      done()

  it 'should send out res', (done) ->
    d =
      query:
        currency: 'CAD'
        amount: 10
      res:
        'res'

    t.receive 'res', (data) ->
      chai.expect(data).to.equal d.res
      done()

    t.send
      req: d

  it 'should send out (query) params', (done) ->
    d =
      body:
        currency: 'CAD'
        amount: 10
      res:
        'res'

    t.receive 'out', (data) ->
      chai.expect(data).to.equal d.body
      done()

    t.send
      req: d
