
creator = require '../quamolit/creator'

rect = require './rect'
text = require './text'

module.exports = creator.createComponent
  name: 'input'

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
    x: @base.x + @tweenFrame.x
    y: @base.y + @tweenFrame.y

  render: ->
    rect
      vector: {x: 40, y: 20}
      color: 'hsl(0,100%,100%)'
      text
        text: 'create input'
        color: 'hsl(0,0%,50%)'
