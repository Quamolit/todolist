
routes = {}

exports.emit = (name, data) ->
  console.info 'action:', name, data
  handlers = routes[name]
  if handlers.length > 0
  then handlers.forEach (f) -> f data
  else console.warn 'router handler is not found', name

exports.on = (name, cb) ->
  # console.info 'bind action', name
  unless routes[name]? then routes[name] = []
  routes[name].push cb

window.actionEmit = exports.emit
