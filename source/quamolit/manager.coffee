
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
    id: ''
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
      if child.category is 'shape'
        if id.indexOf("#{changeId}/") is 0
          if child.touchTime < changeTime
            @vmDict[id] = null
            delete @vmDict[id]
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
        when 'changing' then @handleChangingNodes child, now
      if child.jumping  then @handleJumpingNodes  child, now
    @paintVms()

  handleLeavingNodes: (c, now) ->
    if now - c.cache.frameTime > c.getDuration()
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
      @updateVmFrame c, now

  handleDelayNodes: (c, now) ->
    if (now - c.cache.frameTime) >= (c.layout.delay or 0)
      c.keyframe = c.getKeyframe()
      c.setPeriod (if c.getDuration() > 0 then 'entering' else 'stable')
      tool.evalArray c.onEnterCalls

  handleEnteringNodes: (c, now) ->
    if (now - c.cache.frameTime) > c.getDuration()
      c.setPeriod 'stable'
    else
      @updateVmFrame c, now

  handleChangingNodes: (c, now) ->
    if (now - c.cache.frameTime) > c.getDuration()
      c.setPeriod 'stable'
    else
      @updateVmFrame c, now

  handleJumpingNodes: (c, now) ->
    if (now - c.cache.areaTime) > c.getDuration()
      c.jumping = no
    else
      @updateVmArea c, now

  updateVmFrame: (c, now) ->
    ratio = (now - c.cache.frameTime) / c.getDuration()
    frame = tool.computeTween c.cache.frame, c.keyframe, ratio, c.getBezier()
    c.setKeyframe frame

  updateVmArea: (c, now) ->
    ratio = (now - c.cache.areaTime) / c.getDuration()
    newArea = tool.combine c.base, c.layout
    area = tool.computeTween c.cache.area, newArea, ratio, c.getBezier()
    c.setArea area

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
        if vm.coveredPoint x, y
          # console.log vm
          vm.onClick? ev
        break unless ev.bubble
