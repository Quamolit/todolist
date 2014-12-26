
routes = {}

exports.emit = (state, action) ->
  if @display? then @display state, action
  handler = routes[action.name]
  if handler?
  then handler state, action.data
  else console.warn 'router handler is not found', action

exports.on = (name, cb) ->
  if routes[name]?
    console.warn 'rewriting router handler'
  routes[name] = cb
