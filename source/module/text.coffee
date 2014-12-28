
creator = require '../quamolit/creator'

module.exports = creator.create
  name: 'text'
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
      type: 'text'
      base: {x: base.x, y: base.y}
      from: @props.from or {x: 0, y: 0}
      text: @props.text
      family: @props.family or 'Optima'
      size: @props.size or 14
      textAlign: @props.textAlign or 'center'
      textBaseline: @props.textBaseline or 'middle'
      fillStyle: @props.color or 'hsl(240,50%,50%)'
