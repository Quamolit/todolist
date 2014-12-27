
creator = require '../quamolit/creator'

module.exports = creator.create
  name: 'check'

  render: ->
    =>
      type: 'canvas'
      text: 'demo'