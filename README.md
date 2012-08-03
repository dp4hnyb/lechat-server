# leChat web chat server

## Getting started

  * clone this repository
  
  * start your local MongoDb server. Create a capped collection called `messages` in the `testdatabase` database.
  
  * in the app directory, run `coffee app.coffee` to start the app. It will try to connect to the local MongoDb server and will look for the capped collection `messages`.
  
    **Note:** If you want to use other settings for MongoDb, you can set the `DB_HOST`, `DB_DATABASE` and `DB_COLLECTION` environment variables when starting the app:
    
        DB_HOST=localhost DB_DATABASE=testdatabase DB_COLLECTION=messages coffee app.coffee
  
  
## Deploying on Heroku
  
  * run `cake build` to build the app. This will compile the CoffeeScript source to Javascript which can be run with `node`.
  
  * run `foreman start` to start the app locally with `foreman`, make sure it can connect to your local or remote MongoDb server.
  
  * push the app to Heroku