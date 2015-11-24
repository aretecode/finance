chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'
c = require('./../components/AlphaOmegaEntries.coffee').getComponent()
moment = require 'moment'

describe 'Test AlphaOmegaEntries Component', ->
  t = new Tester c

  before (done) ->
    t.start ->
      done()

  it 'should send out earliest & latest', (done) ->
    t.receive 'out', (data) ->
      chai.expect(data).to.be.an 'object'
      earliest = moment(data.earliest)
      latest = moment(data.latest)
      chai.expect(earliest.isValid()).to.equal true
      chai.expect(latest.isValid()).to.equal true
      
      done()

    t.send
      in: ""

