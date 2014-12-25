
creator = require '../quamolit/creator'

module.exports = creator.create
  name: 'text'

  render: ->
    ->
      type: 'text'
      x: 0, y: 0
      size: 14
      data: 'demo'