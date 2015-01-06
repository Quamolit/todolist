
actions = require '../actions'
creator = require '../quamolit/creator'

check = require '../module/check'
input = require '../module/input'

module.exports = creator.createComponent
  name: "line"

  getKeyframe: ->
    x: 0
    y: 0
    checked: @props.data.done
    text: @props.data.text

  getEnteringKeyframe: ->
    x: -40
    y: 0
    checked: no
    text: @props.data.text

  getLeavingKeyframe: ->
    x: -40
    y: 0
    checked: no
    text: @props.data.text

  onCheckClick: ->
    actions.emit 'update',
      id: @props.data.id, done: (not @props.data.done)

  render: -> [
    check
      x: (@frame.x - 40), y: @frame.y
      checked: @frame.checked
      onClick: @onCheckClick
    input
      x: (@frame.x + 40), y: @frame.y
      value: @frame.text
  ]
