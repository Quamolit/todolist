
Manager = require './quamolit/manager'
container = require './app/container'

canvas = document.querySelector('#canvas')

canvas.width = innerWidth
canvas.height = innerHeight

pageManager = new Manager node: canvas

component = container data: 'demo'
pageManager.render component
