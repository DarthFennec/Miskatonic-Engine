class fader
  constructor: ->
    @buffer = new surface new vect 800, 600
    @frame = 0
    @step = 0

  initialize: (color, callback) ->
    @frame = 0
    @buffer.ctx.fillStyle = color
    @step = callback

  render: (buffer) ->
    if @step isnt 0
      newalpha = @step @frame
      if newalpha < 0 then @step = 0
      else @buffer.ctx.globalAlpha = newalpha
      @buffer.clear no
      @buffer.clear yes
      buffer.blit @buffer
      @frame += 1
    no

  input: (keys) ->
    if @step isnt 0 then yes else no
