noflo = require 'noflo'
{CRUD} = require './CRUD.coffee'

class Create extends CRUD
  description: 'Creating'
  icon: 'gavel'

exports.getComponent = -> new Create