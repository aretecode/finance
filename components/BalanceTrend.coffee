noflo = require 'noflo'
{_} = require 'underscore'
util = require './../src/Finance.coffee'
moment = require 'moment'

class BalanceTrend extends util.ExtendedComponent
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
      @pg = util.getConnection()

      earliest = util.dateFrom(data.earliest)
      latest = util.dateFrom(data.latest)
      e = moment(earliest).format()
      l = moment(latest).format()

      if data? and data.range? and data.range.startMonth?
        @range = data.range

      unless @range?
        @range =
          startMonth: earliest.getMonth()+1
          startYear: earliest.getFullYear()
          endMonth: latest.getMonth()+1
          endYear: latest.getFullYear()

      # select only amount & currency
      findBetweenMonths = (type, cb) =>
        query = @pg('finance_op').select()
        .whereRaw('"finance_op".created_at::DATE <= \'' +l+ '\'::DATE')
        .andWhereRaw('"finance_op".created_at::DATE >= \'' +e+ '\'::DATE')
        .andWhere('type', type)
        .toString()

        @pg.raw(query).then (all) -> all.rows
        .map (item) =>
          @pg.select('tag').from('tags').where(id: item.id).then (tagRow) ->
            item.tags = tagRow
            item
        .then (all) =>
          cb all
        .catch (e) =>
          @error
            error: e
            component: 'BalanceTrend'

      findBetweenMonths 'income', (incomes) =>
        findBetweenMonths 'expense', (expenses) =>
          @sendThenDisc
            req: data.req
            range: @range
            incomes: incomes
            expenses: expenses
          @pg.destroy()

exports.getComponent = -> new BalanceTrend
