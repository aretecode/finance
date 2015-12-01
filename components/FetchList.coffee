noflo = require 'noflo'
{_} = require 'underscore'
{Database} = require './Database.coffee'
util = require('./../src/Finance.coffee')

class FetchList extends Database
  description: 'Fetch the list of finance operations.'
  icon: 'list'

  constructor: ->
    super()
    @inPorts.in.on 'data', (data) =>
      @setPg()

      {pg, table, outPorts} = {@pg, @table, @outPorts}
      if data.query? and data.query.tag?
        query = '
        SELECT *,
          array(
            SELECT "tags".tag
            FROM "tags"
            WHERE "tags".id = "finance_op".id
          ) AS tags
          FROM "finance_op"
          INNER JOIN "tags" ON "tags".id = "finance_op".id
        WHERE "tags".tag = \'' +data.query.tag+ '\'
        AND "finance_op".type = \''+table+'\''

        @pg.raw(query).then (rows) ->
          outPorts.out.send
            success: rows.rows.length isnt 0
            data: rows.rows
          outPorts.out.disconnect()
        return

      else if data.query? and data.query.date?
        date = util.dateFrom data.query.date
        month = date.getMonth()+1
        year = date.getFullYear()
        query = @pg('finance_op').select()
        .whereRaw('EXTRACT(MONTH FROM created_at) = ' + month)
        .andWhereRaw('EXTRACT(YEAR FROM created_at) = ' + year)
        .andWhere('type', table)
        .toString()

        @pg.raw(query)
        .then (rows) ->
          rows.rows.map (item) ->
            pg.select().from('tags').where(id: item.id).then (tags) ->
              item.tags = tags

          outPorts.out.send
            success: rows.rows.length isnt 0
            data: rows.rows
          outPorts.out.disconnect()

        return
        # message = table + ' listing not found for month: `' +
        # date.getMonth() + '` and year: `' + date.getFullYear() + '`'

      @pg('finance_op').select().where('type', table).then (row) -> row
      .map (item) ->
        pg.select().from('tags').where(id: item.id).then (tags) ->
          item.tags = tags
          item
      .then (rows) ->
        _this.pg.destroy()
        outPorts.out.send
          success: rows.length isnt 0
          data: rows
        outPorts.out.disconnect()

exports.getComponent = -> new FetchList
