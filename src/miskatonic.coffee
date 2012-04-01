class miskatonic
  constructor: (@rends, @screen) ->
    @buffer = new surface @screen.size()
    @buffer.ctx.fillStyle = "#000000"
    @buffer.ctx.strokeStyle = "#ffffff"
    @buffer.ctx.lineWidth = 25
    @buffer.ctx.lineCap = "round"
    @buffer.ctx.globalCompositeOperation = "destination-over"
    @keys = {poll: [0, 0, 0, 0, 0, 0, 0], state: [0, 0, 0, 0, 0, 0, 0]}
    # 38+87+90+188=up, 37+65+81=left, 40+79+83=down, 39+68+69=right, 16=shift, 32=space, 27=esc
    @keycodes = [[38, 87, 90, 188], [37, 65, 81], [40, 79, 83], [39, 68, 69], [16], [32], [27]]

  input: (event) =>
    for i in [0..6]
      @keys.poll[i] = 0
      for key in @keycodes[i]
        @keys.poll[i] = event.data if event.keyCode is key
      @keys.state[i] = 1 if @keys.poll[i] is 1
      @keys.state[i] = 0 if @keys.poll[i] is -1
    for rend in @rends then if rend.input @keys then break

  step: =>
    @screen.blit @buffer, 0, 0
    @buffer.clear no
    for rend in @rends then if rend.render @buffer then break
    @buffer.clear yes
