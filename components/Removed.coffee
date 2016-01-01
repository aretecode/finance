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
      .catch (e) =>
        @error
          error: e
          req: data
          component: 'Removed'

exports.getComponent = -> new Removed
