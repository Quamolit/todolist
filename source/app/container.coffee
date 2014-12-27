
creator = require '../quamolit/creator'

todos = require '../store/todos'
line = require './line'
input = require '../module/input'
button = require '../module/button'

module.exports = creator.create
  name: 'container'

  stores: {todos}

  componentDidMount: ->
    @connect todos: todos

  getIntialState: ->
    text: ''

  getBase: ->
    {}

  render: ->
    list = [
      input null
      button text: 'x'
    ]

    items = @state.todos.map (data) =>
      line data: data

    list.concat items
