
routes = {}

exports.emit = (action) ->
  console.info 'action:', action
  handlers = routes[action.name]
  if handlers.length > 0
  then handlers.forEach (f) -> f action.data
  else console.warn 'router handler is not found', action

exports.on = (name, cb) ->
  # console.info 'bind action', name
  unless routes[name]? then routes[name] = []
  routes[name].push cb

window.actionEmit = exports.emit
