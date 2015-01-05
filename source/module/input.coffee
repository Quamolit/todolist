
creator = require '../quamolit/creator'

rect = require './rect'
text = require './text'

module.exports = creator.createComponent
  name: 'input'
  propTypes:
    onClick: 'Function'

  getInitialKeyframe: ->
    x: 0
    y: 0

  getEnteringKeyframe: ->
    x: -40
    y: 0

  getLeavingKeyframe: ->
    x: -40
    y: 0

  onClick: (event) ->
    @props.onClick event

  render: ->
    rect
      onClick: @onClick
      vector: {x: 40, y: 20}
      color: 'hsl(120,70%,80%)'
      text
        text: 'create input'
        color: 'hsl(0,0%,50%)'
