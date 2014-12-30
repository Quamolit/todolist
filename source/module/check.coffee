
creator = require '../quamolit/creator'

rect = require './rect'

module.exports = creator.createComponent
  name: 'check'

  propTypes:
    checked: 'Boolean'

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
    rect
      vector: {x: 20, y: 20}
      color: 'hsl(240,30%,80%)'
      if @props.checked
        rect
          vector: {x: 10: y: 10}
          color: 'hsl(240,80%,40%)'