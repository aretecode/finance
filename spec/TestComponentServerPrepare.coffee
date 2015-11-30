chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'
c = require('./../components/PrepareServer.coffee').getComponent()

describe 'Test FlowHubServerPrepare Component', ->
  t = new Tester c

  before (done) ->
    t.start ->
      done()

  it 'should make sure it sends out & after port', (done) ->

    t.receive 'out', (data) ->
      console.log data

    t.receive 'after', (data) ->
      console.log data
      done()

    t.send
      in: 'start'
