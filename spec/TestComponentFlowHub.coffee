chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'
r = require('./../components/FlowHubReq.coffee').getComponent()
f = require('./../components/FinanceFacade.coffee').getComponent()
q = require('./../components/FlowHubRequests.coffee').getComponent()

describe 'Test FlowHubReq Component', ->
  # t = new Tester r

  it 'should... @TODO: listening port and such', (done) ->
    done()

describe 'Test FinanceFacade Component', ->
  t = new Tester f

  before (done) ->
    t.start ->
      done()

  it 'should make sure it sends out 1', (done) ->
    t.receive 'out', (data) ->
      done()

    t.send
      retrieve:
        id: 'id-here'
        cb: (() ->)

    # create:
    # update:
    # delete:
    # list:
    # monthly:
    # trend:

describe 'Test FlowHubRequests Component', ->
  t = new Tester q

  before (done) ->
    t.start ->
      done()

  it 'should make sure it sends out 1', (done) ->
    t.receive 'retrieve', (data) ->
      done()

    t.send
      retrieve:
        id: 'id-here'
        cb: (() ->)

    # create:
    # update:
    # delete:
    # list:
    # monthly:
    # trend:
