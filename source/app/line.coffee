
creator = require '../quamolit/creator'

check = require '../module/check'
input = require '../module/input'

module.exports = creator.create
  name: 'line'

  getBase: ->
    {}

  render: -> [
    check done: no
    input value: 'text'
  ]
