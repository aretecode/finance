noflo = require 'noflo'
{Database} = require './Database.coffee'

class Removed extends Database
  description: 'Find a finance operation.'
  icon: 'search'

  childConstructor: ->
    @pg = require('./../src/Persistence/connection.coffee').getPg()

    toError = (msg) ->
      if outPorts.error.isAttached()
        outPorts.error.send new Error msg
        outPorts.error.disconnect()
        return
      console.log msg
      throw new Error msg

    @inPorts.in.on 'data', (data) =>
      {outPorts, table, pg} = {@outPorts, @table, @pg}

      hasId = id: data.id
      @pg(@table).where(hasId).del().then (result) ->
        outPorts.out.send
          successful: result is 1
          data: result

        pg('tags').where(hasId).del()
        .then (result) -> return result
        .catch (e) ->
          console.log e
          console.log 'this may fail if deleting while saving tags...'
          outPorts.out.send
            successful: false
            data: ':-('

exports.getComponent = -> new Removed