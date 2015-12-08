(function() {
  var noflo;

  require('coffee-script/register');

  noflo = require('noflo');

  noflo.isBrowser = function() {
    return false;
  };

  options =
  {
    debug: true,
    baseDir: process.cwd()
  }

  noflo.loadFile('graphs/main.json', options, function(network) {
    var net;
    return net = network;
  });

}).call(this);
