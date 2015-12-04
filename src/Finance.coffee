_ = require 'underscore'
{ExtendedComponent} = require('./ExtendedComponent.coffee')

{DatabaseComponent} = require('./DatabaseComponent.coffee')
{DefaultInOutComponent} = require('./DefaultInOutComponent.coffee')

module.exports.ExtendedComponent = ExtendedComponent

module.exports.dateFrom = (date) ->
  unless date?
    return new Date()
  # if date is null or date is undefined
    # return date
  if date instanceof Date
    return date
  else if _.isString(date) and date.includes('-')
    date = new Date(date)
  else if not _.isNaN(parseInt(date))
    date = new Date(parseInt(date))
  else if _.isString date
    date = new Date(date)
  if not date instanceof Date
    date = new Date(date)
  return date

module.exports.uniqArrFrom = (arr) ->
  return _.uniq arr if _.isArray arr
  return _.uniq arr.split(',') if arr.includes ','
  return [arr] if _.isString arr

  throw new Error("#{arr} was not an array, or a string!")

module.exports.dbconfig = ->
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

module.exports.getConnection = ->
  {conn, pool} = module.exports.dbconfig()
  con = require('knex')(client: 'pg', connection: conn, pool)
  con

module.exports.hijackConsoleLog = ->
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

module.exports.DatabaseComponent = DatabaseComponent
module.exports.DefaultInOutComponent = DefaultInOutComponent
