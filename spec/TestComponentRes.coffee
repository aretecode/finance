chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'
c = require('./../components/Res.coffee').getComponent()

describe 'Test Res Component', ->
  t = new Tester c

  before (done) ->
    t.start ->
      done()

  it 'should not be able to find when it does not exist', (done) ->
    try
      t.send
        created:
          data:
            req:
              res: 'eh'
            success: false
            data: 'test'
    catch e
      done()
