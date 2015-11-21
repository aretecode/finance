noflo = require 'noflo'
fs = require 'fs'

module.exports = (loader, done) ->
  dirs = [
    "components"
    "src"
  ]
  for dir in dirs
    for file in fs.readdirSync __dirname + "/#{dir}"
      m = file.match /^(\w+)\.coffee$/
      continue unless m
      path = __dirname + "/#{dir}/#{file}"
      loader.registerComponent 'finance', m[1], path
  done()
