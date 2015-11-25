{CRUD} = require './CRUD.coffee'

exports.getComponent = ->
  c = new CRUD
  c.description = 'Find a finance operation.'
  c.icon = 'search'
  c
