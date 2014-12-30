
lodash = require 'lodash'

component = require './component'
shape = require './shape'

tool = require '../util/tool'
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

makeIdFrom = (options, props, base) ->
  if options.id?
    return options.id
  # generate id as: c.base.baseId + (props.key or base.index)
  index = props?.key or base.index.toString()
  "#{base.baseId}/#{options.name}.#{index}"

fillList = (list) ->
  list.map (a) -> a or createShape
    name: 'invisible'
    render: -> -> type: 'invisible'

exports.createComponent = (options) ->
  # call this in side render
  (props, children...) ->
    # call this when parent is computed
    (base, manager) ->
      id = makeIdFrom options, props, base
      if manager.vmDict[id]?
        c = manager.vmDict[id]
        c.props = props
        c.base = base
      else
        c = lodash.cloneDeep component
        manager.vmDict[id] = c
        c.id = id
        lodash.assign c, options
        initialState = c.getIntialState?() or {}
        initialTween = c.getTweenState?() or {}
        lodash.assign c,
          base: base
          state: initialState
          props: props
          touchTime: time.now()
          stageTime: time.now()
          tweenState: initialTween
          tweenFrame: c.getEnteringTween()
          stageTimeState: c.getEnteringTween()
        # will be binded
        c.setState = (data) ->
          console.info "setState at #{@id}:", data
          time.timeout 0, ->
            manager.updatedAt c.id, c.touchTime
          lodash.assign @state, data
          @tweenState = @getTweenState()
          @stage = 'tween'
          @stageTime = time.now()
          @stageTimeState = lodash.cloneDeep @tweenState
        c.viewport = manager.getViewport()
        # store is connected to state directly
        c = connectStore c
        # bind method to a working component
        tool.bindMethods c
        c.onNewComponent()

      # base.children may be used in render()
      base.children = (fillList children)
      # flattern array, in case of this.base.children
      factory = c.render()
      factory = [factory] unless lodash.isArray factory
      factory = fillList (lodash.flatten factory)
      expandChildren c, factory, manager

      return c

exports.createShape = createShape = (options) ->
  # call this in side render
  (props, children...) ->
    # call this when parent is computed
    (base, manager) ->
      id = makeIdFrom options, props, base

      if manager.vmDict[id]?
        c = manager.vmDict[cid]
      else
        c = lodash.cloneDeep shape
        manager.vmDict[id] = c
        lodash.assign c, options
        c.touchTime = time.now()
        c.viewport = manager.getViewport()

      c.props = props
      c.base = base
      # return a wrapped object
      expandChildren c, (fillList children), manager
      # flattern array, in case of this.base.children
      factory = c.render()
      c.canvas = factory base, manager

      return c
