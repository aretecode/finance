moment = require 'moment'
finance = require './../src/Finance.coffee'

class BalanceTrend extends finance.ExtendedComponent
  description: 'Balance trending by month'
  icon: 'scale'

  constructor: ->
    @setInPorts
      in:
        datatype: 'object'
        required: true
      range:
        datatype: 'object'
    @setOutPorts
      out:
        datatype: 'object'
        required: true
      error:
        datatype: 'object'

    @inPorts.range.on 'data', (@range) =>

    @inPorts.in.on 'data', (data) =>
      @pg = finance.getConnection()

      earliest = finance.dateFrom(data.earliest)
      latest = finance.dateFrom(data.latest)
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

      findBetweenMonths = (type, cb) =>
        query = @pg('finance_op').select('id', 'amount', 'currency')
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

exports.getComponent = -> new BalanceTrend
