noflo = require 'noflo'
{_} = require 'underscore'
uuid = require 'uuid'
{Database} = require './Database.coffee'
util = require './../src/Finance.coffee'

class StoreUpdate extends Database
  description: 'Store the Updated the data.'

  constructor: ->
    super()
    @inPorts.in.on 'data', (data) =>
      @pg = require('./../src/Persistence/connection.coffee').getPg()

      update =
        id: data.id
      update.currency = data.currency if data.currency?
      update.created_at = util.dateFrom data.created_at if data.created_at?
      update.amount = data.amount if data.amount?
      update.description = data.description if data.description?

      hasId = id: data.id

      @pg('finance_op')
      .where(hasId)
      .update(update)
      .then (rows) ->
        # we have no tags, send it out
        if data.tags?
          _this.outPorts.out.send
            success: rows is 1
            data: update
          _this.outPorts.out.disconnect()

        else
          eh = 1
          tags = util.uniqArrFrom data.tags
          _this.pg('tags').where(hasId).del().then (deleted) ->
            saveTag = (tag, cb) ->
              _this.pg
              .insert(tag)
              .into('tags')
              .whereNotExists( ->
                @select(_this.pg.raw(1)).from('tags')
                .where(id: tag.id)
                .andWhere(tag: tag.tag)
              )
              .then ((tag) ->
                cb tag if _.isFunction cb
              )
              .catch ((e) -> console.log e)
            for tag in tags
              if tag is _.last tags # only want to call cb on the last one
                cb = (result) ->
                  _this.outPorts.out.send
                    success: rows is 1
                    data: update
                  _this.outPorts.out.disconnect()
              saveTag
                tag: tag.name
                id: update.id
              , cb||null
      .catch (e) ->
        console.log e
        _this.error
          message: 'could not update!'
          error: e

exports.getComponent = -> new StoreUpdate
