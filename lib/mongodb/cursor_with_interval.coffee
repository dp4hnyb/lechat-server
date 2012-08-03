mongo = require 'mongodb'
Cursor = mongo.Cursor

# Duck-punching mongodb driver Cursor.each.  This now takes an interval that waits 
# 'interval' milliseconds before it makes the next object request... 
module.exports = class CursorWithInterval extends Cursor
  
  constructor: (@cursor, @interval = 300) ->
    throw new Error('cursor instance is mandatory') if !@cursor?
    
  intervalEach: (interval, callback) ->
    throw new Error('callback is mandatory') if !callback?

    if @state() != Cursor.CLOSED
      # FIX: stack overflow (on deep callback) (cred: https://github.com/limp/node-mongodb-native/commit/27da7e4b2af02035847f262b29837a94bbbf6ce2)
      setTimeout (=>
          # fetch the next object until no more objects
          @nextObject (err, item) =>
            if err?
              return callback err, null
            if item?
              callback null, item
              @intervalEach interval, callback
            else
              # close the cursor if done
              @state Cursor.CLOSED
              callback err, null
            item = null
        ), interval

    else # if state == Cursor.CLOSED
      callback(new Error('Cursor is closed'), null)
      
  each: (callback) ->
    @intervalEach @interval, callback
      
  state: (state = null) ->
    @cursor.state = state if state != null
    @cursor.state
    
  nextObject: (err, item) ->
    @cursor.nextObject err, item
