chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'
c = require('./../components/JsonBodyParserMiddleware.coffee').getComponent()
express = require 'express'

describe 'Test JsonBodyParserMiddleware Component', ->
  t = new Tester c

  before (done) ->
    t.start ->
      done()

  it 'should...', (done) ->
    t.receive 'out', (data) ->
      done()

    t.send
      in: ""
