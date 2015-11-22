{_} = require 'underscore'

# could be a collection here and reference that id
# it could be enforced that lowercase is passed in 
# we could enforce a character range 
class Tag 
  # id 
  name: ""

  # Invariant: name is always lowercase
  constructor: (aName) ->
    @name = aName.toLowerCase()

  toString: -> @name 
  
  # if it has a comma, explode it, make them into an array of Tags
  @tagsFrom: (tags) ->
    if _.isArray tags 
      return Tag.uniqueAndMakeList tags
    if tags.includes ','
      stringTags = tags.split ','
      return Tag.uniqueAndMakeList stringTags
    if _.isString tags
      return new Tag(tags)
    else 
      throw new Error("#{tags} was not an array, or a string!")
  @uniqueAndMakeList: (tags) ->
    tags = _.uniq tags
    tagArray = []
    for tag in tags
      unless tag instanceof Tag 
        tag = new Tag(tag)
      tagArray.push tag
    tagArray

module.exports.Tag = Tag