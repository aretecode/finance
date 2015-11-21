noflo = require 'noflo'
express = require 'express'
http = require 'http'

noflo.loadFile 'test_graphs/App.fbp', {}, (network) ->
  net = network
