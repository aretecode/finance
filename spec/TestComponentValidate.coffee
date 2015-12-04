uuid = require 'uuid'
chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'
c = require('./../components/Validate.coffee').getComponent()

describe 'Validate', ->
  t = new Tester c

  before (done) ->
    t.start ->
      done()

  it 'should send the same data out when nothing is invalid', (done) ->
    d =
      body:
        currency: 'CAD'
        amount: 10
      query: {}
      params: {}

    t.receive 'out', (data) ->
      chai.expect(data).to.equal d
      done()

    t.send
      in: d

  it 'should give an error for an invalid amount.', (done) ->
    t.receive 'error', (data) ->
      chai.expect(data.errors[0].key).to.equal 'amount'
      done()

    t.send
      in:
        body:
          currency: 'CAD'
          amount: 'string eh'
        query: {}
        params: {}

  it 'should give an error for an invalid currency.', (done) ->
    t.receive 'error', (data) ->
      chai.expect(data.errors[0].key).to.equal 'currency'
      done()

    t.send
      in:
        body:
          currency: 'NONEXISTENT'
          amount: 1
        query: {}
        params: {}

  it 'should give an error for an invalid amount *and* currency.', (done) ->
    t.receive 'error', (data) ->
      chai.expect(data.errors[0].key).to.equal 'amount'
      chai.expect(data.errors[1].key).to.equal 'currency'
      done()

    t.send
      in:
        body:
          currency: 100
          amount: {key: 'object'}
        query: {}
        params: {}

  # do for params, body, and query
  it 'should give an error for an invalid id.', (done) ->
    t.receive 'error', (data) ->
      chai.expect(data.errors[0].key).to.equal 'id'
      done()

    t.send
      in:
        params:
          id: 'notreal'
        body: {}
        query: {}

  it 'should give a the same output as the input with a valid uuid.', (done) ->
    id = uuid.v4()
    t.receive 'out', (data) ->
      chai.expect(data.params.id).to.equal id
      done()

    t.receive 'error', (data) ->
      done()

    t.send
      in:
        params:
          id: id
        body: {}
        query: {}
