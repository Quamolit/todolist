
lodash = require 'lodash'

time = require '../util/time'

module.exports =
  viewport: {} # global viewport infomation
  base: {} # parent rendering informantion
  props: {} # parent properties
  state: {} # generate by getInitialState

  bezier: (x) -> x # linear by default

  category: 'component' # or changed to canvas
  name: '<unknown>' # must specify
  id: null # only a unique one uses id instead of name
  isMounted: yes
  isDirty: no

  # state machine of component lifecycle
  stage: 'delay' # [delay entering tween stable leaving]
  stageTime: 0 # time entered current state, in number

  # animation parameters
  delay: -> @props?.delay or 200
  duration: -> @props?.duration or 200

  # extra state for animations
  tweenState: {}
  getCurrentTween: -> # saved to this.tweenState
  getEnteringTween: -> null
  getLeavingTween: -> null

  # work with props like React
  getIntialState: {}

  # will be binded
  setState: (data) ->
    console.info "setState at #{@id}:", data
    lodash.assign @state, data
    @isDirty = yes
    @tweenState = @getCurrentTween()
    @stage = 'tween'
    @stageTime = time.now()

  # user rendering method like React
  render: ->

  # pass some render info to children
  getChildBase: ->

  # decide if click point is inside
  isPointIn: ->

  # functions called in entering stages
  onNewComponent: ->
  onDelayCalls:     []
  onEnteringCalls:  []
  onStableCalls:    []
  onLeavingCalls:   []
  onDestroyCalls:   []
