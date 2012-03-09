class loader
  constructor: (@loadsprite, @loadctx, @loadbar) ->
    @buffer = new surface new vect 800, 600
    @buffer.ctx.fillStyle = "#000000"
    @buffer.ctx.strokeStyle = "#ffffff"
    @buffer.ctx.lineWidth = 2
    @maxload = 0

  render: (buffer) ->
    if @loadctx.loadcount isnt 0
      @maxload = @loadctx.loadcount if @maxload < @loadctx.loadcount
      loadwidth = (@maxload - @loadctx.loadcount) * @loadbar.w / @maxload
      @buffer.clear no
      @buffer.ctx.fillStyle = "#ffffff"
      @buffer.ctx.strokeRect @loadbar.x, @loadbar.y, @loadbar.w, @loadbar.h
      @buffer.ctx.fillRect @loadbar.x, @loadbar.y, loadwidth, @loadbar.h
      @buffer.ctx.fillStyle = "#000000"
      @loadsprite.step @buffer
      buffer.blit @buffer
    else @maxload = 0
    @loadctx.loadcount isnt 0

  input: (keys) ->
    @loadctx.loadcount isnt 0
