noflo = require 'noflo'
{_} = require 'underscore'
{Database} = require './Database.coffee'

class FetchWithMonthYear extends Database
  description: 'Find a finance operation with a specific Month & Year.'
  icon: 'area-chart'

  constructor: ->
    super()
    @inPorts.in.on 'data', (data) =>
      conn =
        host: process.env.DATABASE_HOST
        user: process.env.DATABASE_USER
        password: process.env.DATABASE_PASSWORD
        database: process.env.DATABASE_NAME
        charset: 'utf8'
        port: 5432
      pool =
        min: 2
        max: 20
      @pg = require('knex')(client: 'pg', connection: conn, pool, debug: true)

      data.year = new Date().getFullYear() unless data.year?
      data.month = new Date().getMonth()+1 unless data.month?
      tags = {}

      query = @pg('finance_op').select()
      .whereRaw('EXTRACT(MONTH FROM created_at) = ' + data.month)
      .andWhereRaw('EXTRACT(YEAR FROM created_at) = ' + data.year)
      .andWhere('type', @table)
      .toString()

      @pg.raw(query).then (all) -> return all.rows
      .map (item) ->
        _this.pg.select('tag').from('tags').where(id: item.id).then (tagRow) ->
          item.tags = tagRow.map (tag) -> tag.tag
          return item
      .then (items) ->
        # getting all the tags from all the items
        for item in items
          for tag in item.tags
            tags[tag] = 0

        # go through all tags & get corresponding items
        for tag, value of tags
          for item in items
            tags[tag] += item.amount if _.contains item.tags, tag

        _this.outPorts.out.send
          success: tags?
          data: tags
        _this.outPorts.out.disconnect()

      .catch (e) ->
        _this.error
          message: _this.table + ' reporting not found for month: `' +
            data.month + '` and year: `' + data.year + '`'
          error: e

exports.getComponent = -> new FetchWithMonthYear
