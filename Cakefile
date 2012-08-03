

fs = require 'fs'

{print} = require 'util'
{spawn} = require 'child_process'

# Cakefile allows to automate compilation of CoffeeScript files to Javascript
build = (callback) ->
  coffee = spawn 'coffee', ['-c', '-o', 'build', '.']
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    print data.toString()
  coffee.on 'exit', (code) ->
    callback?() if code is 0

task 'build', 'Build build/ from ./', ->
  build()