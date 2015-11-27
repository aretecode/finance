_ = require 'underscore'
{ExtendedComponent} = require('./ExtendedComponent.coffee')

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
