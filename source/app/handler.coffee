
creator = require '../quamolit/creator'

input = require '../module/input'
button = require '../module/button'

module.exports = creator.createComponent
  name: 'handler'

  delay: -> 0
  duration: -> 1000

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

  render: -> [
    input x: (@tweenFrame.x - 80), y: @tweenFrame.y
    button text: 'x', x: (@tweenFrame.x + 90), y: @tweenFrame.y
  ]
