
creator = require '../quamolit/creator'

module.exports = creator.create
  name: 'check'
  category: 'canvas'

  render: ->
    (base, manager) =>
      type: 'check'
      text: 'demo'