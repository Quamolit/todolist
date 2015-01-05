
lodash = require 'lodash'

time = require '../util/time'

module.exports =
  name: null # must specify
  id: null # only a unique one uses id instead of name
  propTypes: {} # only anotation
  category: 'component' # or shape

  viewport: {} # global viewport infomation
  base: {} # parent rendering informantion
  props: {} # parent properties
  state: {} # generate by getInitialState
  touchTime: 0 # everytime it is passed into creator

  # animation parameters
  getDuration: -> @props?.getDuration?() or 400
  getBezier: -> (x) -> x # linear by default

  # state machine of component lifecycle
  period: 'delay' # [delay entering changing stable leaving]
  setPeriod: (name) ->
    @period = name
    @lastKeyframeTime = time.now()
    @lastKeyframe = lodash.cloneDeep @frame

  # extra state for animations
  frame: {}
  keyframe: {}
  lastKeyframe: {}
  lastKeyframeTime: 0 # time entered current state, in number

  # initial states
  getIntialState: -> {}
  getIntialKeyframe: -> {} # saves to this.keyframe
  getEnteringKeyframe: -> {}
  getLeavingKeyframe: -> {}

  # will be binded to manager
  setState: null # function
  setKeyframe: null # function, defined by creator

  # user rendering method like React
  render: null # function

  # pass some render info to children
  getChildBase: ->
    x: @base.x + (@props?.x or 0) + @frame.x
    y: @base.y + (@props?.y or 0) + @frame.y

  # functions called in entering periods
  onNewComponent: ->
  onEnterCalls: []
  onDestroyCalls: []
