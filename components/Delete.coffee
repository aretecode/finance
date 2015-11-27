{CRUD} = require './CRUD.coffee'

exports.getComponent = ->
  c = new CRUD
  c.sendParams = true
  c.sendBody = false
  c.description = 'Deleting'
  c.icon = 'trash'
  c
