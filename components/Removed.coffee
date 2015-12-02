noflo = require 'noflo'
{Database} = require './Database.coffee'

class Removed extends Database
  description: 'Find a finance operation.'
  icon: 'trash'

  constructor: ->
    super()
    @inPorts.in.on 'data', (data) =>
      @setPg()
      hasId = id: data.id
      @pg('finance_op').where(hasId).del().then (result) =>
        @pg('tags').where(hasId).del().then (tagResult) =>
          result.tags = tagResult
          @sendThenDisc
            success: result is 1
            data: result
          @pg.destroy()
      .catch (e) =>
        @error
          data: data
          error: e
          component: 'Removed'
        @pg.destroy()

exports.getComponent = -> new Removed
