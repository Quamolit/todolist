
creator = require '../quamolit/creator'

todos = require '../store/todos'
line = require './line'
handler = require './handler'

module.exports = creator.createComponent
  name: 'container'

  stores: {todos}

  delay: -> 0

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
    x: @base.x + (@props?.x or 0) + @tweenFrame.x
    y: @base.y + (@props?.y or 0) + @tweenFrame.y

  render: ->
    header = [
      handler x: @tweenFrame.x, y: (@tweenFrame.y - 160)
    ]

    items = @state.todos.map (data, index) =>
      line
        data: data
        x: @tweenFrame.x
        y: (@tweenFrame.y - 80 + (index) * 80)

    header.concat items
