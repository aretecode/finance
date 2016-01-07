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

      updated = require('util')._extend({}, update)
      updated.tags = b.tags

      updateOperation = (tagDeletionResult) =>
        @pg('finance_op')
        .where(id: b.id)
        .update(update)
        .then (rows) =>
          # we have no tags, send it out
          @sendThenDisc
            success: true
            data: updated
            req: data
        .catch (e) =>
          @error
            error: e
            data: updated
            component: 'StoreUpdate'
            message: 'could not update!'
           req: data

      tags = if b.tags? then util.uniqArrFrom(b.tags) else null

      # if we have no tags, just do the update,
      # otherwise do the tags and then the main update
      return updateOperation() unless tags?

      @pg('tags').where(id: b.id).del().then (deleted) =>
        saveTag = (tag, cb) =>
          @pg
          .insert(tag)
          .into('tags')
          .then (tag) =>
            cb(tag) if typeof cb is 'function'
        for tag in tags
          # only want to call cb on the last one
          if tag is tags[tags.length-1]
            cb = updateOperation
          saveTag
            tag: tag
            id: update.id
          , cb or null

      .catch (e) =>
        @error
          error: e
          data: updated
          component: 'StoreUpdate'
          message: 'could not update!'
          req: data

exports.getComponent = -> new StoreUpdate
