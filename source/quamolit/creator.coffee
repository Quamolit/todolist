
lodash = require 'lodash'

component = require './component'

evaluate = (c, manager) ->
  factory = c.render()
  unless lodash.isArray factory
    factory = [factory]
  # return a wrapped object
  category: 'component'
  name: c.name
  id: c.id
  children: factory.map (f) -> f c.getBase(), manager

connectStore = (c) ->
  return unless c.stores?
  cache = {}
  listener = []
  for key, value of c.stores
    cache[key] = value.get()
    f = -> c.setState key, value.get()
    value.register f
    listener.push -> value.unregister f
  c.setState cache
  c.componentWillDestroy = ->
    listener.forEach (f) -> f()

exports.create = (options) ->
  # call this in side render
  (props, children...) ->
    # call this when parent is computed
    (base, manager) ->
      c = {}
      vm = manager.vmDict[c.id]
      target = vm or c

      lodash.assign c, component
      lodash.assign c, options
      lodash.assign c,
        viewport: manager.getViewport()
        props: props or {}
        base: base
        children: children.map (f) ->
          f (vm or c).getBase(), manager
        markComponentDirty: ->
          console.warn 'dirty'

      # bind method to a working component
      for name, method of c
        if typeof method is 'function'
          bindedMethod = method.bind target
          c[name] = bindedMethod
          bindedMethod.toString = -> method.toString()

      # if vm is present, redirect state
      if vm?
      then Object.defineProperty 'state',
        get: -> vm.state
        set: -> console.error 'can not assign to state'
      else
        c.state = c.getIntialState?() or {}
        connectStore c
      evaluate c, manager