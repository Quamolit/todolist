
lodash = require 'lodash'

component = require './component'

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

makeIdFrom = (options, props, base) ->
  return options.id if options.id?
  # generate id as: c.base.id + (props.key or base.index)
  index = props?.key or base.index
  "#{base.id}/#{options.name}.#{index}"

exports.fillList = fillList = (list) ->
  list.map (a) -> a or create
    category: 'shape'
    getName: -> 'invisible'
    render: -> -> type: 'invisible'

exports.create = create = (options) ->
  # call this in side render
  (layout, props, children...) ->
    # call this when parent is computed
    (base, manager) ->
      options.props = props
      id = makeIdFrom options, props, base
      # base.children may be used in render()
      base.children = fillList children
      if manager.vmDict[id]?
        c = manager.vmDict[id]
        # console.info 'touching', id
        if (base.id isnt c.base.id) or (base.index isnt c.base.index)
          c.cache.area = lodash.cloneDeep c.area
          c.cache.areaTime = time.now()
          c.jumping = yes
        unless lodash.isEqual props, c.props
          console.log 'changing', props, c.props
          c.touchTime = time.now()
          c.setPeriod 'changing'
          c.keyframe = c.getKeyframe()
          c.internalRender()
          manager.differLeavingVms c.id, c.touchTime
        lodash.assign c,
          touchTime: time.now()
          props: props
          # base will change over time due to changing state
          base: base
          layout: layout
        c.area = c.getArea()
      else
        c = lodash.cloneDeep component
        manager.vmDict[id] = c
        c.manager = manager
        # console.info 'creating', id
        lodash.assign c, options,
          id: id
          base: base
          state: c.getInitialState()
          props: props
          layout: layout
          viewport: manager.getViewport()
          touchTime: time.now()
        # will be binded
        c.setState = (data) ->
          console.info "setState at #{@id}:", data
          lodash.assign @state, data
          @touchTime = time.now()
          @setPeriod 'changing'
          @keyframe = @getKeyframe()
          @internalRender()
          manager.differLeavingVms c.id, c.touchTime
        c.setKeyframe = (data) ->
          lodash.assign @frame, data
          @internalRender()
        c.setArea = (data) ->
          lodash.assign @area, data
          @internalRender()
        # bind method to a working component
        tool.bindMethods c
        # store is connected to state directly
        c = connectStore c
        c.frame = c.keyframe = c.getEnteringKeyframe()
        c.setPeriod c.period
        c.area = c.getArea()
        c.onNewComponent()

      c.internalRender()

      return c
