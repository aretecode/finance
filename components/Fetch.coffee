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
      {outPorts, table} = {@outPorts, @table}

      # 0. selecting all fields
      # 1. selecting all of the tags
      # 2. merging them into a comma separated list
      # 3. only where the id is the same as the one in data
      # 3a. (which has been validated)
      query = 'SELECT *,
          array_to_string(array(
            SELECT "tags".tag
            FROM "tags"
            WHERE "tags".id = "'+table+'".id
          ), \', \') AS tags
        FROM "'+table+'"
        WHERE "'+table+'".id = \'' + data.id + '\''

      @pg.raw(query)
      .then (rows) ->
        if rows.rows.length is 0
          outPorts.out.send
            successful: false
            data: []
        else
          result = Factory.hydrateMergedFrom table, rows.rows[0]
          outPorts.out.send
            successful: true
            data: result

        outPorts.out.disconnect()

exports.getComponent = -> new Fetch
