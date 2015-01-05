
creator = require '../quamolit/creator'

input = require '../module/input'
button = require '../module/button'

module.exports = creator.createComponent
  name: 'handler'

  getIntialKeyframe: ->
    x: 0
    y: 0

  getEnteringKeyframe: ->
    x: -40
    y: 0

  getLeavingKeyframe: ->
    x: -40
    y: 0

  render: -> [
    input x: (@frame.x - 80), y: @frame.y
    button text: 'x', x: (@frame.x + 90), y: @frame.y
  ]
