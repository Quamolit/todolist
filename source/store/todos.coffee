
shortid = require 'shortid'
lodash = require 'lodash'

Dispatcher = require '../util/dispatcher'
actions = require '../actions'

list = []

module.exports = exports = new Dispatcher

exports.get = ->
  list

actions.on 'create', (data) ->
  data.id = shortid.generate()
  list.unshift data
  exports.dispatch()

actions.on 'delete', (id) ->
  list = list.filter (x) -> x.id isnt id
  exports.dispatch()

actions.on 'update', (data) ->
  item = lodash.find id: data.id
  lodash.assign item, data
  exports.dispatch()
