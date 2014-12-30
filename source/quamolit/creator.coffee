
lodash = require 'lodash'

tool = require '../util/tool'
component = require './component'
time = require '../util/time'

connectStore = (c) ->
  return c unless c.stores?
  listener = []
  for key, value of c.stores
    c.state[key] = value.get()
    f = -> c.setState key, value.get()
    value.register f
    c.onLeavingCalls.push -> value.unregister f
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
      c.touchTime = time.now()

      # use user written id if exists
      unless c.id?
        # generate id as: c.base.baseId + (props.key or base.index)
        index = props?.key or base.index.toString()
        c.id = "#{base.baseId}/#{options.name}.#{index}"

      vm = manager.vmDict[c.id]
      if vm?
        c = vm
        c.props = props
        c.base = base
      else
        manager.vmDict[c.id] = c
        if c.category is 'component'
          c.state = c.getIntialState?() or {}
          c.props = props
          c.base = base
          c.stageTime = time.now()
          c.tweenState = c.tweenFrame = c.getTweenState?() or {}
          c.stageTimeState = lodash.cloneDeep c.tweenState
          # console.log c.id, c.tweenState
          # will be binded
          c.setState = (data) ->
            console.info "setState at #{@id}:", data
            time.timeout 0, ->
              manager.updatedAt c.id, c.touchTime
            lodash.assign @state, data
            @isDirty = yes
            @tweenState = @getTweenState()
            @stage = 'tween'
            @stageTime = time.now()
            @stageTimeState = lodash.cloneDeep @tweenState
          lodash.assign c, options
          c.viewport = manager.getViewport()
          # store is connected to state directly
          c = connectStore c
          # bind method to a working component
          tool.bindMethods c
          c.onNewComponent()

      # flattern array, in case of this.base.children
      factory = c.render()
      factory = [factory] unless lodash.isArray factory
      factory = lodash.flatten factory
      # return a wrapped object
      filterdChildren = children.filter (x) -> x?
      base.children = expandChildren c, filterdChildren, manager

      c.children = if c.category is 'component'
      then expandChildren c, factory, manager
      else base.children


      return c
