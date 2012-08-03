

fs = require 'fs'

{print} = require 'util'
{spawn} = require 'child_process'

handle_process = (process, callback) ->
  process.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  process.stdout.on 'data', (data) ->
    print data.toString()
  process.on 'exit', (code) ->
    callback?() if code is 0

# Cakefile allows to automate compilation of CoffeeScript files to Javascript
build = (callback) ->
  # run coffee to build the .coffee files
  coffee = spawn 'coffee', ['-c', '-o', 'build', '.']
  handle_process coffee, ->
    # run cp to copy the view folder
    copy = spawn 'cp', ['-r', 'views', 'build/views']
    handle_process copy, callback

task 'build', 'Build build/ from ./', ->
  build()
  