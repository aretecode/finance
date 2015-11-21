noflo = require 'noflo'
{CRUD} = require './CRUD.coffee'

class List extends CRUD
  description: 'List finance operations.'
  icon: 'list'

exports.getComponent = -> new List
