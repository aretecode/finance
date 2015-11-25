noflo = require 'noflo'
{_} = require 'underscore'
uuid = require 'uuid'
{Tag} = require './../src/Tag.coffee'
{Database} = require './Database.coffee'
dateFromAny = require('./../src/Util/dateFromAny.coffee').dateFromAny

class Store extends Database
  description: 'Store the data.'

  constructor: ->
    super()
    @inPorts.in.on 'data', (data) =>
      @pg = require('./../src/Persistence/connection.coffee').getPg()

      store =
        currency: data.currency
        amount: data.amount
        created_at: data.created_at
        description: data.description

      store.id = if data.id? then data.id else uuid.v4()
      store.created_at = dateFromAny data.created_at
      unless store.created_at? # @TODO: CHANGE DATEFROMANY
        store.created_at = new Date()

      @pg.insert(store).into(@table)
      .then (rows) ->
        _this.outPorts.out.send
          successful: rows.rowCount is 1
          data: store
        _this.outPorts.out.disconnect()

      .catch (e) ->
        console.log e
        _this.error
          message: 'could not save!'
          error: e

      ############################################ TAGS ##########
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
      tags = Tag.tagsFrom data.tags
      for tag in tags
        saveTag
          tag: tag.name
          id: store.id

exports.getComponent = -> new Store