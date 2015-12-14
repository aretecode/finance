(function() {
  var noflo;

  require('coffee-script/register');

  noflo = require('noflo');

  noflo.isBrowser = function() {
    return false;
  };

  noflo.loadFile('graphs/main.json', process.cwd(), function(network) {
    var net;
    return net = network;
  });

}).call(this);
