
module.exports =
  viewport: {} # global viewport infomation
  props: {} # parent properties
  base: {} # parent rendering informantion

  bezier: (x) -> x # linear by default

  name: '<unknown>' # must specify
  id: null # only a unique one uses id instead of name

  # extra states for generating animations
  getEnteringState: -> {}
  getLeavingState: -> {}

  # work with props like React
  getIntialState: {}

  # state is actually inside manager, need rewriting
  setState: ->

  # user rendering method like React
  render: ->
  renderView: (manager) ->
    factory = @render()
    factory @getBase(), manager

  # pass some render info to children
  getBase: ->

  # decide if click point is inside
  isPointIn: ->
