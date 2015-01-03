
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

  leavingDeprecated: (changeId, changeTime) ->
    lodash.each @vmDict, (child, id) =>
      return if id.indexOf("#{changeId}/") < 0
      return if child.stage is 'leaving'
      return if child.touchTime >= changeTime
      console.info 'leaving', id
      child.stage = 'leaving'
      tool.evalArray child.onLeavingCalls
      child.stageTime = time.now()
      child.stageTimeState = lodash.cloneDeep child.tweenState
    @maintainStages()
    @updateVmList()

  render: (creator) ->
    # knots are binded to @vmDict directly
    creator @getViewport(), @
    @maintainStages()
    @updateVmList()

    @paintVms()

  maintainStages: ->
    lodash.each @vmDict, (child, id) =>
      if child.category is 'component'
        if child.stage isnt 'stable'
          requestAnimationFrame => @maintainStages()

    now = time.now()
    lodash.each @vmDict, (child, id) =>
      return unless child?
      # canvas has no lifecycle
      return unless child.category is 'component'
      switch child.stage
        # remove out date elements
        when 'leaving'  then @handleLeavingNodes  child, now
        # setup new elements
        when 'delay'    then @handleDelayNodes    child, now
        # animate tween state components
        when 'entering' then @handleEnteringNodes child, now
        when 'tween'    then @handleTweenNodes    child, now
    @paintVms()

  handleLeavingNodes: (c, now) ->
    if now - c.stageTime > c.duration()
      console.info 'deleting', c.id
      delete @vmDict[c.id]
      lodash.each @vmDict, (child, id) =>
        # remove children
        if child? and (id.indexOf "#{c.id}/") is 0
          console.info 'deleting children', id
          delete @vmDict[id]
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
    @geomerties = @vmList
    .map (shape) -> shape.canvas
    # console.log 'paint:', geomerties
    painter.paint @geomerties, @node

  json: json.generate
