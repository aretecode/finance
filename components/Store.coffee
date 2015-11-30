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
      @pg = require('./../src/Persistence/connection.coffee').getPg()

      store =
        currency: data.currency
        amount: data.amount
        description: data.description
        type: @table
      store.id = if data.id? then data.id else uuid.v4()

      console.log data.created_at
      # console.log moment(data.created_at).format()
      console.log util.dateFrom data.created_at

      store.created_at = util.dateFrom data.created_at
      tags = util.uniqArrFrom data.tags

      @pg.insert(store).into('finance_op')
      .then (rows) ->
        for tag in tags
          saveTag
            tag: tag
            id: store.id

        stored = _.clone store
        stored.tags = tags

        _this.outPorts.out.send
          success: rows.rowCount is 1
          data: store
        _this.outPorts.out.disconnect()
      .catch (e) ->
        _this.error
          message: 'could not save!'
          error: e
          component: 'Store'

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
        .catch ((e) -> _this.error(e))

exports.getComponent = -> new Store
