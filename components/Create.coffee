{CRUD} = require './CRUD.coffee'

exports.getComponent = ->
  c = new CRUD
  c.description = 'Creating'
  c.icon = 'gavel'
  c
