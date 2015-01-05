
creator = require '../quamolit/creator'

check = require '../module/check'
input = require '../module/input'

module.exports = creator.createComponent
  name: 'line'

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
    check checked: yes, x: (@tweenFrame.x - 40), y: @tweenFrame.y
    input value: 'text', x: (@tweenFrame.x + 40), y: @tweenFrame.y
  ]
