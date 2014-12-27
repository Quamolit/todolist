
creator = require '../quamolit/creator'

module.exports = creator.create
  name: 'input'
  category: 'canvas'

  render: ->
    =>
      type: 'input'
      value: 'demo'