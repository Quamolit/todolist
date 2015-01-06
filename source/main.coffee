
Manager = require './quamolit/manager'
container = require './app/container'

canvas = document.querySelector('#canvas')

canvas.width = innerWidth
canvas.height = innerHeight

canvas.addEventListener 'click', (event) ->
  console.info event.offsetX, event.offsetY

window.Q = pageManager = new Manager node: canvas

component = container data: 'demo'
pageManager.render component
