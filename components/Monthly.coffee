    year = new Date().getFullYear() if not year?
    month = new Date().getMonth()+1 if not month? # +1
    console.log month, year
    table = @repo.table
    @repo.findWithMonthYear month, year, (result) ->
      code = if (result.length is 0) then 404 else 302
      if code is 404
        message = table + ' reporting not found for month: `' + date.getMonth() + '` and year: `' + date.getFullYear() + '`'
      else 
        message = ''
      callback new Payload(code, result, message)










 ###
  @TODO: optimize query, combine extract?
  prev:  findWhereMonth
  @TODO: @param enforce type int
  ###
  findWithMonthYear: (month, year, cb) ->
    query = @pg(@table).select().whereRaw("EXTRACT(MONTH FROM created_at) = " + month).andWhereRaw("EXTRACT(YEAR FROM created_at) = " + year).toString()
    
    {pg, table} = {@pg, @table}
    @pg.raw(query).then (all) -> return all.rows
    .map (item) ->
      pg.select('tag').from('tags').where('id', '=', item.id).then (tagRow) ->
        return Factory.hydrateFrom table, item, tagArrayToString(tagRow)
    .then (all) ->
      all = _.flatten(all)

      ### @TODO: optimize, don't need to loop 2x ###
      tags = {}

      # getting all the tags from all the items
      for item in all
        continue unless item? # continue if item is undefined 

        itemTags = item.tags

        if _.isArray itemTag
          for itemTag in itemTags
            tags[itemTag.name] = 0
        else 
          tags[itemTag.name] = 0
      
      # go through all tags 
      # and get items that correspond
      for tag, value of tags
        for item in all
          # add the income or expense to the tag 
          tags[tag] += item.money.amount if item.hasTag(tag)
      
      cb tags 