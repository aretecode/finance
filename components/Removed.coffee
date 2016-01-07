{Database} = require './Database.coffee'

class Removed extends Database
  description: 'Find a finance operation.'
  icon: 'trash'

  constructor: ->
    super()
    @inPorts.in.on 'data', (data) =>
      @setPg()
      @pg('tags').where(id: data.params.id).del().then (tagResult) =>
        @pg('finance_op').where(id: data.params.id).del().then (result) =>
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
