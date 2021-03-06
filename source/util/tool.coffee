
lodash = require 'lodash'

exports.evalArray = (list) ->
  list?.forEach (f) -> f()

exports.bindMethods = (a) ->
  # bind method to a working component
  lodash.each a, (method, name) ->
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

exports.computeTween = (a, b, ratio, bezierFn) ->
  c = {}
  keys = lodash.union (Object.keys a), (Object.keys b)
  keys.forEach (key) ->
    if (lodash.isNumber a[key]) and (lodash.isNumber b[key])
    then c[key] = Math.round (a[key] + (b[key] - a[key]) * (bezierFn ratio))
    else c[key] = b[key] or a[key]
  # console.log c.x, c.y
  c

exports.combine = (a, b) ->
  c = {}
  keys = lodash.union (Object.keys a), (Object.keys b)
  keys.forEach (key) ->
    if (lodash.isNumber a[key]) and (lodash.isNumber b[key])
    then c[key] = a[key] + b[key]
    else c[key] = b[key] or a[key]
  c
