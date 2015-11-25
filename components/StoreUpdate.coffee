noflo = require 'noflo'
{_} = require 'underscore'
uuid = require 'uuid'
{Tag} = require './../src/Tag.coffee'
{Database} = require './Database.coffee'
dateFromAny = require('./../src/Util/dateFromAny.coffee').dateFromAny

class StoreUpdate extends Database
  description: 'Store the Updated the data.'

  constructor: ->
    super()
    @inPorts.in.on 'data', (data) =>
      @pg = require('./../src/Persistence/connection.coffee').getPg()

      update =
        id: data.id
      update.currency = data.currency if data.currency?
      update.created_at = data.created_at if data.created_at?
      update.amount = data.amount if data.amount?
      update.description = data.description if data.description?

      @pg(@table)
      .where('id', '=', data.id)
      .update(update)
      .then (rows) ->
        _this.outPorts.out.send
          successful: rows is 1
          data: update
        _this.outPorts.out.disconnect()
      .catch (e) ->
        console.log e

      # delete old ones, add new ones
      return unless data.tags?
        
      cb = null
      tags = Tag.tagsFrom data.tags
      _this.pg('tags').where(id: data.id).del().then (deleted) ->
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
            if _.isFunction cb
              cb tag
          )
          # .catch ((e) -> _this.error(e))
        for tag in tags
          if tag is _.last tags # only want to call cb on the last one
            cb = (result) -> # outPorts.out.send result
          saveTag
            tag: tag.name
            id: update.id
          , cb

exports.getComponent = -> new StoreUpdate
