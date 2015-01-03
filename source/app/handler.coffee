
creator = require '../quamolit/creator'

input = require '../module/input'
button = require '../module/button'

module.exports = creator.createComponent
  name: 'handler'

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

  render: -> [
    input x: -80, y: 0
    button text: 'x', x: 90, y: 0
  ]
