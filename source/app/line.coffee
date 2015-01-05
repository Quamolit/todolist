
creator = require '../quamolit/creator'

check = require '../module/check'
input = require '../module/input'

module.exports = creator.createComponent
  name: 'line'

  getInitialKeyframe: ->
    x: 0
    y: 0

  getEnteringKeyframe: ->
    x: -40
    y: 0

  getLeavingKeyframe: ->
    x: -40
    y: 0

  render: -> [
    check checked: yes, x: (@frame.x - 40), y: @frame.y
    input value: 'text', x: (@frame.x + 40), y: @frame.y
  ]
