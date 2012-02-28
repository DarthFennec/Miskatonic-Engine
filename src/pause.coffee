class pauser
  constructor: (@overlay, @underlay) ->
    @display = document.createElement "canvas"
    @display.width = underlay.width
    @display.height = underlay.height
    @context = @display.getContext "2d"
    @pressed = false
    @show = false

  render: (buffer) ->
    if @pressed
      @pressed = false
      @show = not @show
      @context.clearRect 0, 0, @display.width, @display.height
      @context.drawImage @underlay, 0, 0
    if @show
      buffer.blit @overlay, "c", "c"
      buffer.blit @display, "c", "c"
    @show

  input: (keys) ->
    @pressed = true if keys.poll[6] is 1
    @show
