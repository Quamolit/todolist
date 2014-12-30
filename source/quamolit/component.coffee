
time = require '../util/time'

module.exports =
  category: 'component' # or changed to canvas
  viewport: {} # global viewport infomation
  base: {} # parent rendering informantion
  props: {} # parent properties
  state: {} # generate by getInitialState
  propTypes: {} # only anotation

  bezier: -> (x) -> x # linear by default

  name: null # must specify
  id: null # only a unique one uses id instead of name
  touchTime: 0 # everytime it is passed into creator

  # state machine of component lifecycle
  stage: 'delay' # [delay entering tween stable leaving]
  stageTime: 0 # time entered current state, in number

  # animation parameters
  delay: -> @props?.delay or 300
  duration: -> @props?.duration or 300

  # extra state for animations
  tweenState: {}
  tweenFrame: {}
  getTweenState: -> # saves to this.tweenState
  getEnteringTween: -> null
  getLeavingTween: -> null

  # work with props like React
  getIntialState: {}

  # will be binded
  setState: (data) ->

  # user rendering method like React
  render: ->

  # pass some render info to children
  getChildBase: -> {}

  # functions called in entering stages
  onNewComponent: ->
  onDelayCalls:     []
  onEnteringCalls:  []
  onStableCalls:    []
  onLeavingCalls:   []
  onDestroyCalls:   []
