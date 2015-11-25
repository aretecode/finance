chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'
c = require('./../components/Validate.coffee').getComponent()
uuid = require 'uuid'

describe 'Validate', ->
  t = new Tester c

  before (done) ->
    t.start ->
      done()

  it 'should send the same data out when nothing is invalid', (done) ->
    d =
      currency: 'CAD'
      amount: 10

    t.receive 'out', (data) ->
      chai.expect(data).to.equal d
      done()

    t.send
      in: d

  it 'should give an error for an invalid amount.', (done) ->
    t.receive 'error', (data) ->
      chai.expect(data.key).to.equal 'amount'
      done()

    t.send
      in:
        currency: 'CAD'
        amount: 'string eh'

  it 'should give an error for an invalid currency.', (done) ->
    t.receive 'error', (data) ->
      chai.expect(data.key).to.equal 'currency'
      done()

    t.send
      in:
        currency: 'NONEXISTENT'
        amount: 1

  it 'should give an error for an invalid id.', (done) ->
    t.receive 'error', (data) ->
      chai.expect(data.key).to.equal 'id'
      done()

    t.send
      id:
        id: 'notreal'

  it 'should give a the same output as the input with a valid uuid.', (done) ->
    id = uuid.v4()
    t.receive 'out', (data) ->
      chai.expect(data).to.equal id
      done()

    t.receive 'error', (data) ->
      done()

    t.send
      id: id
