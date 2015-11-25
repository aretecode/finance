noflo = require 'noflo'
{Database} = require './Database.coffee'

class Removed extends Database
  description: 'Find a finance operation.'
  icon: 'trash'

  childConstructor: ->
    @pg = require('./../src/Persistence/connection.coffee').getPg()
    @inPorts.in.on 'data', (data) =>
      hasId = id: data.id
      @pg(@table).where(hasId).del().then (result) ->
        _this.outPorts.out.send
          successful: result is 1
          data: result
        _this.outPorts.out.disconnect()
        _this.pg('tags').where(hasId).del()
        .then (result) -> return result
        .catch (e) ->
          console.log e, 'this may fail if deleting while saving tags...'
          _this.outPorts.out.send
            successful: false
            data: ':-('
          _this.outPorts.out.disconnect()

exports.getComponent = -> new Removed