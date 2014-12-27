
creator = require '../quamolit/creator'

check = require '../module/check'
input = require '../module/input'

module.exports = creator.create
  name: 'line'

  getChildBase: ->
    baseId: @id

  render: -> [
    check done: no
    input value: 'text'
  ]
