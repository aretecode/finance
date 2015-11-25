{CRUD} = require './CRUD.coffee'

exports.getComponent = ->
  c = new CRUD
  c.description = 'Updating'
  c.icon = 'save'
  c
