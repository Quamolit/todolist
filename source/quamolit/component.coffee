
lodash = require 'lodash'

time = require '../util/time'
tool = require '../util/tool'

creator = require './creator'

module.exports = class Component
  constructor: (configs) ->
    @name = null # function must specify
    @category = 'component' # or shape
    # state machine of component lifecycle
    @period = 'delay' # [delay entering changing stable leaving]
    @jumping = no # true during base changing

    lodash.assign @, configs.options
    @id = configs.id
    @base = configs.base
    @props = configs.props
    @layout = configs.layout
    @manager = configs.manager

    @propTypes = {} # only anotation

    @viewport = @manager.getViewport()
    @touchTime = time.now()
    @onEnterCalls = []
    @onDestroyCalls = []

    @state = @getInitialState()
    @connectStore()
    @area = {} # position that merges base, layout, and lastArea
    @cache =
      frame: {}
      frameTime: 0 # time entered current state, in number
      area: {}
      areaTime: 0

    # extra state for animations
    @frame = @getEnteringKeyframe()
    @keyframe = @getEnteringKeyframe()

    @onNewComponent()

    @setPeriod @period

  # animation parameters
  getDuration: -> @props?.duration or 400
  getBezier: -> (x) -> x # linear by default
  setPeriod: (name) ->
    @period = name
    @cache.frameTime = time.now()
    @cache.frame = lodash.cloneDeep @frame

  # initial states
  getInitialState: -> {}
  getKeyframe: -> {} # saves to this.keyframe
  getEnteringKeyframe: -> {}
  getLeavingKeyframe: -> {}
  # saves to this.area
  getArea: ->
    tool.combine @base, @layout

  # will be binded to manager
  setState: (data) ->
    console.info "setState at #{@id}:", data
    lodash.assign @state, data
    @touchTime = time.now()
    @setPeriod 'changing'
    @keyframe = @getKeyframe()
    @internalRender()
    @manager.differLeavingVms @id, @touchTime

  setKeyframe: (data) ->
    lodash.assign @frame, data
    @internalRender()

  setArea: (data) ->
    lodash.assign @area, data
    @internalRender()

  checkBase: (base) ->
    return if (base.id is @base.id) and (base.index is @base.index)
    @cache.area = lodash.cloneDeep @area
    @cache.areaTime = time.now()
    @jumping = yes

  checkProps: (props) ->
    return if lodash.isEqual props, @props
    # console.log 'changing', props, @props
    @touchTime = time.now()
    @props = props
    @setPeriod 'changing'
    @keyframe = @getKeyframe()
    @internalRender()
    @manager.differLeavingVms @id, @touchTime

  # user rendering method like React
  render: null # function
  internalRender: (c, manager) ->
    unless @jumping
      @area = @getArea()
    factory = @render()
    switch @category
      when 'shape'
        @canvas = factory @base, @manager
        @expandChildren @base.children
      when 'component'
        factory = [factory] unless lodash.isArray factory
        # flattern array, in case of this.base.children
        factory = creator.fillList (lodash.flatten factory)
        @expandChildren factory

  expandChildren: (children) ->
    return if @period is 'delay'
    children = [children] unless lodash.isArray children
    children.map (f, index) =>
      childBase =
        index: index
        id: @id
        z: @base.z.concat index
      lodash.assign childBase, @getChildBase()
      f childBase, @manager

  # pass some render info to children
  getChildBase: ->
    x: @area.x + (@frame.x or 0)
    y: @area.y + (@frame.y or 0)

  # functions called in entering periods
  onNewComponent: ->

  # listens to updates from store
  connectStore: ->
    return unless @stores?
    for key, value of @stores
      @state[key] = value.get()
      f = =>
        newState = {}
        newState[key] = value.get()
        @setState newState
      value.register f
      @onDestroyCalls.push -> value.unregister f
