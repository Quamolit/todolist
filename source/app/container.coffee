
creator = require '../quamolit/creator'

todos = require '../store/todos'
line = require './line'
input = require '../module/input'
button = require '../module/button'

module.exports = creator.create
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
    header = line null,
      input null
      button text: 'x'

    items = @state.todos.map (data) =>
      line data: data

    [header].concat items
