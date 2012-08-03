###
# GET home page.
###

exports.index = (req, res) ->
  res.render 'index', { title: 'leChat : awesome chat server' }
