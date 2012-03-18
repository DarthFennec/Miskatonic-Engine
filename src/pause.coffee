class pauser
  constructor: (@overlay, @underlay) ->
    @display = new surface new vect 800, 600
    @pressed = no
    @show = no

  render: (buffer) ->
    if @pressed
      @pressed = no
      @show = not @show
      @display.clear no
      @display.blit @underlay
      @display.blit @overlay
    buffer.blit @display if @show
    @show

  input: (keys) ->
    @pressed = yes if keys.poll[6] is 1
    @show
