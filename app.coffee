express = require('express')
routes = require('./routes')
http = require('http')
path = require('path')

# initialize express app
app = express()
# configure express app
app.configure ->
  app.set('port', process.env.PORT || 3000)
  app.set('views', __dirname + '/views')
  app.set('view engine', 'jade')
  app.use(express.favicon())
  app.use(express.logger('dev'))
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(app.router)
  app.use(require('stylus').middleware(__dirname + '/public'))
  app.use(express.static(path.join(__dirname, 'public')))
  # MongoDb settings
  app.set('db uri', process.env.DB_URI || process.env.MONGOLAB_URI || 'mongodb://localhost/testdatabase')
  app.set('db collection', process.env.DB_COLLECTION || 'messages')

# developement-specific configuration
app.configure 'development', ->
  app.use express.errorHandler()
  
# produciton-specific configuration
app.configure 'production', ->



# routing
app.get '/', routes.index

# create server
server = http.createServer(app)

# add realtime server
realtime = require('./lib/realtime')(server, {
  uri: app.get 'db uri'
  collection: app.get 'db collection'
})

# start listening on port
server.listen app.get('port'), ->
  console.log "Express server listening on port #{app.get('port')}"
  
