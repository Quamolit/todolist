
json = require 'cirru-json'
lodash = require 'lodash'

treeUtil = require '../util/tree'

module.exports = class Manager
  constructor: (options) ->
    @vmDict = {}
    @vmList = []
    @listeners = []
    @node = options.node

  on: (f) ->
    @listeners.push f

  emit: ->
    @listeners.forEach (f) -> f()

  render: (creator) ->
    viewport = @getViewport()
    chunk = creator 0, viewport, @
    # console.log JSON.stringify chunk, null, 2
    @compareViews chunk

  compareViews: (tree) ->
    console.info json.generate tree
    list = treeUtil.flatten tree
    # register new viewmodels
    lodash.each list, (child) =>
      @registerVm child
    # fade viewmodels that no longer exist
    lodash.each @vmDict, (child, id) =>
      if child.isMounted
        newChild = lodash.find list, {id}
        @fadeVm id unless newChild?

  registerVm: (child) ->
    @vmDict[child.id] or= child
    console.warn "#{child.id} mounted"

  fadeVm: (id) ->
    child = @vmDict[id]
    child.isMounted = false
    console.warn "#{id} is fading"
    # do somthine

  triggerViewEvent: (event) ->
    console.log event

  getViewport: ->
    # get node geomerty
    index: 0
