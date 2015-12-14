uuid = require 'uuid'
noflo = require 'noflo'
moment = require 'moment'
{_} = require 'underscore'
{Database} = require './Database.coffee'
util = require './../src/Finance.coffee'

class Store extends Database
  description: 'Store the data.'

  constructor: ->
    super()
    @inPorts.in.on 'data', (data) =>
      @setPg()
      body = data.body
      store =
        currency: body.currency
        amount: body.amount
        description: body.description
        type: @type
      store.id = if body.id? then body.id else uuid.v4()

      store.created_at = util.dateFrom body.created_at
      tags = util.uniqArrFrom body.tags

      @pg.insert(store).into('finance_op').then (rows) =>
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
          req: data

      .catch (e) =>
        if e.code is 23505
          @sendThenDisc
            success: 'duplicate'
            data: body
            stored: stored
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
          cb tag if _.isFunction cb
        .catch (e) =>
          @error e

exports.getComponent = -> new Store
