{Database} = require './Database.coffee'
util = require('./../src/Finance.coffee')

class FetchList extends Database
  description: 'Fetch the list of finance operations.'
  icon: 'list'

  constructor: ->
    super()
    @inPorts.in.on 'data', (data) =>
      @setPg()

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
        AND "finance_op".type = \''+@type+'\''

        @pg.raw(query).then (rows) =>
          @sendThenDisc
            success: rows.rows.length isnt 0
            data: rows.rows
            req: data
        .catch (e) =>
          @error
            error: e
            data: data
            component: 'FetchList'
        return

      else if data.query? and data.query.date?
        date = util.dateFrom data.query.date
        month = date.getMonth()+1
        year = date.getFullYear()
        query = @pg('finance_op').select()
        .whereRaw('EXTRACT(MONTH FROM created_at) = ' + month)
        .andWhereRaw('EXTRACT(YEAR FROM created_at) = ' + year)
        .andWhere('type', @type)
        .toString()

        @pg.raw(query)
        .then (rows) =>
          rows.rows.map (item) =>
            @pg.select().from('tags').where(id: item.id).then (tags) =>
              item.tags = tags
          @sendThenDisc
            success: rows.rows.length isnt 0
            data: rows.rows
            req: data
        .catch (e) =>
          @error
            error: e
            data: data
            component: 'FetchList'
        return

      @pg('finance_op').select().where('type', @type).then (row) => row
      .map (item) =>
        @pg.select().from('tags').where(id: item.id).then (tags) =>
          item.tags = tags
          item
      .then (rows) =>
        @sendThenDisc
          success: rows.length isnt 0
          data: rows
          req: data
      .catch (e) =>
        @error
          error: e
          data: data
          component: 'FetchList'

exports.getComponent = -> new FetchList
