uuid = require 'uuid'
{Database} = require './Database.coffee'
util = require './../src/Finance.coffee'

class StoreUpdate extends Database
  description: 'Store the Updated the data.'

  constructor: ->
    super()
    @inPorts.in.on 'data', (data) =>
      @setPg()
      b = data.body

      update =
        id: b.id
      update.currency = b.currency if b.currency?
      update.created_at = util.dateFrom b.created_at if b.created_at?
      update.amount = b.amount if b.amount?
      update.description = b.description if b.description?

      hasId = id: b.id
      updated = require('util')._extend({}, update)
      updated.tags = b.tags

      @pg('finance_op')
      .where(hasId)
      .update(update)
      .then (rows) =>
        # we have no tags, send it out
        unless b.tags?
          @sendThenDisc
            success: rows.length is 1
            body: updated
            req: data

        tags = util.uniqArrFrom b.tags
        @pg('tags').where(hasId).del().then (deleted) =>
          saveTag = (tag, cb) =>
            @pg
            .insert(tag)
            .into('tags')
            .then (tag) =>
              cb tag if cb instanceof Function
          for tag in tags
            # only want to call cb on the last one
            if tag is tags[tags.length-1]
              cb = (result) =>
                @sendThenDisc
                  success: true
                  data: updated
                  req: data
            saveTag
              tag: tag
              id: update.id
            , cb or null
      .catch (e) =>
        @error
          error: e
          data: data
          component: 'StoreUpdate'
          message: 'could not update!'
          req: data

exports.getComponent = -> new StoreUpdate
