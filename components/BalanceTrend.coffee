noflo = require 'noflo'
{_} = require 'underscore'
util = require './../src/Finance.coffee'
moment = require 'moment'

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

      {pg, range, outPorts} = {@pg, @range, @outPorts}
      # select only amount & currency
      findBetweenMonths = (table, cb) ->
        query = pg('finance_op').select()
        .whereRaw('"finance_op".created_at::DATE <= \'' +l+ '\'::DATE')
        .andWhereRaw('"finance_op".created_at::DATE >= \'' +e+ '\'::DATE')
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
