
creator = require '../quamolit/creator'

module.exports = creator.create
  name: 'box'

  render: ->
    =>
      type: 'box'
      x: 0, y: 0
      width: 240, height: 40