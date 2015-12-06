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
      port = parseInt data
      chai.expect(port).to.be.a 'number'
      chai.expect(port).to.be.at.least 0
      chai.expect(port).to.be.at.most 80000
      done()

    t.send
      in: 'go go gadget server'
