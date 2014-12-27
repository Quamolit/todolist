
json = require 'cirru-json'

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
    chunk = creator viewport, @
    # console.log JSON.stringify chunk, null, 2
    @compareViews chunk

  compareViews: (tree) ->
    console.log json.generate tree

  triggerViewEvent: (event) ->
    console.log event

  getViewport: ->
    # get node geomerty
    index: 0
