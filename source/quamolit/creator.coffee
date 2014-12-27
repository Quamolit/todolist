
lodash = require 'lodash'

component = require './component'

evaluate = (c, manager) ->
  factory = c.render()
  unless lodash.isArray factory
    factory = [factory]
  # return a wrapped object
  lodash.assign c,
    category: 'component'
    children: factory.map (f, index) ->
      childBase = lodash.assign {index}, c.getBase()
      f c.id, childBase, manager

writeId = (c, baseId) ->
  # use user written id if exists
  if c.id then return c
  # generate id as: baseId + (props.key or base.index)
  index = c.props.key or c.base.index.toString()
  c.id = "#{baseId}/#{c.name}.#{index}"
  c

connectStore = (c) ->
  return c unless c.stores?
  cache = {}
  listener = []
  for key, value of c.stores
    cache[key] = value.get()
    f = -> c.setState key, value.get()
    value.register f
    c.onLeavingCalls.push -> value.unregister f
  c.setState cache
  c

exports.create = (options) ->
  # call this in side render
  (props, children...) ->
    # call this when parent is computed
    (baseId, base, manager) ->
      c = lodash.cloneDeep component
      vm = manager.vmDict[c.id]
      target = vm or c

      lodash.assign c, options
      lodash.assign c,
        viewport: manager.getViewport()
        props: props or {}
        base: base
        children: children.map (f, index) ->
          childBase = lodash.assign {index}, target.getBase()
          f target.id, childBase, manager

      # bind method to a working component
      lodash.map c, (name, method) ->
        if lodash.isFunction method
          bindedMethod = method.bind target
          c[name] = bindedMethod
          bindedMethod.toString = -> method.toString()

      # if vm is present, redirect state
      if vm?
      then Object.defineProperty c, 'state',
        get: -> vm.state
        set: -> console.error 'can not assign to state'
      else
        c.state = c.getIntialState?() or {}
        # store is connected to state directly
        c = connectStore c
      c = writeId c, baseId
      evaluate c, manager
