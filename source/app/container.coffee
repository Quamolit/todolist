
creator = require '../quamolit/creator'

todos = require '../store/todos'
line = require './line'
handler = require './handler'

module.exports = creator.createComponent
  name: 'container'

  stores: {todos}

  getIntialState: ->
    text: ''

  getIntialKeyframe: ->
    x: 0
    y: 0

  getEnteringKeyframe: ->
    x: -40
    y: 0

  getLeavingKeyframe: ->
    x: -40
    y: 0

  render: ->
    header = [
      handler x: @frame.x, y: (@frame.y - 160)
    ]

    items = @state.todos.map (data, index) =>
      line
        data: data
        x: @frame.x
        y: (@frame.y - 80 + (index) * 80)
        delay: (400 * index + 400)

    header.concat items
