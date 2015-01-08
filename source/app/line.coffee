
actions = require '../actions'
creator = require '../quamolit/creator'

check = require '../module/check'
input = require '../module/input'

module.exports = creator.create
  name: "line"

  getKeyframe: ->
    x: 0
    y: 0

  getEnteringKeyframe: ->
    x: -40
    y: 0

  getLeavingKeyframe: ->
    x: -40
    y: 0

  onCheckClick: ->
    actions.emit 'update',
      id: @props.data.id, done: (not @props.data.done)

  render: -> [
    check x: -40, y: 0,
      checked: @props.data.done
      onClick: @onCheckClick
    input x: 40, y: 0,
      text: @props.data.text
  ]
