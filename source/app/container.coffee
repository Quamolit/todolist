
creator = require '../quamolit/creator'

todos = require '../store/todos'
line = require './line'
handler = require './handler'

module.exports = creator.create
  name: 'container'

  stores: {todos}

  getInitialState: ->
    text: ''

  getKeyframe: ->
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
      handler
        x: 0
        y: -140
      ,
        {}
    ]

    items = @state.todos.map (data, index) =>
      order = index
      line delay: (400 * order), x: 0, y: (80 * order - 80),
        data: data
        key: data.id
        index: index

    header.concat items
