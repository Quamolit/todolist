
actions = require '../actions'
creator = require '../quamolit/creator'

check = require '../module/check'
input = require '../module/input'

module.exports = creator.create
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
    check x: -40, y: 0,
      checked: @props.checked
      onClick: @onCheckClick
    input x: 40, y: 0,
      text: @frame.text
  ]
