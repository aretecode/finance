noflo = require 'noflo'
{_} = require 'underscore'
uuid = require 'uuid'
{Database} = require './Database.coffee'
util = require './../src/Finance.coffee'
moment = require 'moment'

class Store extends Database
  description: 'Store the data.'

  constructor: ->
    super()
    @inPorts.in.on 'data', (data) =>
      @setPg()

      store =
        currency: data.currency
        amount: data.amount
        description: data.description
        type: @table
      store.id = if data.id? then data.id else uuid.v4()

      store.created_at = util.dateFrom data.created_at
      tags = util.uniqArrFrom data.tags

      @pg.insert(store).into('finance_op')
      .then (rows) =>
        for tag in tags
          # when it is last one, @pg.destroy()
          saveTag
            tag: tag
            id: store.id

        stored = _.clone store
        stored.tags = tags
        @sendThenDisc
          success: rows.rowCount is 1
          data: stored
      .catch (e) =>
        @pg.destroy()

        if e.code is 23505
          @sendThenDisc
            success: 'duplicate'
            data: data
            stored: stored
        else
          @error
            message: 'could not save!'
            error: e
            component: 'Store'

      saveTag = (tag, cb) =>
        @pg
        .insert(tag)
        .into('tags')
        .whereNotExists( =>
          @select(@pg.raw(1)).from('tags')
          .where(id: tag.id)
          .andWhere(tag: tag.tag)
        )
        .then (tag) ->
          if _.isFunction cb
            cb tag
        .catch (e) =>
          @error e

exports.getComponent = -> new Store
