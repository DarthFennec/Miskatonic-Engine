class loader
  constructor: (@loadsprite, @loadctx, @loadbar) ->
    @buffer = document.createElement "canvas"
    @buffer.width = 800
    @buffer.height = 600
    @bufferctx = @buffer.getContext "2d"
    @bufferctx.fillStyle = "#000000"
    @bufferctx.strokeStyle = "#ffffff"
    @bufferctx.lineWidth = 2
    @class = new spritehandler
    @maxload = 0

  render: (buffer) ->
    if @loadctx.loadcount isnt 0
      @maxload = @loadctx.loadcount if @maxload < @loadctx.loadcount
      loadwidth = (@maxload - @loadctx.loadcount) * @loadbar.w / @maxload
      @bufferctx.fillRect 0, 0, @buffer.width, @buffer.height
      @bufferctx.fillStyle = "#ffffff"
      @bufferctx.strokeRect @loadbar.x, @loadbar.y, @loadbar.w, @loadbar.h
      @bufferctx.fillRect @loadbar.x, @loadbar.y, loadwidth, @loadbar.h
      @bufferctx.fillStyle = "#000000"
      @class.step @bufferctx, @loadsprite
      buffer.blit @buffer, "c", "c"
    else @maxload = 0
    @loadctx.loadcount isnt 0

  input: (keys) ->
    @loadctx.loadcount isnt 0
