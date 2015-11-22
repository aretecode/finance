_ = require 'underscore'
uuid = require 'uuid'
{Tag} = require('./Tag.coffee')

class FinanceOperation
  ### 
  @TODO: Validate types
  @param {Money}      money
  @param {array<Tag>} tags        1+
  @param {Timestamp}  created_at  (optional) default: now
  @param {String}     description (optional)
  ###
  constructor: (@id, @money, tags, @created_at = new Date, @description = "") ->
    @tags = Tag.tagsFrom tags

  ###
  @param FinanceOperation or child
  @TODO: could return what is false 
  ###
  equals: (finance) ->
    if finance.money.equals(@money) and finance.tags is @tags and finance.created_at is @created_at and finance.description is @description
      return true 
    return false

  hasTag: (tagName) ->
    if _.isArray @tags
      for tag in @tags
        return true if tagName is tag.name
      return false
    return if (@tags.name is tagName) then true else false 
 
  tagsAsString: ->
    tags = ''
    for tag in @tags
      tags += tag.name + ',' 
    return tags.substring(0, tags.length - 1) # trim the trailing comma

### @desc tracks spendings ###
class Expense extends FinanceOperation

### @desc tracks earnings ###
class Income extends FinanceOperation

module.exports.Expense = Expense
module.exports.Income = Income
module.exports.FinanceOperation = FinanceOperation