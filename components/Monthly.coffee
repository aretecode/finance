{CRUD} = require './CRUD.coffee'

exports.getComponent = ->
  c = new CRUD
  c.sendBody = false
  c.sendQuery = true
  c.description = 'Monthly reporting for finance operations'
  c.icon = 'calendar-o'
  c
