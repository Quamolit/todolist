
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
    x: @tweenFrame.x
    y: @tweenFrame.y

  render: ->
    header = [
      handler null
    ]

    items = @state.todos.map (data) =>
      line data: data

    header.concat items
