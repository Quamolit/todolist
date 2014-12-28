
lodash = require 'lodash'

tool = require '../util/tool'
component = require './component'

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

expandChildren = (target, children, manager) ->
  children = [children] unless lodash.isArray children
  children.map (f, index) ->
    childBase =
      index: index
      baseId: target.id
      z: target.base.z.concat index
    lodash.assign childBase, target.getChildBase()
    f childBase, manager

exports.create = (options) ->
  # call this in side render
  (props, children...) ->
    # call this when parent is computed
    (base, manager) ->
      c = lodash.cloneDeep component
      vm = manager.vmDict[c.id]
      target = vm or c
      base.children = expandChildren target, children, manager

      lodash.assign c, options,
        viewport: manager.getViewport()
        props: props
        base: base

      # use user written id if exists
      unless c.id?
        # generate id as: c.base.baseId + (props.key or base.index)
        index = c.props?.key or c.base.index.toString()
        c.id = "#{c.base.baseId}/#{c.name}.#{index}"

      # if vm is present, redirect state
      if vm?
      then Object.defineProperty c, 'state',
        get: -> vm.state
        set: -> console.error 'can not assign to state'
      else
        c.state = c.getIntialState?() or {}
        # store is connected to state directly
        c = connectStore c

      # flattern array, in case of this.base.children
      factory = c.render()
      factory = [factory] unless lodash.isArray factory
      factory = lodash.flatten factory
      # return a wrapped object
      c.children = expandChildren c, factory, manager

      # bind method to a working component
      tool.bindMethodsTo c, target

      return c
