
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
    f = ->
      newState = {}
      newState[key] = value.get()
      c.setState newState
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

forceRender = (c, manager) ->
  # flattern array, in case of this.base.children
  factory = c.render()
  factory = [factory] unless lodash.isArray factory
  factory = fillList (lodash.flatten factory)
  expandChildren c, factory, manager

exports.createComponent = createComponent = (options) ->
  # call this in side render
  (props, children...) ->
    # call this when parent is computed
    (base, manager) ->
      id = makeIdFrom options, props, base
      if manager.vmDict[id]?
        c = manager.vmDict[id]
        console.info 'touching', id
        # c.touchTime = time.now()
        c.props = props
        c.base = base
      else
        c = lodash.cloneDeep component
        manager.vmDict[id] = c
        # console.info 'creating', id
        c.touchTime = time.now()
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
          lodash.assign @state, data
          @touchTime = time.now()
          @tweenState = @getTweenState()
          @stage = 'tween'
          @stageTime = time.now()
          @stageTimeState = lodash.cloneDeep @tweenState
          forceRender c, manager
          manager.leavingDeprecated c.id, c.touchTime
        c.viewport = manager.getViewport()
        # store is connected to state directly
        c = connectStore c
        # bind method to a working component
        tool.bindMethods c
        c.onNewComponent()

      # base.children may be used in render()
      base.children = (fillList children)
      forceRender c, manager

      return c

exports.createShape = createShape = (options) ->
  # call this in side render
  (props, children...) ->
    # call this when parent is computed
    (base, manager) ->
      id = makeIdFrom options, props, base
      console.log 'shape id:', base.baseId

      if manager.vmDict[id]?
        c = manager.vmDict[id]
        # console.info 'touching', id
        c.touchTime = time.now()
      else
        c = lodash.cloneDeep shape
        # console.info 'creating', id
        manager.vmDict[id] = c
        c.id = id
        lodash.assign c, options
        c.touchTime = time.now()
        c.viewport = manager.getViewport()

      c.props = props
      c.base = base
      # flattern array, in case of this.base.children
      factory = c.render()
      c.canvas = factory base, manager
      # console.log c.id, 'shape children:', children
      expandChildren c, (fillList children), manager

      return c
