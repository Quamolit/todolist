
creator = require '../quamolit/creator'

module.exports = creator.create
  name: 'rect'
  category: 'shape'
  period: 'stable'

  onClick: (event) ->
    @props.onClick? event

  coveredPoint: (x, y) ->
    centerX = @base.x + @canvas.from.x
    if Math.abs(x - centerX) > @canvas.vector.x then return no
    centerY = @base.y + @canvas.from.y
    if Math.abs(y - centerY) > @canvas.vector.y then return no
    return yes

  render: ->
    (base, manager) =>
      type: 'rect'
      base:
        x: (@layout.x or 0) + base.x
        y: (@layout.y or 0) + base.y
      from: @props.from or {x: 0, y: 0}
      vector: @props.vector or {x: 10, y: 10}
      kind: @props.kind or 'fill'
      fillStyle: @props.color or 'blue'
      strokeStyle: @props.color or 'blue'
