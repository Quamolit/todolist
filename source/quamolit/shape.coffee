
module.exports =
  category: 'shape'
  name: null    # string: user to define
  viewport: null # object: write by manager
  base: null # object: write by manager
  touchTime: 0 # number: write by manager

  getChildBase: ->
    @base

  render: null  # function: user to define

  # decide if click point is inside
  isPointIn: -> # function: user to define
