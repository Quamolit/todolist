
creator = require '../quamolit/creator'

rect = require './rect'
text = require './text'

actions = require '../actions'

module.exports = creator.create
  name: 'input'

  propTypes:
    onChange: 'Function'

  getKeyframe: ->
    x: 0
    y: 0
    vx: 40
    vy: 20
    text: @props.text or ''

  getEnteringKeyframe: ->
    x: -40
    y: 0
    vx: 0
    vy: 0
    text: ''

  getLeavingKeyframe: ->
    x: -40
    y: 0
    vx: 0
    vy: 0
    text: ''

  onClick: (event) ->
    @manager.createExternalElement @id, 'input', @props.text

  onChange: (event) ->
    @props.onChange event

  render: ->
    rect
      vector:
        x: @frame.vx
        y: @frame.vy
    ,
      onClick: @onClick
      color: 'hsl(120,70%,80%)'
      text {},
        text: (@props.text or '')
        color: 'hsl(0,0%,50%)'
