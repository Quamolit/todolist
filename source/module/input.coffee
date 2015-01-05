
creator = require '../quamolit/creator'

rect = require './rect'
text = require './text'

module.exports = creator.createComponent
  name: 'input'
  propTypes:
    onClick: 'Function'

  delay: -> 0

  getEnteringTween: ->
    x: -40
    y: 0

  getLeavingTween: ->
    x: -40
    y: 0

  getTweenState: ->
    x: 0
    y: 0

  getChildBase: ->
    x: @base.x + (@props?.x or 0) + @tweenFrame.x
    y: @base.y + (@props?.y or 0) + @tweenFrame.y

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
