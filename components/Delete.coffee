noflo = require 'noflo'
{CRUD} = require './CRUD.coffee'

class Delete extends CRUD
  description: 'Deleting'
  icon: 'trash'

exports.getComponent = -> new Delete