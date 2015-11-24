noflo = require 'noflo'
{_} = require 'underscore'
uuid = require 'uuid'
{Tag} = require './../src/Tag.coffee'
{Database} = require './Database.coffee'
dateFromAny = require('./../src/Util/dateFromAny.coffee').dateFromAny

class Store extends Database
  description: 'Store the data.'

  childConstructor: ->
    @inPorts.in.on 'data', (data) =>
      @pg = require('./../src/Persistence/connection.coffee').getPg()

      store =
        currency: data.currency
        amount: data.amount
        created_at: data.created_at
        description: data.description

      store.id = if data.id? then data.id else uuid.v4()
      store.created_at = dateFromAny(data.created_at)
      # @TODO: CHANGE DATEFROMANY
      unless store.created_at?
        store.created_at = new Date()

      # need to fix this... can't I just alias the method???
      # could this be inherited as well?
      # or even a noflo.helper?
      {outPorts, table, pg} = {@outPorts, @table, @pg}
      toError = (msg) ->
        if outPorts.error.isAttached()
          outPorts.error.send new Error msg
          outPorts.error.disconnect()
          return
        console.log msg #, store
        throw new Error msg

      @pg.insert(store).into(table)
      .then (rows) ->
        outPorts.out.send
          successful: rows.rowCount is 1
          data: store
        outPorts.out.disconnect()

      .catch (e) ->
        console.log e, 'AAAAAAAAAAAAAAAAAAAAAA'
        toError
          message: 'could not save!'
          error: e


      ############################################ TAGS ##########
      saveTag = (tag, cb) ->
        pg
        .insert(tag)
        .into('tags')
        .whereNotExists( ->
          @select(pg.raw(1)).from('tags')
          .where(id: tag.id)
          .andWhere(tag: tag.tag)
        )
        .then ((tag) ->
          if (_.isFunction cb)
            cb tag
        )
        # .catch ((e) -> console.log e)
        #  console.log "catch - could call toError here
        # if it works for whereNotExists.. @TODO"

      ### @TODO: optimize & combine ###
      tags = Tag.tagsFrom(data.tags)
      if _.isArray tags
        for tag in tags
          if tag is _.last tags # only want to call cb on the last one
            saveTag
              tag: tag.name
              id: store.id
          else
            saveTag
              tag: tag.name
              id: store.id
              , (result) -> # outPorts.out.send result
      else
        saveTag
          tag: tags.name
          id: store.id
        , (result) -> # outPorts.out.send result

exports.getComponent = -> new Store