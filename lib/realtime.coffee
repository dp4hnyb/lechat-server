###
# Realtime server based on socket.io
###
db = require './mongodb'
 
module.exports = (server, db_config) ->
  
  # bind socket.io
  io = require('socket.io').listen(server)

  # connect to the database and get the collection
  db.connect db_config.uri, db_config.collection, (err, pubsub) ->
    if err?
      console.log err
      process.exit 1
    # socket.io
    console.log 'starting socket.io'
    
    io.sockets.on 'connection', (socket) ->
            
      # when a user wants to join a channel
      # data = 
      #   channel: id of the channel the user wants to join
      socket.on 'join', (data) ->
        pubsub.subscribe data.channel, (err, item) ->
          socket.emit item.event, item.data
        socket.emit 'joined', {channel: data.channel}
          
      # when user posts to a channel
      # post_data =
      #   channel: id of the channel the message is posted to
      #   message: actual data to be posted to the channel =
      #     [body: text of the message]
      #     [from: id of the sender (for reply)]
      #     
      socket.on 'post', (post_data) ->
        pubsub.publish data.channel, {event: 'receive', data: post_data.message}
          
      # when a user wants to invite another to a channel
      # data =
      #   from: id of the inviting user
      #   to: id of the invited user
      #   channel: id of the channel the user is invited to
      socket.on 'invite', (data) ->
        pubsub.publish data.to, {event: 'invite', data: {from: data.from, channel: data.channel} }
            
  
  # return
  @
  