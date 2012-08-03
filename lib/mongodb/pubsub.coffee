CursorWithInterval = require './cursor_with_interval'

module.exports = class MongoDbPubSubAdapter
  
  # takes a MongoDb capped collection which is used as a message queue
  constructor: (@collection) ->
    throw new Error('collection is mandatory') if !@collection?
  
  # publishes a message on a given channel
  publish: (channel, data) ->
    console.log 'publishing to '+ channel, data
    @collection.insert({channel: channel, data: data, time: now()})
    
  # subscribes to a given channel. 'callback' will be called for every new item
  subscribe: (channel, callback) ->
    console.log 'subscribed to '+ channel
    conditions = 
      channel: channel
      time: {$gt: now()}
    # query the database and return a tailable cursor which calls 'callback' for every new item
    @collection.find conditions, {'tailable': 1, 'sort': [['$natural', 1]]}, (err, cursor) ->
      (new CursorWithInterval(cursor, 300)).each (err, item) ->
        callback(err, item.data)
      
      
# utility function which gives the current time
now = () -> (new Date()).getTime()