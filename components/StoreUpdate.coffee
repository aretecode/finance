uuid = require 'uuid'
noflo = require 'noflo'
{_} = require 'underscore'
{Database} = require './Database.coffee'
util = require './../src/Finance.coffee'

class StoreUpdate extends Database
  description: 'Store the Updated the data.'

  constructor: ->
    super()
    @inPorts.in.on 'data', (data) =>
      @setPg()
      body = data.body

      update =
        id: body.id
      update.currency = body.currency if body.currency?
      update.created_at = util.dateFrom body.created_at if body.created_at?
      update.amount = body.amount if body.amount?
      update.description = body.description if body.description?

      hasId = id: body.id

      updated = _.clone update
      updated.tags = body.tags

      @pg('finance_op')
      .where(hasId)
      .update(update)
      .then (rows) =>
        # we have no tags, send it out
        unless body.tags?
          @sendThenDisc
            success: rows.length is 1
            body: updated
            req: data
          @pg.destroy()

        tags = util.uniqArrFrom body.tags
        @pg('tags').where(hasId).del().then (deleted) =>
          saveTag = (tag, cb) =>
            @pg
            .insert(tag)
            .into('tags')
            .then (tag) =>
              cb tag if _.isFunction cb
          for tag in tags
            if tag is _.last tags # only want to call cb on the last one
              cb = (result) =>
                @sendThenDisc
                  success: true
                  data: updated
                  req: data
                @pg.destroy()
            saveTag
              tag: tag
              id: update.id
            , cb||null
      .catch (e) =>
        @error
          error: e
          data: data
          component: 'StoreUpdate'
          message: 'could not update!'
          req: data
        @pg.destroy()

exports.getComponent = -> new StoreUpdate
