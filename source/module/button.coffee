
creator = require '../quamolit/creator'

module.exports = creator.create
  name: 'button'
  category: 'canvas'

  render: ->
    (base, manager) =>
      type: 'button'
      text: 'demo'