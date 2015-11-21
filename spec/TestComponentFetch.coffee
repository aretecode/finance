chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'
c = require('./../components/Fetch.coffee').getComponent()

describe 'Test Fetch Component', ->
  t = new Tester c

  before (done) ->
    t.start ->
      done()

  it 'should send out correct params after storing data
      @TODO: NOT SURE HOW TO TEST...', (done) ->
   
    d =
      id: '3462fa39-37ea-4110-809f-fd82f74cff95'

    t.receive 'out', (data) ->
      console.log data      
      done()

    t.send
      name: 'expense'
      in: d
