chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'
c = require('./../components/FetchWithMonthYear.coffee').getComponent()

describe 'Test Monthly>FetchWithMonthYear Component', ->
  t = new Tester c

  before (done) ->
    t.start ->
      done()

  it 'should send out correct params after fetching data for Month & Year
      @TODO: NOT SURE HOW TO TEST...', (done) ->
   
    d =
      year: new Date().getFullYear()
      month: new Date().getMonth()+1

    t.receive 'out', (data) ->
      console.log data      
      done()

    t.send
      name: 'expense'
      in:  d

