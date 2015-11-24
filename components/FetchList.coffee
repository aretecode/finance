noflo = require 'noflo'
{_} = require 'underscore'
{Database} = require './Database.coffee'
{Factory} = require './../src/Boot.coffee'

tagArrayToString = (tagRow) ->
  tags = ''
  tags += (tag.tag + ',') for tag in tagRow
  return tags.substring(0, tags.length - 1) # trim the trailing comma

class FetchList extends Database
  description: 'Fetch the list of finance operations.'
  icon: 'list'

  childConstructor: ->
    @inPorts.in.on 'data', (data) =>
      @pg = require('./../src/Persistence/connection.coffee').getPg()

      {pg, table, outPorts} = {@pg, @table, @outPorts}
      @pg(table).select().then (row) -> return row
      .map (item) ->
        pg.select().from('tags').where('id', '=', item.id).then (tags) ->
          return Factory.hydrateFrom table, item, tagArrayToString(tags)

      .then (row) ->
        row = _.uniq row
        result = unless row.length is 1 then true else false
        outPorts.out.send
          successful: result
          data: row
        outPorts.out.disconnect()

exports.getComponent = -> new FetchList
