
creator = require '../quamolit/creator'

module.exports = creator.create
  name: 'rect'
  category: 'canvas'

  getEnteringTween: ->
    x: -40
    y: 0

  getLeavingTween: ->
    x: -40
    y: 0

  getTweenState: ->
    x: 0
    y: 0

  getChildBase: ->
    x: @tweenFrame.x
    y: @tweenFrame.y

  render: ->
    (base, manager) =>
      type: 'invisible'
