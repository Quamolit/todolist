
lodash = require 'lodash'

exports.evalArray = (list) ->
  list?.forEach (f) -> f()

exports.bindMethods = (a) ->
  # bind method to a working component
  lodash.map a, (name, method) ->
    if lodash.isFunction method
      bindedMethod = method.bind a
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

exports.computeTween = (a, b, ratio, bezier) ->
  c = {}
  keys = lodash.union (Object.keys a), (Object.keys b)
  keys.forEach (key) ->
    if (lodash.isNumber a[key]) and (lodash.isNumber b[key])
    then c[key] = a[key] + (b[key] - a[key]) * (bezier ratio)
    else c[key] = b[key]
  # console.log c.x, c.y
  c
