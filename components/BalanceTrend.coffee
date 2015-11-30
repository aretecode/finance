noflo = require 'noflo'
{_} = require 'underscore'
util = require './../src/Finance.coffee'

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
        required: true
      error:
        datatype: 'object'

    @inPorts.range.on 'data', (@range) =>

    @inPorts.in.on 'data', (data) =>
      @pg = require('./../src/Persistence/connection.coffee').getPg()

      earliestFrom = (earliest) ->
        e = earliest.getFullYear() + '-' +
          (earliest.getMonth()+1) + '-' +
          earliest.getDate() + ' '
          '0' + latest.getHours() + ':' + latest.getMinutes()
        return e

      latestFrom = (latest) ->
        l = latest.getFullYear() + '-' +
          (latest.getMonth()+1) + '-' +
          (latest.getDate()) + ' ' +
          '0' + latest.getHours() + ':' + latest.getMinutes()
        return l

      earliest = util.dateFrom data.earliest
      latest = util.dateFrom data.latest
      e = earliestFrom(earliest)
      l = latestFrom(latest)

      if data? and data.range? and data.range.startMonth?
        @range = data.range

      unless @range?
        @range =
          startMonth: earliest.getMonth()+1
          startYear: earliest.getFullYear()
          endMonth: latest.getMonth()+1
          endYear: latest.getFullYear()

      {pg, range, outPorts} = {@pg, @range, @outPorts}
      # select only amount & currency
      findBetweenMonths = (table, cb) ->
        query = pg('finance_op').select()
        .whereRaw('"finance_op".created_at <= \'' +l+ '\'::DATE')
        .andWhereRaw('"finance_op".created_at >= \'' +e+ '\'::DATE')
        .andWhere('type', table)
        .toString()

        pg.raw(query).then (all) -> return all.rows
        .map (item) ->
          pg.select('tag').from('tags').where(id: item.id).then (tagRow) ->
            item.tags = tagRow
            return item
        .then (all) ->
          cb all
        .catch (e) ->
          _this.error
            error: e
            component: 'BalanceTrend'

      findBetweenMonths 'income', (incomes) ->
        findBetweenMonths 'expense', (expenses) ->
          outPorts.out.send
            range: range
            incomes: incomes
            expenses: expenses
          outPorts.out.disconnect()

exports.getComponent = -> new BalanceTrend
