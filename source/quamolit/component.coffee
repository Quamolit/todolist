
lodash = require 'lodash'

time = require '../util/time'

module.exports =
  viewport: {} # global viewport infomation
  props: {} # parent properties
  base: {} # parent rendering informantion

  bezier: (x) -> x # linear by default

  category: 'component' # or changed to canvas
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
    console.info "setState at #{@id}"
    lodash.assign @state, data,
      stage: 'tween'
      stageTime: time.now()

  # user rendering method like React
  render: ->

  # pass some render info to children
  getChildBase: ->

  # decide if click point is inside
  isPointIn: ->

  # functions called in entering stages
  onNewCalls:       []
  onDelayCalls:     []
  onEnteringCalls:  []
  onStableCalls:    []
  onLeavingCalls:   []
  onDestroyCalls:   []
