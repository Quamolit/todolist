
creator = require '../quamolit/creator'

rect = require './rect'

module.exports = creator.createComponent
  name: 'check'

  delay: -> 0

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
    x: @base.x + (@props?.x or 0) + @tweenFrame.x
    y: @base.y + (@props?.y or 0) + @tweenFrame.y

  render: ->
    rect
      vector: {x: 20, y: 20}
      color: 'hsla(240,30%,80%,0.5)'
      if @props.checked
        rect
          vector: {x: 10, y: 10}
          color: 'hsl(240,80%,40%)'
