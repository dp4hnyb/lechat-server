// Generated by CoffeeScript 1.3.1

/*
# Realtime server based on socket.io
*/


(function() {
  var db;

  db = require('./mongodb');

  module.exports = function(server, app) {
    var io;
    io = require('socket.io').listen(server);
    io.configure('production', function() {
      io.set('origins', 'http://lechat-client-brunch.herokuapp.com:*');
      io.enable('browser client minification');
      io.enable('browser client etag');
      io.enable('browser client gzip');
      io.set('log level', 1);
      io.set('transports', ['xhr-polling']);
      return io.set('polling duration', 10);
    });
    db.connect(app.get('db uri'), app.get('db collection'), function(err, pubsub) {
      if (err != null) {
        console.log(err);
        process.exit(1);
      }
      console.log('starting socket.io');
      return io.sockets.on('connection', function(socket) {
        socket.on('join', function(data) {
          pubsub.subscribe(data.channel, function(err, item) {
            return socket.emit(item.event, item.data);
          });
          return socket.emit('joined', {
            channel: data.channel
          });
        });
        socket.on('post', function(post_data) {
          return pubsub.publish(post_data.channel, {
            event: 'receive',
            data: post_data.message
          });
        });
        return socket.on('invite', function(data) {
          return pubsub.publish(data.to, {
            event: 'invite',
            data: {
              from: data.from,
              channel: data.channel
            }
          });
        });
      });
    });
    return this;
  };

}).call(this);
