
json = require 'cirru-json'
lodash = require 'lodash'

treeUtil = require '../util/tree'
time = require '../util/time'
tool = require '../util/tool'
painter = require './painter'

module.exports = class Manager
  constructor: (options) ->
    @node = options.node
    @vmDict = {}
    @vmList = []

  getViewport: ->
    # get node geomerty
    baseId: ''
    index: 0
    z: [0]
    x: Math.round (@node.width / 2)
    y: Math.round (@node.height / 2)

  updateVmList: ->
    list = lodash.map @vmDict, (knot, id) -> knot
    @vmList = list
    .filter (knot) ->
      knot.category is 'shape'
    .sort (a, b) ->
      tool.compareZ a.base.z, b.base.z

  updatedAt: (changeId) ->
    lodash.each @vmDict, (child, id) =>
      if child.stage isnt 'leaving'
        if id.indexOf(changeId) is 0
          child.stage = 'leaving'
          child.stageTime = time.now()
          child.stageTimeState = lodash.cloneDeep child.tweenState
    @updateVmList()

  render: (creator) ->
    # knots are binded to @vmDict directly
    creator @getViewport(), @
    @updateVmList()

    @paintVms()

  maintainStages: ->
    isStable = lodash.every @vmDict, stage: 'stable'
    unless isStable
      requestAnimationFrame => @maintainStages()

    now = time.now()
    lodash.each @vmDict, (child, id) =>
      if child.category isnt 'component'
        return # canvas has no lifecycle
      switch child.stage
        # remove out date elements
        when 'leaving'  then @handleLeavingNodes  child, now
        # setup new elements
        when 'delay'    then @handleDelayNodes    child, now
        # animate tween state components
        when 'entering' then @handleEnteringNodes child, now
        when 'tween'    then @handleTweenNodes    child, now

  handleLeavingNodes: (c, now) ->
    tool.evalArray c.onLeavingCalls
    if now - c.stageTime > c.duration()
      delete @vmDict[c.id]
    else
      @updateVmTweenFrame c, now

  handleDelayNodes: (c, now) ->
    if now - c.stageTime > c.delay()
      c.stageTime = now
      c.stageTimeState = lodash.cloneDeep c.tweenState
      switch
        when c.duration() > 0
          c.stage = 'entering'
          tool.evalArray c.onEnteringCalls
        else
          c.stage = 'stable'
          tool.evalArray c.onEnteringCalls
          tool.evalArray c.onStableCalls

  handleEnteringNodes: (c, now) ->
    if now - c.stageTime > c.duration()
      c.stageTime = now
      c.stageTimeState = lodash.cloneDeep c.tweenState
      c.stage = 'stable'
      tool.evalArray c.onEnteringCalls
      tool.evalArray c.onStableCalls
    else
      @updateVmTweenFrame c, now

  handleTweenNodes: (c, now) ->
    if now - c.stageTime > c.duration()
      c.stage = 'stable'
      c.stageTime = now
      c.stageTimeState = lodash.cloneDeep c.tweenState
    else
      @updateVmTweenFrame c, now

  updateVmTweenFrame: (c, now) ->
    ratio = (now - c.stageTime) / c.duration()
    c.tweenFrame = tool.computeTween c.stageTimeState,
      c.tweenState, ratio, c.bezier()
    # console.log c.id, c.tweenFrame

  paintVms: ->
    geomerties = @vmList
    .map (shape) -> shape.canvas
    painter.paint geomerties, @node
