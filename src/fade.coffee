class fader
  constructor: ->
    @buffer = document.createElement "canvas"
    @buffer.width = 800
    @buffer.height = 600
    @bufferctx = @buffer.getContext "2d"
    @step = 0
    @frame = 0

  initialize: (color, callback) ->
    @frame = 0
    @bufferctx.fillStyle = color
    @step = callback

  render: (buffer) ->
    if @step isnt 0
      newalpha = @step @frame
      if newalpha < 0 then @step = 0
      else @bufferctx.globalAlpha = newalpha
      @bufferctx.clearRect 0, 0, @buffer.width, @buffer.height
      @bufferctx.fillRect 0, 0, @buffer.width, @buffer.height
      buffer.blit @buffer, "c", "c"
      @frame += 1
    false

  input: (keys) ->
    if @step isnt 0 then true else false
