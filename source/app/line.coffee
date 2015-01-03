
creator = require '../quamolit/creator'

check = require '../module/check'
input = require '../module/input'

module.exports = creator.createComponent
  name: 'line'

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
    x: @tweenFrame.x
    y: @tweenFrame.y

  render: -> [
    check done: no
    input value: 'text'
  ]
