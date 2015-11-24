chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'
c = require('./../components/FetchWithMonthYear.coffee').getComponent()

describe 'Test Monthly>FetchWithMonthYear Component', ->
  t = new Tester c

  before (done) ->
    t.start ->
      done()

  it 'should send out correct params after fetching data for Month & Year', (done) ->
    d =
      year: new Date().getFullYear()
      month: new Date().getMonth()+1

    t.receive 'out', (data) ->
      chai.expect(data.successful).to.equal true
      chai.expect(data.data).to.be.an 'object'        
      # expect all properties
      # get all tags from db      
      done()

    t.receive 'error', (data) ->
      # console.log data
      done()

    t.send
      name: 'expense'
      in:  d

