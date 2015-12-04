noflo = require 'noflo'
{Database} = require './Database.coffee'

class Removed extends Database
  description: 'Find a finance operation.'
  icon: 'trash'

  constructor: ->
    super()
    @inPorts.in.on 'data', (data) =>
      @setPg()
      hasId = id: data.params.id
      @pg('finance_op').where(hasId).del().then (result) =>
        @pg('tags').where(hasId).del().then (tagResult) =>
          @sendThenDisc
            success: result is 1
            data:
              deleted: result
              tagsDeleted: result
            req: data
            con: @pg
          @pg.destroy()
      .catch (e) =>
        console.log 'was an error...'
        @error
          error: e
          con: @pg
          req: data
          component: 'Removed'
        @pg.destroy()
exports.getComponent = -> new Removed
