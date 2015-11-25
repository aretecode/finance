noflo = require 'noflo'

noflo.loadFile 'test_graphs/App.fbp', {}, (network) ->
  net = network
