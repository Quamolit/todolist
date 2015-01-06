
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
    c.onDestroyCalls.push -> value.unregister f
  c

expandChildren = (target, children, manager) ->
  return if target.period is 'delay'
  children = [children] unless lodash.isArray children
  children.map (f, index) ->
    childBase =
      index: index
      baseId: target.id
      z: target.base.z.concat index
    lodash.assign childBase, target.getChildBase()
    f childBase, manager

makeIdFrom = (options, props, base) ->
  return options.id if options.id?
  # generate id as: c.base.baseId + (props.key or base.index)
  index = props?.key or base.index
  "#{base.baseId}/#{options.name}.#{index}"

fillList = (list) ->
  list.map (a) -> a or createShape
    getName: -> 'invisible'
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
      options.props = props
      id = makeIdFrom options, props, base
      if manager.vmDict[id]?
        c = manager.vmDict[id]
        # console.info 'touching', id
        c.touchTime = time.now()
        propsChanged = lodash.isEqual props, c.props
        c.props = props
        # base will change over time due to changing state
        c.base = base
        unless propsChanged
          console.log 'changed'
          c.setPeriod 'changing'
          c.keyframe = c.getKeyframe()
      else
        c = lodash.cloneDeep component
        manager.vmDict[id] = c
        # console.info 'creating', id
        lodash.assign c, options,
          id: id
          base: base
          state: c.getInitialState()
          props: props
          viewport: manager.getViewport()
          touchTime: time.now()
        # will be binded
        c.setState = (data) ->
          console.info "setState at #{@id}:", data
          lodash.assign @state, data
          @touchTime = time.now()
          @setPeriod 'changing'
          @keyframe = @getKeyframe()
          forceRender c, manager
          manager.differLeavingVms c.id, c.touchTime
        c.setKeyframe = (data) ->
          lodash.assign @frame, data
          forceRender c, manager
        # bind method to a working component
        tool.bindMethods c
        # store is connected to state directly
        c = connectStore c
        c.frame = c.keyframe = c.getEnteringKeyframe()
        c.setPeriod 'delay'
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

      if manager.vmDict[id]?
        c = manager.vmDict[id]
        # console.info 'touching', id
        c.touchTime = time.now()
      else
        c = lodash.cloneDeep shape
        # console.info 'creating', id
        manager.vmDict[id] = c
        lodash.assign c, options,
          id: id
          touchTime: time.now()
          viewport: manager.getViewport()
        # bind method to a working component
        tool.bindMethods c

      c.props = props
      c.base = base
      # flattern array, in case of this.base.children
      factory = c.render()
      c.canvas = factory base, manager
      # console.log c.id, 'shape children:', children
      expandChildren c, (fillList children), manager

      return c
