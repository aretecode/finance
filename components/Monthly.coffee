noflo = require 'noflo'
{CRUD} = require './CRUD.coffee'

class Monthly extends CRUD
  description: 'Monthly reporting for finance operations'

exports.getComponent = -> new Monthly