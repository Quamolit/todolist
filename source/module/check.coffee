
creator = require '../quamolit/creator'

rect = require './rect'

module.exports = creator.createComponent
  name: 'check'

  propTypes:
    checked: 'Boolean'
    onClick: 'Function'

  getIntialKeyframe: ->
    x: 0
    y: 0

  getEnteringKeyframe: ->
    x: -40
    y: 0

  getLeavingKeyframe: ->
    x: -40
    y: 0

  onClick: (event) ->
    @props.onClick event

  render: ->
    rect
      onClick: @onClick
      vector: {x: 20, y: 20}
      color: 'hsla(240,30%,80%,0.5)'
      if @props.checked
        rect
          vector: {x: 10, y: 10}
          color: 'hsl(240,80%,40%)'
