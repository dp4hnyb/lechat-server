// Generated by CoffeeScript 1.3.1
(function() {
  var app, express, http, path, realtime, routes, server;

  express = require('express');

  routes = require('./routes');

  http = require('http');

  path = require('path');

  app = express();

  app.configure(function() {
    app.set('port', process.env.PORT || 3000);
    app.set('views', __dirname + '/views');
    app.set('view engine', 'jade');
    app.use(express.favicon());
    app.use(express.logger('dev'));
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(app.router);
    app.use(require('stylus').middleware(__dirname + '/public'));
    app.use(express["static"](path.join(__dirname, 'public')));
    app.set('db uri', process.env.DB_URI || process.env.MONGOLAB_URI || 'mongodb://localhost/testdatabase');
    return app.set('db collection', process.env.DB_COLLECTION || 'messages');
  });

  app.configure('development', function() {
    return app.use(express.errorHandler());
  });

  app.configure('production', function() {
    return app.set('io configure', function(io) {
      io.set('transports', ['xhr-polling']);
      return io.set('polling duration', 10);
    });
  });

  app.get('/', routes.index);

  server = http.createServer(app);

  realtime = require('./lib/realtime')(server, app);

  server.listen(app.get('port'), function() {
    return console.log("Express server listening on port " + (app.get('port')));
  });

}).call(this);
