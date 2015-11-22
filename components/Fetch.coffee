noflo = require 'noflo'
{_} = require 'underscore'
{Database} = require './Database.coffee'
{Factory} = require './../src/Boot.coffee'

class Fetch extends Database
  description: 'Find a finance operation.'
  icon: 'search'

  childConstructor: ->
    @pg = require('./../src/Persistence/connection.coffee').getPg()

    @inPorts.in.on 'data', (data) =>
      hasId = id: data.id
      {outPorts, table, pg} = {@outPorts, @table, @pg}
      @pg.select().from(table).where(hasId).then (rows) ->
        pg.select('tag').from('tags').where(hasId).then (tags) ->
          tags = _.map tags, (tag) -> tag = tag.tag
          if rows.length is 0
            outPorts.out.send
              successful: false
              data: []
          else
            try
              result = Factory.hydrateAllFrom table, rows, tags
              outPorts.out.send
                successful: true
                data: result[0]
            catch e
              console.log 'why would this ever fail?'
              outPorts.out.send
                successful: false
                data: ':-('
          
          outPorts.out.disconnect()

exports.getComponent = -> new Fetch
