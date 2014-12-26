
creator = require '../quamolit/creator'

line = require './line'
text = require '../module/text'

module.exports = creator.create
  name: 'container'

  render: -> [
    line()
    text data: 'x'
  ]