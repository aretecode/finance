uuid = require 'uuid'
moment = require 'moment'
{Database} = require './Database.coffee'
util = require './../src/Finance.coffee'

class Store extends Database
  description: 'Store the data.'

  constructor: ->
    super()
    @inPorts.in.on 'data', (data) =>
      @setPg()
      b = data.body
      store =
        currency: b.currency
        amount: b.amount
        description: b.description
        type: @type
      store.id = if b.id? then b.id else uuid.v4()
      store.created_at = util.dateFrom b.created_at

      @pg.insert(store).into('finance_op').then (rows) =>
        tags = if b.tags? then util.uniqArrFrom(b.tags) else null
        if tags?
          for tag in tags
            saveTag
              tag: tag
              id: store.id

        store.tags = tags
        @sendThenDisc
          success: rows.rowCount is 1
          data: store
          req: data

      .catch (e) =>
        if e.code is 23505
          @sendThenDisc
            success: 'duplicate'
            data: b
            stored: store
            req: data
        else
          @error
            message: 'could not save!'
            error: e
            component: 'Store'
            req: data

      saveTag = (tag, cb) =>
        @pg
        .insert(tag)
        .into('tags')
        .whereNotExists( =>
          @select(@pg.raw(1)).from('tags')
          .where(id: tag.id)
          .andWhere(tag: tag.tag)
        )
        .then (tag) =>
          cb tag if typeof cb is 'function'
        .catch (e) =>
          @error e

exports.getComponent = -> new Store
