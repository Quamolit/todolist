
creator = require '../quamolit/creator'

todos = require '../store/todos'
line = require './line'
handler = require './handler'

module.exports = creator.createComponent
  name: 'container'

  stores: {todos}

  getIntialState: ->
    text: ''

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
    x: @base.x + @tweenFrame.x
    y: @base.y + @tweenFrame.y

  render: ->
    header = [
      handler x: 0, y: -120
    ]

    items = @state.todos.map (data, index) =>
      line
        data: data
        x: 0
        y: (-80 + (index) * 40)

    header.concat items
