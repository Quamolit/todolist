
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
    x: @tweenFrame.x
    y: @tweenFrame.y

  render: -> [
    input null
    button text: 'x'
  ]
