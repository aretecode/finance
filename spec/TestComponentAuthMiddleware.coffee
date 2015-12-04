chai = require 'chai'
express = require 'express'
suite = require './testsuite'
Tester = require 'noflo-tester'
c = require('./../components/AuthMiddleware.coffee').getComponent()

describe 'Test AuthMiddleware Component', ->
  t = new Tester c

  before (done) ->
    t.start ->
      done()

  it 'should ', (done) ->
    d =
      express()

    t.receive 'app', (data) ->
      # chai.expect(data).to.be.an 'object'
      done()

    t.send
      app: d
