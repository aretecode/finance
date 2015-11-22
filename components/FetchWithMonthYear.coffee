noflo = require 'noflo'
{_} = require 'underscore'
{Factory} = require './../src/Boot.coffee'
{Database} = require './Database.coffee'
dateFromAny = require('./../src/Util/dateFromAny.coffee').dateFromAny
tagArrayToString = (tagRow) ->
  tags = ''
  tags += (tag.tag + ',') for tag in tagRow
  return tags.substring(0, tags.length - 1) # trim the trailing comma

class FetchWithMonthYear extends Database
  description: 'Find a finance operation with a specific Month & Year.'
  icon: 'area-chart'

  childConstructor: ->
    @pg = require('./../src/Persistence/connection.coffee').getPg()
    @inPorts.in.on 'data', (data) =>
      data.year = new Date().getFullYear() unless data.year?
      data.month = new Date().getMonth()+1 unless data.month?
      dataOut = {year: data.year; month: data.month}
      {outPorts, table, pg} = {@outPorts, @table, @pg}
      query = @pg(@table).select()
      .whereRaw("EXTRACT(MONTH FROM created_at) = " + data.month)
      .andWhereRaw("EXTRACT(YEAR FROM created_at) = " + data.year)
      .toString()

      @pg.raw(query).then (all) -> return all.rows
      .map (item) ->
        pg.select('tag').from('tags').where('id', '=', item.id).then (tagRow) ->
          return null if tagRow.length is 0
          return Factory.hydrateFrom table, item, tagArrayToString(tagRow)
      .then (all) ->
        all = _.flatten(all)

        tags = {}
        # getting all the tags from all the items
        for i in [0 .. all.length-1]
          continue unless all[i]?

          tag = all[i].tags
          if _.isArray tag
            for ii in [0 .. tag.length-1]
              tags[tag[ii].name] = 0
          else
            tags[tag.name] = 0
        # go through all tags
        # and get items that correspond
        for tag, value of tags
          for item in all
            # add the income or expense to the tag
            unless item is null
              tags[tag] += item.money.amount if item.hasTag(tag)

        outPorts.out.send
          successful: tags?
          data: tags
        outPorts.out.disconnect()

        # error
        # table + ' reporting not found for month: `' + date.getMonth() + '`
        # and year: `' + date.getFullYear() + '`'

exports.getComponent = -> new FetchWithMonthYear
