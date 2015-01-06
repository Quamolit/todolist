
module.exports =
  category: 'shape'
  getName: null # function, user to define
  viewport: null # object: write by manager
  base: null # object: write by manager
  touchTime: 0 # number: write by manager

  canvas: null # results

  getChildBase: ->
    x: @base.x + @canvas.from.x
    y: @base.y + @canvas.from.y

  render: null  # function: user to define

  # decide if click point is inside
  coveredPoint: -> false # function: user to define
  onClick: ->
