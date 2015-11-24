noflo = require 'noflo'
{_} = require 'underscore'
{Factory} = require './../src/Boot.coffee'

tagArrayToString = (tagRow) ->
  tags = ''
  tags += (tag.tag + ',') for tag in tagRow
  return tags.substring(0, tags.length - 1) # trim the trailing comma

class BalanceTrend extends noflo.Component
  description: 'Balance trending by month'
  icon: 'scale'

  constructor: ->
    @inPorts = new noflo.InPorts
      in:
        datatype: 'all'
        required: true
      range:
        datatype: 'object'
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'object'
      error:
        datatype: 'object'

    @inPorts.range.on 'connect', (range) =>
      @range = range

    @inPorts.in.on 'data', (data) =>
      @pg = require('./../src/Persistence/connection.coffee').getPg()

      if data.hasOwnProperty 'startMonth'
        @range = data
 
      unless @range?
        earliest = new Date(data.earliest)
        latest = new Date(data.latest)
        @range =
          startMonth: earliest.getMonth()+1
          startYear: earliest.getFullYear()
          endMonth: latest.getMonth()+1
          endYear: latest.getFullYear()

      {pg, range, outPorts} = {@pg, @range, @outPorts}
      # select only amount & currency
      findBetweenMonths = (table, cb) ->
        query = pg(table).select()
        .whereRaw("EXTRACT(YEAR FROM created_at) >= " + range.startYear)
        .andWhereRaw("EXTRACT(YEAR FROM created_at) <= " + range.endYear)
        .andWhereRaw("EXTRACT(MONTH FROM created_at) >= " + range.startMonth)
        .andWhereRaw("EXTRACT(MONTH FROM created_at) <= " + range.endMonth)
        .toString()

        pg.raw(query).then (all) -> return all.rows
        .map (item) ->
          pg.select('tag').from('tags').where(id: item.id).then (tagRow) ->
            Factory.hydrateFrom table, item, tagArrayToString(tagRow)
        .then (all) ->
          cb _.flatten(all)

      findBetweenMonths 'income', (incomes) ->
        findBetweenMonths 'expense', (expenses) ->
          outPorts.out.send
            range: range
            incomes: incomes
            expenses: expenses
          outPorts.out.disconnect()

    @inPorts.in.on 'connect', =>
      @outPorts.out.connect()
    @inPorts.in.on 'begingroup', (group) =>
      @outPorts.out.beginGroup group
    @inPorts.in.on 'endgroup', =>
      @outPorts.out.endGroup()

exports.getComponent = -> new BalanceTrend
