chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'
c = require('./../components/FetchWithMonthYear.coffee').getComponent()

describe 'Test Monthly>FetchWithMonthYear Component', ->
  t = new Tester c

  before (done) ->
    t.start ->
      done()

  it 'should send out correct params
  after fetching data for Month & Year', (done) ->
    d =
      year: new Date().getFullYear()
      month: new Date().getMonth()+1

    t.receive 'out', (data) ->
      chai.expect(data.success).to.equal true
      chai.expect(data.data).to.be.an 'object'
      for tag, value in data.data
        console.log tag, value
        chai.expect(tag).to.be.a 'string'
        chai.expect(value).to.be.an 'int'
      # expect all properties, get all tags from db
      done()

    t.receive 'error', (data) ->
      done()

    t.send
      name: 'expense'
      in:  d
