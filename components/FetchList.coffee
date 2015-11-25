noflo = require 'noflo'
{_} = require 'underscore'
{Database} = require './Database.coffee'
{Factory} = require './../src/Finance.coffee'
dateFromAny = require('./../src/Util/dateFromAny.coffee').dateFromAny

class FetchList extends Database
  description: 'Fetch the list of finance operations.'
  icon: 'list'

  constructor: ->
    super()
    @inPorts.in.on 'data', (data) =>
      @pg = require('./../src/Persistence/connection.coffee').getPg()
      {pg, table, outPorts} = {@pg, @table, @outPorts}

      if data.query? and data.query.tag?
        query = '
        SELECT *,
          array_to_string(array(
            SELECT "tags".tag
            FROM "tags"
            WHERE "tags".id = "'+table+'".id
          ), \', \') AS tags
          FROM "'+table+'"
          INNER JOIN "tags" ON "tags".id = "'+table+'".id
        WHERE "tags".tag = \'' + 'eh' + "'" #\'eh\'';

        @pg.raw(query).then (rows) ->
          row = rows.rows
          result = unless row.length is 1 then true else false
          item = Factory.hydrateAllMergedFrom table, row
          outPorts.out.send
            successful: result
            data: row
          outPorts.out.disconnect()
        return

      else if data.query? and data.query.date?
        date = dateFromAny data.query.date
        month = date.getMonth()+1
        year = date.getFullYear()
        query = @pg(@table).select()
        .whereRaw("EXTRACT(MONTH FROM created_at) = " + month)
        .andWhereRaw("EXTRACT(YEAR FROM created_at) = " + year)
        .toString()

        @pg.raw(query)
        .then (row) -> return row.rows
        .map (item) ->
          pg.select().from('tags').where(id: item.id).then (tag) -> return tag
          .then (tags) ->
            Factory.hydrateFrom table, item, tags
        .then (row) ->
          result = unless row.length is 1 then true else false
          outPorts.out.send
            successful: result
            data: row
          outPorts.out.disconnect()
        return
        # message = table + ' listing not found for month: `' +
        # date.getMonth() + '` and year: `' + date.getFullYear() + '`'

      @pg(table).select().then (row) -> return row
      .map (item) ->
        pg.select().from('tags').where(id: item.id).then (tags) ->
          Factory.hydrateFrom table, item, tags
      .then (row) ->
        row = _.uniq row
        result = unless row.length is 1 then true else false
        outPorts.out.send
          successful: result
          data: row
        outPorts.out.disconnect()

exports.getComponent = -> new FetchList
