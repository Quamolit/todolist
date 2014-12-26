
creator = require '../quamolit/creator'

module.exports = creator.create
  name: 'button'

  render: ->
    =>
      type: 'canvas'
      text: 'demo'