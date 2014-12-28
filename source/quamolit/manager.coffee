
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

  updateVmDict: (tree) ->
    list = treeUtil.flatten tree
    # fade viewmodels that no longer exist
    lodash.each @vmDict, (child, id) =>
      unless child.stage is 'leaving'
        newChild = lodash.find list, {id}
        unless newChild?
          child.stage = 'leaving'
          child.stageTime = time.now()
          child.stageTimeState = lodash.cloneDeep child.tweenState
          @updateVmList list
    # register new viewmodels
    lodash.each list, (child) =>
      unless @vmDict[child.id]?
        @vmDict[child.id] = child
        child.stage = 'delay'
        child.stageTime = time.now()
        child.stageTimeState = lodash.cloneDeep child.tweenState
        @updateVmList list

  updateVmList: (list) ->
    # dont modify original list
    @vmList = list.concat()
    .sort (a, b) ->
      tool.compareZ a.base.z, b.base.z

  render: (creator) ->
    requestAnimationFrame => @render creator

    isDirty = lodash.some @vmDict, isDirty: yes
    isMounted = Object.keys(@vmDict).length > 0

    unless isMounted and isDirty
      tree = creator @getViewport(), @
      @updateVmDict (lodash.cloneDeep tree)

    isStable = lodash.every @vmDict, stage: 'stable'

    unless isStable
      @maintainStages()
      @paintVms()

  maintainStages: ->
    now = time.now()
    lodash.each @vmDict, (child, id) =>
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
    .filter (vm) ->
      vm.category is 'canvas'
    .map (vm) ->
      vm.children[0]

    console.clear()
    console.info (json.generate geomerties)
    painter.paint geomerties, @node
