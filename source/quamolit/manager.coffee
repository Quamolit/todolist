
json = require 'cirru-json'
lodash = require 'lodash'

treeUtil = require '../util/tree'
time = require '../util/time'
tool = require '../util/tool'

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
    x: @node.width / 2
    y: @node.height / 2

  render: (creator) ->
    rootBase =  @getViewport()
    tree = creator rootBase, @
    # console.log json.generate tree
    @patchVms (lodash.cloneDeep tree)
    @startAnimationLoop()

  patchVms: (tree) ->
    list = treeUtil.flatten tree
    # register new viewmodels
    lodash.each list, (child) =>
      @registerVm child
    # fade viewmodels that no longer exist
    lodash.each @vmDict, (child, id) =>
      if child.isMounted
        newChild = lodash.find list, {id}
        @fadeVm id unless newChild?

    # dont modify original list
    @vmList = list.concat()
    .sort (a, b) ->
      tool.compareZ a.base.z, b.base.z
    @paintVms()

  registerVm: (child) ->
    unless @vmDict[child.id]?
      @vmDict[child.id] = child
      child.stage = 'new'
      child.stageTime = time.now()

  fadeVm: (id) ->
    child = @vmDict[id]
    child.isMounted = false
    console.warn "#{id} is fading"
    # do somthing

  startAnimationLoop: ->
    console.info 'animation loop'
    requestAnimationFrame => time.timeout 4000, =>
      @startAnimationLoop()
    now = time.now()
    lodash.each @vmDict, (child, id) =>
      switch child.stage
        # remove out date elements
        when 'dead'     then @handleDeadNodes     child, id, now
        when 'leaving'  then @handleLeavingNodes  child, id, now
        # setup new elements
        when 'new'      then @handleNewNodes      child, id, now
        when 'delay'    then @handleDelayNodes    child, id, now
        # animate tween state components
        when 'entering' then @handleEnteringNodes child, id, now
        when 'tween'    then @handleTweenNodes    child, id, now
        when 'stable'   then @handleStableNodes   child, id, now

  handleDeadNodes: (c, id, now) ->
    delete @vmDict[id]

  handleLeavingNodes: (c, id, now) ->
    tool.evalArray c.onLeavingCalls
    if now - c.stageTime > c.duration
      delete @vmDict[id]

  handleNewNodes: (c, id, now) ->
    c.stageTime = now
    switch
      when c.delay > 0
        c.stage = 'delay'
        tool.evalArray c.onDelayCalls
      when c.duration > 0
        c.stage = 'entering'
        tool.evalArray c.onDelayCalls
        tool.evalArray c.onEnteringCalls
      else
        c.stage = 'stable'
        tool.evalArray c.onEnteringCalls
        tool.evalArray c.onDelayCalls
        tool.evalArray c.onStableCalls

  handleDelayNodes: (c, id, now) ->
    if now - c.stageTime > c.delay
      c.stageTime = now
      switch
        when c.duration > 0
          c.stage = 'entering'
          tool.evalArray c.onEnteringCalls
        else
          c.stage = 'stable'
          tool.evalArray c.onEnteringCalls
          tool.evalArray c.onStableCalls

  handleEnteringNodes: (c, id, now) ->
    if now - c.stageTime > c.duration
      c.stageTime = now
      c.stage = 'stable'
      tool.evalArray c.onEnteringCalls
      tool.evalArray c.onStableCalls

  handleTweenNodes: (c, id, now) ->
    unless c.isMounted
      c.stageTime = now
      c.stage = 'leaving'
    else if now - c.stageTime > c.duration
      c.stageTime = now
      c.stage = 'stable'

  handleStableNodes: (c, id, now) ->
    unless c.isMounted
      c.stageTime = now
      c.stage = 'leaving'

  paintVms: ->
    geomerties = @vmList
    .filter (vm) ->
      vm.category is 'canvas'
    .map (vm) ->
      vm.children
    console.log json.generate (lodash.flatten geomerties)
