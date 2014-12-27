
lodash = require 'lodash'

module.exports =
  viewport: {} # global viewport infomation
  props: {} # parent properties
  base: {} # parent rendering informantion

  bezier: (x) -> x # linear by default

  category: 'canvas' # or changed to component
  name: '<unknown>' # must specify
  id: null # only a unique one uses id instead of name
  isMounted: true

  # animation parameters
  delay: 200
  duration: 200
  stage: 'new' # [new delay entering tween stable leaving dead]
  stageTime: 0 # time entered current state, in number

  # extra states for generating animations
  getEnteringState: -> {}
  getLeavingState: -> {}

  # work with props like React
  getIntialState: {}

  # will be binded
  setState: (data) ->
    lodash.assign @state, data
    @markComponentDirty()

  # user rendering method like React
  render: ->

  # pass some render info to children
  getBase: ->

  # decide if click point is inside
  isPointIn: ->

  # functions called in entering stages
  onNewCalls:       []
  onDelayCalls:     []
  onEnteringCalls:  []
  onStableCalls:    []
  onLeavingCalls:   []
  onDestroyCalls:   []
