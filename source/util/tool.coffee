
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

exports.compareZ = compareZ = (a, b) ->
  a0 = a[0] or -1
  b0 = b[0] or -1
  if a.length is 0 and b.length is 0
    return 0
  switch
    when a0 < b0 then -1
    when a0 > b0 then 1
    else compareZ a[1..], b[1..]
