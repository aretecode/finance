_ = require 'underscore'
{ExtendedComponent} = require './ExtendedComponent.coffee'
{DatabaseComponent} = require './DatabaseComponent.coffee'
{InvokableComponent} = require './InvokableComponent.coffee'

# module.exports.ExtendedComponent = ExtendedComponent

dbconfig = ->
  config =
    conn:
      host: process.env.DATABASE_HOST
      user: process.env.DATABASE_USER
      password: process.env.DATABASE_PASSWORD
      database: process.env.DATABASE_NAME
      charset: 'utf8'
      port: 5432
    pool:
      min: 2
      max: 20
  config


module.exports = {
  dateFrom: (date) ->
    unless date?
      return new Date()
    # if date is null or date is undefined
      # return date
    if date instanceof Date
      return date
    else if typeof date is 'string' and date.includes('-')
      return new Date(date)
    else if not _.isNaN(parseInt(date)) # _.isFinite
      return new Date(parseInt(date))
    else if typeof date is 'string'
      return new Date(date)
    if not date instanceof Date
      return new Date(date)
    return date

  uniqArrFrom: (arr) ->
    return _.uniq arr if Array.isArray arr
    return _.uniq arr.split(',') if arr.includes ','
    return [arr] if typeof arr is 'string'
    throw new Error("#{arr} was not an array, or a string!")

  dbconfig: ->
    config =
      conn:
        host: process.env.DATABASE_HOST
        user: process.env.DATABASE_USER
        password: process.env.DATABASE_PASSWORD
        database: process.env.DATABASE_NAME
        charset: 'utf8'
        port: 5432
      pool:
        min: 2
        max: 20
    config

  getConnection: ->
    {conn, pool} = dbconfig()
    con = require('knex')(client: 'pg', connection: conn, pool)
    con

  hijackConsoleLog: ->
    [
      'log'
      'warn'
    ].forEach (method) ->
      old = console[method]
      console[method] = ->
        stack = (new Error).stack.split(/\n/)
        # Chrome includes a single "Error" line, FF doesn't.
        stack = stack.slice(1) if stack[0].indexOf('Error') == 0
        args = [].slice.apply(arguments).concat([stack[1].trim()])
        old.apply console, args
      return

  DatabaseComponent: DatabaseComponent
  InvokableComponent: InvokableComponent
  ExtendedComponent: ExtendedComponent
}
# module.exports.DatabaseComponent = DatabaseComponent
# module.exports.InvokableComponent = InvokableComponent
