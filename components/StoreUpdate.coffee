noflo = require 'noflo'
{_} = require 'underscore'
uuid = require 'uuid'
{Tag} = require './../src/Tag.coffee'
{Database} = require './Database.coffee'
dateFromAny = require('./../src/Util/dateFromAny.coffee').dateFromAny

class StoreUpdate extends Database
  description: 'Store the Updated the data.'

  childConstructor: ->
    @inPorts.in.on 'data', (data) =>
      @pg = require('./../src/Persistence/connection.coffee').getPg()

      updateData =
        id: data.id
      updateData.currency = data.currency if data.currency?
      updateData.created_at = data.created_at if data.created_at?
      updateData.amount = data.amount if data.amount?
      updateData.description = data.description if data.description?

      @pg(@table)
      .where('id', '=', data.id)
      .update(updateData)
      .then (rows) ->
        _this.outPorts.out.send
          successful: rows is 1
          data: updateData
        _this.outPorts.out.disconnect()
      .catch (e) ->
        console.log e

exports.getComponent = -> new StoreUpdate