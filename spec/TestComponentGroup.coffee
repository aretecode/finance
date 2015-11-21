chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'

# A simple component
c = new noflo.Component
c.description = 'Multiplies its inputs'
c.inPorts = new noflo.InPorts
  x:
    datatype: 'int'
  y:
    datatype: 'int'
c.outPorts.add 'xy', datatype: 'int'
noflo.helpers.WirePattern c,
  in: ['x', 'y']
  out: 'xy'
  async: true
  forwardGroups: true
, (input, groups, out, done) ->
  setTimeout ->
    out.send input.x * input.y
    done()
  , 0


describe 'Default tester playing with groups', ->
  t = new Tester c

  before (done) ->
    t.start ->
      done()

  it 'should pass all data chunks, groups and counts on receive', (done) ->
    x = [1, 2, 3]
    y = [4, 5, 6]
    expectedData = [4, 10, 18]
    expectedGroups = ['foo', 'bar']

    t.receive 'xy', (data, groups, dataCount, groupCount) ->
      chai.expect(data).to.eql expectedData
      chai.expect(groups).to.eql expectedGroups
      chai.expect(dataCount).to.equal expectedData.length
      chai.expect(groupCount).to.equal expectedGroups.length
      done()

    # Sending groups
    t.ins.x.beginGroup 'foo'
    t.ins.x.beginGroup 'bar'
    t.ins.y.beginGroup 'foo'
    t.ins.y.beginGroup 'bar'

    for i in [0...3]
      t.ins.x.send x[i]
      t.ins.y.send y[i]

    # endGroup affects groupCount
    t.ins.x.endGroup()
    t.ins.x.endGroup()
    t.ins.y.endGroup()
    t.ins.y.endGroup()

    # receive is only triggered after disconnect
    t.ins.x.disconnect()
    t.ins.y.disconnect()