
creator = require '../quamolit/creator'

rect = require './rect'
text = require './text'

module.exports = creator.create
  name: 'button'

  propTypes:
    onClick: 'Function'

  getKeyframe: ->
    x: 0
    y: 0
    vx: 50
    vy: 20

  getEnteringKeyframe: ->
    x: -40
    y: 0
    vx: 0
    vy: 0

  getLeavingKeyframe: ->
    x: -40
    y: 0
    vx: 0
    vy: 0

  onClick: (event) ->
    @props.onClick event

  render: ->
    rect {},
      onClick: @onClick
      vector: {x: @frame.vx, y: @frame.vy}
      color: 'hsl(30,40%,80%)'
      text {},
        text: 'create button'
        color: 'hsl(0,0%,0%)'
