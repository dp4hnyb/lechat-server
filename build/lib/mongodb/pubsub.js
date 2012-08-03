// Generated by CoffeeScript 1.3.1
(function() {
  var CursorWithInterval, MongoDbPubSubAdapter, now;

  CursorWithInterval = require('./cursor_with_interval');

  module.exports = MongoDbPubSubAdapter = (function() {

    MongoDbPubSubAdapter.name = 'MongoDbPubSubAdapter';

    function MongoDbPubSubAdapter(collection) {
      this.collection = collection;
      if (!(this.collection != null)) {
        throw new Error('collection is mandatory');
      }
    }

    MongoDbPubSubAdapter.prototype.publish = function(channel, data) {
      console.log('publishing to ' + channel, data);
      return this.collection.insert({
        channel: channel,
        data: data,
        time: now()
      });
    };

    MongoDbPubSubAdapter.prototype.subscribe = function(channel, callback) {
      var conditions;
      console.log('subscribed to ' + channel);
      conditions = {
        channel: channel,
        time: {
          $gt: now()
        }
      };
      return this.collection.find(conditions, {
        'tailable': 1,
        'sort': [['$natural', 1]]
      }, function(err, cursor) {
        return (new CursorWithInterval(cursor, 300)).each(function(err, item) {
          return callback(err, item.data);
        });
      });
    };

    return MongoDbPubSubAdapter;

  })();

  now = function() {
    return (new Date()).getTime();
  };

}).call(this);
