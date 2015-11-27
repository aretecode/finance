{CRUD} = require './CRUD.coffee'

exports.getComponent = ->
  c = new CRUD
  c.description = 'List finance operations.'
  c.icon = 'list'
  c.sendQuery = true
  c
