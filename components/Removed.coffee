noflo = require 'noflo'
{Database} = require './Database.coffee'
pg = require('./../src/Persistence/connection.coffee').getPg()

class Removed extends Database
  description: 'Find a finance operation.'
  icon: 'trash'

  constructor: ->
    super()
    @inPorts.in.on 'data', (data) =>
      hasId = id: data.id
      pg('finance_op').where(hasId).del().then (result) ->
        pg('tags').where(hasId).del()
        .then (tagResult) ->
          _this.outPorts.out.send
            success: result is 1
            data: result, tagResult
          _this.outPorts.out.disconnect()
      .catch (e) ->
        _this.error
          data: data
          error: e
          component: 'Removed'

exports.getComponent = -> new Removed
