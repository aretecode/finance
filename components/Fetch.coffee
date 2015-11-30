noflo = require 'noflo'
{Database} = require './Database.coffee'
{Factory} = require './../src/Finance.coffee'

class Fetch extends Database
  description: 'Find a finance operation.'
  icon: 'search'

  constructor: ->
    super()
    @pg = require('./../src/Persistence/connection.coffee').getPg()

    @inPorts.in.on 'data', (data) =>
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
      .then (rows) ->
        if rows.rows.length is 0
          _this.outPorts.out.send
            success: false
            data: []
        else
          _this.outPorts.out.send
            success: true
            data: rows.rows[0]

        _this.outPorts.out.disconnect()
      .catch (e) ->
        _this.error e

exports.getComponent = -> new Fetch
