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
      params:
        startMonth: 1
        startYear: 2000
        endMonth: 12
        endYear: 2050
      res:
        'res'

    t.receive 'res', (data) ->
      chai.expect(data).to.equal d.res
      done()

    t.send
      req: d

  it 'should send out params', (done) ->
    d =
      params:
        startMonth: 1
        startYear: 2000
        endMonth: 12
        endYear: 2050
      res:
        'res'

    t.receive 'out', (data) ->
      chai.expect(data).to.equal d.params
      done()

    t.send
      req: d

  it 'should send out params', (done) ->
    d =
      params:
        startMonth: 1
        startYear: 2000
        endMonth: 12
        endYear: 2050
      res:
        'res'

    t.receive 'out', (data) ->
      chai.expect(data).to.equal d.params
      done()

    t.send
      req: d
