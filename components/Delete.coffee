{CRUD} = require './CRUD.coffee'

exports.getComponent = ->
  c = new CRUD
  c.description = 'Deleting'
  c.icon = 'trash'
  c
