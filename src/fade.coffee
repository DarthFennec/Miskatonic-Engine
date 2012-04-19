class fader
  constructor: ->
    @frame = 0
    @step = 0

  initialize: (@color, callback) ->
    @frame = 0
    @step = callback

  render: (buffer) ->
    if @step isnt 0
      newalpha = @step @frame
      if newalpha < 0 then @step = 0 
      else
        buffer.soundmgr.all "fade", 1 - newalpha
        buffer.ctx.globalAlpha = newalpha
        buffer.ctx.fillStyle = @color
        buffer.clear yes
        buffer.ctx.globalAlpha = 1.0
        buffer.ctx.fillStyle = "#000000"
        @frame += 1
    no

  input: (keys) ->
    @step isnt 0
