
creator = require '../quamolit/creator'

module.exports = creator.create
  name: 'line'

  render: ->
    ->
      category: 'canvas'
      type: 'line'
      x: 0, y: 0