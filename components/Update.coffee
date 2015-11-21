noflo = require 'noflo'
{CRUD} = require './CRUD.coffee'

class Update extends CRUD
  description: 'Updating'
  icon: 'save'

exports.getComponent = -> new Update