_ = require 'underscore'
uuid = require 'uuid'
dateFromAny = require('./Util/dateFromAny.coffee').dateFromAny
{Money} = require('./Money.coffee')
{Tag} = require('./Tag.coffee')
{Expense, Income} = require('./FinanceOperation.coffee')

tagArrayToString = (tagRow) ->
  tags = ''
  tags += (tag.tag + ',') for tag in tagRow
  return tags.substring(0, tags.length - 1) # trim the trailing comma

# AbstractFinanceOperationFactory
class Factory 
  ### @see {Money, FinanceOperation} ###
  @createFrom: (opType, id, currency, amount, tags, createdAt = new Date(), description = "") =>
    c = dateFromAny(createdAt)
    id = uuid.v4() if id is null or id is undefined
    money = new Money(currency, amount)

    if opType is 'income'
      return new Income(id, money, tags, createdAt, description) 
    else if opType is 'expense'
      return new Expense(id, money, tags, createdAt, description) 

  @hydrateFrom: (opType, o, tags) ->
    c = new Date(o.created_at)
    
    if _.isArray tags
      tags = tagArrayToString tags

    Factory.createFrom(
      opType, o.id, o.currency, o.amount, tags, c, o.description)

  @hydrateAllFrom: (opType, objs, tags) ->
    objs.map (o) -> Factory.hydrateFrom(opType, o, tags)
  
  @hydrateMergedFrom: (opType, o) ->   
    c = new Date(o.created_at)
    return Factory.createFrom(
      opType, o.id, o.currency, o.amount, o.tags, c, o.description)

  @hydrateAllMergedFrom: (opType, objs) ->   
    objs.map (o) -> Factory.hydrateMergedFrom(opType, o)

  @income: (id, currency, amount, tags, createdAt = new Date, description = "") ->
    Factory.createFrom('income', id, currency, amount, tags, createdAt, description)
  @expense: (id, currency, amount, tags, createdAt = new Date, description = "") ->
    Factory.createFrom('expense', id, currency, amount, tags, createdAt, description)

module.exports.Factory = Factory