{Database} = require './Database.coffee'

class FetchWithMonthYear extends Database
  description: 'Find a finance operation with a specific Month & Year.'
  icon: 'area-chart'

  constructor: ->
    super()
    @inPorts.in.on 'data', (data) =>
      @setPg()

      year = data.year or new Date().getFullYear()
      month = data.month or new Date().getMonth()+1
      tags = {}

      query = @pg('finance_op').select()
      .whereRaw('EXTRACT(MONTH FROM created_at) = ' + month)
      .andWhereRaw('EXTRACT(YEAR FROM created_at) = ' + year)
      .andWhere('type', @type)
      .toString()

      @pg.raw(query).then (all) => all.rows
      .map (item) =>
        @pg.select('tag').from('tags').where(id: item.id).then (tagRow) ->
          item.tags = tagRow.map (tag) -> tag.tag
          item
      .then (items) =>
        for item in items
          for tag in item.tags
            if item.tags.indexOf(tag) > -1
              tags[tag] = (tags[tag] or 0) + item.amount

        @sendThenDisc
          success: tags?
          data: tags
          req: data # any component after Validate has just data...

      .catch (e) =>
        @error
          req: data
          message: @type + ' reporting not found for month: `' +
            data.month + '` and year: `' + data.year + '`'
          error: e

exports.getComponent = -> new FetchWithMonthYear
