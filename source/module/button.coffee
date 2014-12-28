
creator = require '../quamolit/creator'

module.exports = creator.create
  name: 'button'
  category: 'canvas'

  render: ->
    (base, manager) =>
      type: 'rect'
      text: 'demo'