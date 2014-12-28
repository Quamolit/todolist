
add = (a, b) ->
  x: a.x + b.x
  y: a.x + b.y

minus = (a, b) ->
  x: a.x - b.x
  y: a.y - b.y

renderText = (ctx, op) ->
  ctx.font = "#{op.size}px #{op.family}"
  ctx.textAlign = op.textAlign
  ctx.textBaseline = op.textBaseline
  ctx.fillStyle = op.fillStyle
  ctx.fillText op.text, op.from.x, op.from.y

renderRect = (ctx, op) ->
  a = minus op.from, op.vector
  b = add op.from, op.vector
  switch op.kind
    when 'fill'
      ctx.fillStyle = op.fillStyle
      ctx.fillRect a.x, a.y, b.x, b.y
    when 'clear'
      ctx.clearRect a.x, a.y, b.x, b.y
    when 'stroke'
      ctx.strokeStyle = op.strokeStyle
      ctx.strokeRect a.x, a.y, b.x, b.y

renderArc = (ctx, op) ->
  ctx.arc op.from.x, op.from.y, op.r, op.startAngle, op.endAngle, op.anti
  switch (op.kind or 'fill')
    when 'fill'
      ctx.fillStyle = op.fillStyle
      ctx.fill()
    when 'stroke'
      ctx.strokeStyle = op.strokeStyle
      ctx.stroke()

exports.paint = (operations, node) ->

  ctx = node.getContext('2d')
  ctx.clearRect 0, 0, node.width, node.height
  ctx.save()
  shiftX = Math.round (node.width / 2)
  shiftY = Math.round (node.height / 2)
  ctx.translate shiftX, shiftY

  operations.forEach (op) ->
    ctx.save()
    ctx.translate op.base.x, op.base.y
    switch op.type
      when 'text' then renderText ctx, op
      when 'rect' then renderRect ctx, op
      when 'arc'  then renderArc  ctx, op
      else console.warn "#{op.type} not finished"
    ctx.restore()
  ctx.restore()