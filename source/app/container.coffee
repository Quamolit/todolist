
creator = require '../quamolit/creator'

todos = require '../store/todos'
line = require './line'
input = require '../module/input'
button = require '../module/button'

module.exports = creator.create
  name: 'container'

  delay: -> 400

  stores: {todos}

  getIntialState: ->
    text: ''

  getEnteringTween: ->
    x: -40
    y: 0

  getLeavingTween: ->
    x: -40
    y: 0

  getCurrentTween: ->
    x: 0
    y: 0

  getChildBase: ->
    baseId: @id

  onNewComponent: ->

  render: ->
    list = [
      input null
      button text: 'x'
    ]

    items = @state.todos.map (data) =>
      line data: data

    list.concat items
