noflo = require 'noflo'
moment = require 'moment'
{_} = require 'underscore'

class Report
  constructor: (@month, @year, @income, @expense, @balance) ->

class Reports extends noflo.Component
  description: 'Reporting the balance trending by month'
  icon: 'report'

  constructor: ->
    @inPorts = new noflo.InPorts
      in:
        datatype: 'all'
        required: true
      balance:
        datatype: 'int'
      reports:
        datatype: 'array'

    @outPorts = new noflo.OutPorts
      out:
        datatype: 'object'
        required: true
      error:
        datatype: 'object'

    @inPorts.in.on 'balance', (@balance) =>
    @inPorts.in.on 'reports', (@reports) =>

    @inPorts.in.on 'data', (data) =>
      reports = @reports||[]
      balance = @balance||0
      range = data.range
      incomes = data.incomes
      expenses = data.expenses
      outPorts = @outPorts


      unless data.incomes? and data.expenses? and data.range?
        @outPorts.out.send
          success: false
        @outPorts.out.disconnect()
        return null

      yearAndMonthFilter = (item, month) ->
        item.created_at = moment(item.created_at)
        m = (item.created_at.month()+1)
        y = item.created_at.year()
        return true if y is year and m is month
        return false
      toNumber = (items, month) ->
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

      @outPorts.out.send
        success: true
        data: reports
      @outPorts.out.disconnect()

exports.getComponent = -> new Reports
