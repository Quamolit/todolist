
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
