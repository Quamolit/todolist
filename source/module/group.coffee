
creator = require '../quamolit/creator'

module.exports = creator.create
  name: 'group'

  render: ->
    =>
      type: 'group'
      width: 240, height: 40
      children: @children
