noflo = require 'noflo'
{CRUD} = require './CRUD.coffee'

class Delete extends CRUD
  description: 'Deleting'
  icon: 'expand'

exports.getComponent = -> new Delete