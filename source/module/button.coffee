
creator = require '../quamolit/creator'

rect = require './rect'
text = require './text'

module.exports = creator.createComponent
  name: 'button'

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
    x: @base.x + @props.x + @tweenFrame.x
    y: @base.y + @props.y + @tweenFrame.y

  render: ->
    rect
      vector: {x: 40, y: 20}
      color: 'hsl(30,40%,80%)'
      text
        text: 'create button'
        color: 'hsl(0,0%,0%)'
