class pauser
  constructor: (@overlay, @underlay) ->
    @display = new surface @overlay.size()
    @pressed = no
    @show = no

  render: (buffer) ->
    if @pressed
      @pressed = no
      @show = not @show
      @display.clear no
      @display.blit @underlay, 0, 0
      @display.blit @overlay, 0, 0
    buffer.blit @display, 0, 0 if @show
    @show

  input: (keys) ->
    @pressed = yes if keys.poll[6] is 1
    @show
