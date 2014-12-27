
lodash = require 'lodash'

exports.evalArray = (list) ->
  list.forEach (f) -> f()

exports.bindMethodsTo = (a, b) ->
  # bind method to a working component
  lodash.map a, (name, method) ->
    if lodash.isFunction method
      bindedMethod = method.bind b
      a[name] = bindedMethod
      bindedMethod.toString = -> method.toString()
