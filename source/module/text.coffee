
creator = require '../quamolit/creator'

module.exports = creator.create
  name: 'text'
  category: 'canvas'

  render: ->
    =>
      category: 'canvas'
      type: 'text'
      x: 0, y: 0
      size: 14
      data: 'demo'
      f: ->