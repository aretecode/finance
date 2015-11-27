chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'
c = require('./../components/Trend.coffee').getComponent()

describe 'Test Trend Component', ->
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

  it 'should send out (query) params (with range)', (done) ->
    d =
      query:
        start: new Date('2000-1-1')
        end: new Date()
        # startMonth: 1
        # startYear: 2000
        # endMonth: 12
        # endYear: 2050
      res:
        'res'


    t.receive 'withrange', (data) ->
      # chai.expect(data.range.startMonth).to.equal d.query.startMonth
      # chai.expect(data.range.startYear).to.equal d.query.startYear
      # chai.expect(data.range.endMonth).to.equal d.query.endMonth
      # chai.expect(data.range.endYear).to.equal d.query.endYear
      done()

    t.send
      req: d

  it 'should send out params (without range)', (done) ->
    d =
      res:
        'res'

    t.receive 'withoutrange', (data) ->
      done()

    t.send
      req: d
