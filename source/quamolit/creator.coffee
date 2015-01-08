
lodash = require 'lodash'

Component = require './component'

tool = require '../util/tool'
time = require '../util/time'

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
        c.checkBase base
        c.checkProps props
        lodash.assign c,
          touchTime: time.now()
          # base will change over time due to changing state
          base: base
          layout: layout
      else
        c = new Component
        manager.vmDict[id] = c
        # console.info 'creating', id
        lodash.assign c, options,
          manager: manager
          id: id
          base: base
          state: c.getInitialState()
          props: props
          layout: layout
          viewport: manager.getViewport()
          touchTime: time.now()
        # bind method to a working component
        tool.bindMethods c
        # store is connected to state directly
        c.connectStore()
        c.frame = c.keyframe = c.getEnteringKeyframe()
        c.setPeriod c.period
        c.onNewComponent()

      c.area = c.getArea()
      c.internalRender()

      return c
