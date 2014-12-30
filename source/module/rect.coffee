
creator = require '../quamolit/creator'

module.exports = creator.createShape
  name: 'rect'

  render: ->
    (base, manager) =>
      type: 'rect'
      base:
        x: base.x, y: base.y
        z: base.z.concat(0)
      from: @props.from or {x: 0, y: 0}
      vector: @props.vector or {x: 10, y: 10}
      kind: @props.kind or 'fill'
      fillStyle: @props.color or 'blue'
      strokeStyle: @props.color or 'blue'
