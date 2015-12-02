noflo = require 'noflo'
{Database} = require './Database.coffee'
{Factory} = require './../src/Finance.coffee'

class Fetch extends Database
  description: 'Find a finance operation.'
  icon: 'search'

  constructor: ->
    super()
    @inPorts.in.on 'data', (data) =>
      @setPg()
      # 0. selecting all fields
      # 1. selecting all of the tags
      # 2. merging them into a comma separated list
      # 3. only where the id is the same as the one in data
      # 3a. (which has been validated)
      query = 'SELECT *,
          array(
            SELECT "tags".tag
            FROM "tags"
            WHERE "tags".id = "finance_op".id
          ) AS tags
        FROM "finance_op"
        WHERE "finance_op".id = \'' + data.id + "'"

      @pg.raw(query)
      .then (rows) =>
        if rows.rows.length is 0
          @sendThenDisc
            success: false
            data: []
        else
          @sendThenDisc
            success: true
            data: rows.rows[0]
        @pg.destroy()
      .catch (e) =>
        @error
          error: e
          component: 'fetch'
        @pg.destroy()

exports.getComponent = -> new Fetch
