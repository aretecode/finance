noflo = require 'noflo'
{_} = require 'underscore'
{Database} = require './Database.coffee'

class FetchWithMonthYear extends Database
  description: 'Find a finance operation with a specific Month & Year.'
  icon: 'area-chart'

  constructor: ->
    super()
    @inPorts.in.on 'data', (data) =>
      @setPg()

      data.year = new Date().getFullYear() unless data.year?
      data.month = new Date().getMonth()+1 unless data.month?
      tags = {}

      query = @pg('finance_op').select()
      .whereRaw('EXTRACT(MONTH FROM created_at) = ' + data.month)
      .andWhereRaw('EXTRACT(YEAR FROM created_at) = ' + data.year)
      .andWhere('type', @table)
      .toString()

      @pg.raw(query).then (all) => all.rows
      .map (item) =>
        @pg.select('tag').from('tags').where(id: item.id).then (tagRow) ->
          item.tags = tagRow.map (tag) -> tag.tag
          item
      .then (items) =>
        for item in items
          for tag in item.tags
            if _.contains item.tags, tag
              tags[tag] = (tags[tag]||0) + item.amount

        @pg.destroy()
        @sendThenDisc
          success: tags?
          data: tags
      .catch (e) =>
        @pg.destroy()
        @error
          message: @table + ' reporting not found for month: `' +
            data.month + '` and year: `' + data.year + '`'
          error: e

exports.getComponent = -> new FetchWithMonthYear
