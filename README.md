# leChat web chat server

## Getting started

  * clone this repository
  
  * start your local MongoDb server. Create a capped collection called `messages` in the `testdatabase` database.
  
  * in the app directory, run `coffee app.coffee` to start the app. It will try to connect to the local MongoDb server and will look for the capped collection `messages`.
  
    **Note:** If you want to use other settings for MongoDb, you can set the `DB_HOST`, `DB_DATABASE` and `DB_COLLECTION` environment variables when starting the app:
    
        DB_URI=mongodb://username:password@host:port/database DB_COLLECTION=messages coffee app.coffee
  
  
## Deploying on Heroku
  
  * run `cake build` to build the app. This will compile the CoffeeScript source to Javascript which can be run with `node`.
  
  * run `foreman start` to start the app locally with `foreman`, make sure it can connect to your local or remote MongoDb server.
  
  * create the Heroku app `heroku create name-of-my-app`
  
  * set the `NODE_ENV` environment variable to `production`: `heroku config:set NODE_ENV=production`
  
  * **If you are using MongoLab**
  
    * add the [MongoLab Heroku add-on](https://addons.heroku.com/mongolab) to get a free cloud-hosted MongoDb server: `heroku addons:add mongolab:starter`
    
    * open the MongoLab admin panel `heroku addons:open mongolab` and create a _capped collection_ named `messages`. You can set the initial size at 10MB.
    
  * **If you are using your own MongoDb server**
    
    * set the Heroku environment variable DB_URI to the uri of your database (`heroku config:set DB_URI=mongodb://yourhost/yourdb`)
    
  * **Note:** if you want to call your collection something different from `messages`, set the `DB_COLLECTION` environment variable.
  
  * push the app to Heroku