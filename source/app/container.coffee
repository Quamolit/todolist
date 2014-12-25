
creator = require '../quamolit/creator'

line = require './line'
group = require '../module/group'
text = require '../module/text'

module.exports = creator.create
  name: 'container'

  render: ->
    group null,
      line()
      text data: 'x'