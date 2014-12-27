
creator = require '../quamolit/creator'

module.exports = creator.create
  name: 'button'
  category: 'canvas'

  render: ->
    =>
      type: 'canvas'
      text: 'demo'