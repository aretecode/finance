moment = require 'moment'
finance = require './../src/Finance.coffee'

class Report
  constructor: (@month, @year, @income, @expense, @balance) ->

class Reports extends finance.ExtendedComponent
  description: 'Reporting the balance trending by month'
  icon: 'report'

  constructor: ->
    @setInPorts
      in:
        datatype: 'all'
        required: true
      # balance:
      # datatype: 'int'
      # reports:
      # datatype: 'array'

    @setOutPorts
      out:
        datatype: 'object'
        required: true
      error:
        datatype: 'object'

    # @inPorts.balance.on 'data', (@balance) =>
    # @inPorts.reports.on 'data', (@reports) =>

    @inPorts.in.on 'data', (data) =>
      reports = @reports or []
      balance = @balance or 0
      range = data.range
      incomes = data.incomes
      expenses = data.expenses

      unless data.incomes? and data.expenses? and data.range?
        @sendThenDisc
          success: false
          data:
            range: data.range
            incomes: data.incomes
            expenses: data.expenses
          req: data.req
        return

      yearAndMonthFilter = (item, month) =>
        item.created_at = moment item.created_at
        m = (item.created_at.month()+1)
        y = item.created_at.year()
        return if y is year and m is month then true else false
      toNumber = (items, month) =>
        items = items.filter (item) ->
          yearAndMonthFilter(item, month)

        return 0 if items.length is 0

        return items
        .map (item) -> item.amount
        .reduce (a, b) -> a+b

      for year in [range.startYear .. range.endYear]
        for month in [0 .. 12]
          continue if year is range.startYear and month < range.startMonth
          continue if year is range.endYear and month > range.endMonth
          monthIncomes = toNumber incomes, month
          monthExpenses = toNumber expenses, month
          balance += (monthIncomes - monthExpenses)
          reports.push new Report(month,
            year, monthIncomes, monthExpenses, balance)

      @sendThenDisconnect
        success: true
        data: reports
        req: data.req

exports.getComponent = -> new Reports
