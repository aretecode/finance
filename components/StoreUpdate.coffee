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
      @setPg()

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
      .then (rows) =>
        # we have no tags, send it out
        if data.tags?
          @outPorts.out.send
            success: rows is 1
            data: update
          @outPorts.out.disconnect()

        else
          tags = util.uniqArrFrom data.tags
          @pg('tags').where(hasId).del().then (deleted) ->
            saveTag = (tag, cb) ->
              @pg
              .insert(tag)
              .into('tags')
              .whereNotExists( ->
                @select(@pg.raw(1)).from('tags')
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
                  @outPorts.out.send
                    success: rows is 1
                    data: update
                  @outPorts.out.disconnect()
                  @pg.destroy()
              saveTag
                tag: tag.name
                id: update.id
              , cb||null
      .catch (e) =>
        @error
          message: 'could not update!'
          error: e
          data: data
          component: 'StoreUpdate'
        @pg.destroy()

exports.getComponent = -> new StoreUpdate
