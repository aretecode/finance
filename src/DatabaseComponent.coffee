ExtendedComponent = require './ExtendedComponent.coffee'

class DatabaseComponent extends ExtendedComponent
  sendThenDiscThenDestroy: (name, data) ->
    @sendThenDiscon name, data
    @pg.destroy()
  sendThenDiscThenDest: (name, data) ->
    @sendThenDiscThenDestroy name, data

  # http://noflojs.org/api/Component.html
  error: (e, groups = [], errorPort = 'error') =>
    @pg.destroy()
    if @outPorts[errorPort] and (@outPorts[errorPort].isAttached() or not @outPorts[errorPort].isRequired())
      @outPorts[errorPort].beginGroup group for group in groups
      @outPorts[errorPort].send e
      @outPorts[errorPort].endGroup() for group in groups
      @outPorts[errorPort].disconnect()
      return
    throw e

module.exports.DatabaseComponent = DatabaseComponent
