(function() {

  try {require('.env.coffee');} catch (e) {}

  require('coffee-script/register');
  var noflo = require('noflo');

  noflo.isBrowser = function() {
    return false;
  };

  noflo.loadFile('graphs/main.json', process.cwd(), function(network) {
    return network;
  });

}).call(this);
