{Database} = require './Database.coffee'

class Removed extends Database
  description: 'Find a finance operation.'
  icon: 'trash'

  constructor: ->
    super()
    @inPorts.in.on 'data', (data) =>
      @setPg()
      hasId = id: data.params.id
      @pg('tags').where(hasId).del().then (tagResult) =>
        @pg('finance_op').where(hasId).del().then (result) =>
          @sendThenDisc
            success: result is 1
            data:
              deleted: result
              tagsDeleted: tagResult
            req: data
      .catch (e) =>
        @error
          error: e
          req: data
          component: 'Removed'

exports.getComponent = -> new Removed
