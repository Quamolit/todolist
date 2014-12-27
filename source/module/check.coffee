
creator = require '../quamolit/creator'

module.exports = creator.create
  name: 'check'
  category: 'canvas'

  render: ->
    =>
      type: 'canvas'
      text: 'demo'