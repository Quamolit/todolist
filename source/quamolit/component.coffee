
lodash = require 'lodash'

time = require '../util/time'
tool = require '../util/tool'

creator = require './creator'

module.exports =
  name: null # function must specify
  id: null # only a unique one uses id instead of name
  propTypes: {} # only anotation
  category: 'component' # or shape

  viewport: {} # global viewport infomation
  touchTime: 0 # everytime it is passed into creator
  manager: null # a bind of manager

  base: {} # parent rendering informantion
  props: {} # parent properties
  state: {} # generate by getInitialState
  layout: {} # defined in parent
  area: {} # position that merges base, layout, and lastArea
  cache:
    frame: {}
    frameTime: 0 # time entered current state, in number
    area: {}
    areaTime: 0

  # animation parameters
  getDuration: -> @props?.duration or 400
  getBezier: -> (x) -> x # linear by default

  # state machine of component lifecycle
  period: 'delay' # [delay entering changing stable leaving]
  jumping: no # true during base changing
  setPeriod: (name) ->
    @period = name
    @cache.frameTime = time.now()
    @cache.frame = lodash.cloneDeep @frame

  # extra state for animations
  frame: {}
  keyframe: {}

  # initial states
  getInitialState: -> {}
  getKeyframe: -> {} # saves to this.keyframe
  getEnteringKeyframe: -> {}
  getLeavingKeyframe: -> {}
  # saves to this.area
  getArea: ->
    tool.combine @base, @layout

  # will be binded to manager
  setState: null # function
  setKeyframe: null # function, defined by creator

  # user rendering method like React
  render: null # function
  internalRender: (c, manager) ->
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
  onEnterCalls: []
  onDestroyCalls: []
