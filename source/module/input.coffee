
creator = require '../quamolit/creator'

module.exports = creator.create
  name: 'input'

  render: ->
    =>
      type: 'input'
      value: 'demo'