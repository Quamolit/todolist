
module.exports =
  category: 'shape'
  name: null    # string: user to define
  viewport: null # object: write by manager
  base: null # object: write by manager
  touchTime: 0 # number: write by manager

  getChildBase: ->
    x: @base.x
    y: @base.y
    z: @base.z.concat @base.index

  render: null  # function: user to define

  # decide if click point is inside
  coveredPoint: -> false # function: user to define
  onClick: ->
