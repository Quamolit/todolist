
creator = require '../quamolit/creator'

module.exports = creator.create
  name: 'text'
  category: 'canvas'

  render: ->
    (base, manager) =>
      x: @base.x
      base:
      type: 'text'
      x: 0, y: 0
      size: 14
      data: 'demo'
