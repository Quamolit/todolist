
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

  differLeavingVms: (changeId, changeTime) ->
    lodash.each @vmDict, (child, id) =>
      return if child.category isnt 'component'
      return if id.indexOf("#{changeId}/") < 0
      return if child.period is 'leaving'
      return if child.touchTime >= changeTime
      console.info 'leaving', id
      child.setPeriod 'leaving'
      child.keyframe = child.getLeavingKeyframe()
    @refreshVmPeriods()

  render: (factory) ->
    # knots are binded to @vmDict directly
    factory @getViewport(), @
    @refreshVmPeriods()

  refreshVmPeriods: ->
    for id, child of @vmDict
      if child.category is 'component'
        if child.period isnt 'stable'
          requestAnimationFrame @refreshVmPeriods.bind(@)
          break

    now = time.now()
    lodash.each @vmDict, (child, id) =>
      # vm already removed might appear
      return unless child?
      # canvas has no lifecycle
      return unless child.category is 'component'
      switch child.period
        # remove out date elements
        when 'leaving'  then @handleLeavingNodes  child, now
        # setup new elements
        when 'delay'    then @handleDelayNodes    child, now
        # animate components
        when 'entering' then @handleEnteringNodes child, now
        when 'changing' then @handleTweenNodes    child, now
    @paintVms()

  handleLeavingNodes: (c, now) ->
    if now - c.lastKeyframeTime > c.getDuration()
      console.info 'deleting', c.id
      @vmDict[c.id] = null
      delete @vmDict[c.id]
      lodash.each @vmDict, (child, id) =>
        # remove children
        if child? and (id.indexOf "#{c.id}/") is 0
          console.info 'deleting children', id
          tool.evalArray child.onDestroyCalls
          delete @vmDict[id]
    else
      @updateVmTweenFrame c, now

  handleDelayNodes: (c, now) ->
    if (now - c.lastKeyframeTime) >= (c.props?.delay or 0)
      c.keyframe = c.getInitialKeyframe()
      c.setPeriod (if c.getDuration() > 0 then 'entering' else 'stable')
      tool.evalArray c.onEnterCalls

  handleEnteringNodes: (c, now) ->
    if (now - c.lastKeyframeTime) > c.getDuration()
      c.setPeriod 'stable'
    else
      @updateVmTweenFrame c, now

  handleTweenNodes: (c, now) ->
    if (now - c.lastKeyframeTime) > c.getDuration()
      c.setPeriod 'stable'
    else
      @updateVmTweenFrame c, now

  updateVmTweenFrame: (c, now) ->
    ratio = (now - c.lastKeyframeTime) / c.getDuration()
    frame = tool.computeTween c.lastKeyframe, c.keyframe, ratio, c.getBezier()
    c.setKeyframe frame

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
