noflo = require 'noflo'
{CRUD} = require './CRUD.coffee'

class Retrieve extends CRUD
  description: 'Find a finance operation.'
  icon: 'search'

exports.getComponent = -> new Retrieve
