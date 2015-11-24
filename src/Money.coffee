class Money 
  ### 
  @param {string|Currency} currency - must be valid in Currencies @see Validate
  @param {int} amount       
  ###
  constructor: (@currency, @amount) ->
 
  ### @type{Money} ###
  equals: (money) ->
    if money.currency is @currency and money.amount is @amount 
      return true 
    return false

module.exports.Money = Money