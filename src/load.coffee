class loader
  constructor: ->
    @loadsprite = 0
    @loadcount = []
    @maxload = 0

  render: (buffer) ->
    if @loadcount.length isnt 0
      @maxload = @loadcount.length if @maxload < @loadcount.length
      loadwidth = (@maxload - @loadcount.length)*(buffer.dims.x - 60)/@maxload
      buffer.ctx.beginPath()
      buffer.ctx.moveTo 30, buffer.dims.y - 30
      buffer.ctx.lineTo loadwidth + 30, buffer.dims.y - 30
      buffer.ctx.stroke()
      @loadsprite.step buffer, new vect 0, 0 if @loadsprite isnt 0
    else @maxload = 0
    @loadcount.length isnt 0

  input: (keys) -> @loadcount.length isnt 0
