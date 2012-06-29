class loader
  constructor: ->
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
    else @maxload = 0
    @loadcount.length isnt 0

  input: (keys) -> @loadcount.length isnt 0
