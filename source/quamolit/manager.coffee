
json = require 'cirru-json'
lodash = require 'lodash'

treeUtil = require '../util/tree'
time = require '../util/time'
tool = require '../util/tool'
painter = require './painter'

module.exports = class Manager
  constructor: (options) ->
    @node = options.node
    @handleEvents()
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
      return if child.category isnt 'component'
      return if id.indexOf("#{changeId}/") < 0
      return if child.stage is 'leaving'
      return if child.touchTime >= changeTime
      console.info 'leaving', id
      tool.evalArray child.onLeavingCalls
      child.updateStage 'leaving'
      child.tweenState = child.getLeavingTween?() or {}
    @maintainStages()

  render: (creator) ->
    # knots are binded to @vmDict directly
    creator @getViewport(), @
    @maintainStages()

  maintainStages: ->
    for id, child of @vmDict
      if child.category is 'component'
        if child.stage isnt 'stable'
          requestAnimationFrame @maintainStages.bind(@)
          break

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
    if now - c.stageTime >= c.delay()
      c.tweenState = c.getTweenState() or {}
      switch
        when c.duration() > 0
          c.updateStage 'entering'
          tool.evalArray c.onEnteringCalls
        else
          c.updateStage 'stable'
          tool.evalArray c.onEnteringCalls
          tool.evalArray c.onStableCalls

  handleEnteringNodes: (c, now) ->
    if now - c.stageTime > c.duration()
      c.updateStage 'stable'
      tool.evalArray c.onEnteringCalls
      tool.evalArray c.onStableCalls
    else
      @updateVmTweenFrame c, now

  handleTweenNodes: (c, now) ->
    if now - c.stageTime > c.duration()
      c.updateStage 'stable'
    else
      @updateVmTweenFrame c, now

  updateVmTweenFrame: (c, now) ->
    ratio = (now - c.stageTime) / c.duration()
    frame = tool.computeTween c.stageTimeState, c.tweenState, ratio, c.bezier()
    c.setTweenFrame frame

  paintVms: ->
    @updateVmList()
    @geomerties = {}
    geomerties = @vmList
    .map (shape) =>
      @geomerties[shape.id] = shape.canvas
      shape.canvas
    # console.log 'paint:', geomerties
    painter.paint geomerties, @node

  json: json.generate

  handleEvents: ->
    @node.addEventListener 'click', (event) =>
      x = event.offsetX
      y = event.offsetY
      ev =
        bubble: yes
        x: x
        y: y
      for vm in @vmList.concat().reverse()
        vm.onClick? ev if vm.coveredPoint x, y
        break unless ev.bubble
