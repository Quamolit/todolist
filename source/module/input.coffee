
creator = require '../quamolit/creator'

module.exports = creator.create
  name: 'input'
  category: 'canvas'

  render: ->
    (base, manager) =>
      type: 'input'
      value: 'demo'
