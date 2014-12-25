
lodash = require 'lodash'

component = require './component'

exports.create = (options) ->
  # call this in side render
  (props, children...) ->
    # call this when parent is computed
    (base, manager) ->
      c = {}
      vm = manager.vmDict[c.id]
      lodash.assign c, component
      lodash.assign c, options
      lodash.assign c,
        viewport: manager.getViewport()
        props: props or {}
        base: base
        children: children.map (f) ->
          f (vm or c).getBase(), manager
      if vm?
        c.state = vm.state
        c.setState = (data) ->
          c.state = vm.state = lodash.assign {}, vm.state, data

      c.renderView manager
