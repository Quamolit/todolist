
creator = require '../quamolit/creator'

input = require '../module/input'
button = require '../module/button'

module.exports = creator.createComponent
  name: 'handler'

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

  render: -> [
    input x: (@tweenFrame.x - 80), y: @tweenFrame.y
    button text: 'x', x: (@tweenFrame.x + 90), y: @tweenFrame.y
  ]
