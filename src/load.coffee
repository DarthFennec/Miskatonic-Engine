class loader
  constructor: (@loadctx) ->
    @maxload = 0
    @loadsprite = 0

  render: (buffer) ->
    if @loadctx.loadcount isnt 0
      @maxload = @loadctx.loadcount if @maxload < @loadctx.loadcount
      loadwidth = (@maxload - @loadctx.loadcount) * (buffer.dims.x - 60) / @maxload
      buffer.ctx.beginPath()
      buffer.ctx.moveTo 30, buffer.dims.y - 30
      buffer.ctx.lineTo loadwidth + 30, buffer.dims.y - 30
      buffer.ctx.stroke()
      @loadsprite.step buffer, new vect 0, 0 if @loadsprite isnt 0
    else @maxload = 0
    @loadctx.loadcount isnt 0

  input: (keys) ->
    #@loadctx.loadcount -= 1 if keys.poll[5] is 1
    @loadctx.loadcount isnt 0
