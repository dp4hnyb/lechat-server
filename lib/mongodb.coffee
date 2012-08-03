mongo = require 'mongodb'
url = require 'url'
MongoDbPubSubAdapter = require './mongodb/pubsub'

# export function which allows to connect to the database and get
# a cursor function
#
exports.connect = (urlstring, collection_name, callback) ->
  mongo.Db.connect urlstring, (err, db) ->
    return callback err, null if err?
    theurl = url.parse urlstring
    console.log "Attempting connection to #{theurl.protocol}//#{theurl.hostname} (complete URL suppressed)"
    # select the capped collection 'messages'
    db.collection (coll = collection_name), (err, collection) ->
      # check that we have a capped collection
      collection.isCapped (err, capped) ->
        if err
          callback "Error when detecting capped collection. Aborting. Capped collections are necessary for tailed cursors."
        if !capped
          callback "'#{coll}' is not a capped collection. Aborting. Please use a capped collection for tailable cursors."
        # success!
        console.log "Successfully connected to #{theurl.protocol}//#{theurl.hostname}."
        callback null, new MongoDbPubSubAdapter(collection)
        
