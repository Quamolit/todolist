
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
      type: 'rect'
      base: {x: base.x, y: base.y}
      from: @props.from or {x: 0, y: 0}
      vector: @props.vector or {x: 10, y: 10}
      kind: @props.kind or 'fill'
      fillStyle: @props.color or 'blue'
      strokeStyle: @props.color or 'blue'
