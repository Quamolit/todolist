
creator = require '../quamolit/creator'

rect = require './rect'
text = require './text'

module.exports = creator.create
  name: 'button'

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
      vector: {x: 40, 20}
      color: 'hsl(30,40%,80%)'
      text
        text: 'create'
        color: 'hsl(0,0%,0%)'
