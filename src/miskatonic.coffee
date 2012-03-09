class miskatonic
  constructor: (@screen, @rends) ->
    @buffer = new surface @screen.size()
    @buffer.ctx.fillStyle = "#000000"
    @buffer.ctx.globalCompositeOperation = "destination-over"
    @keys = {poll: [0, 0, 0, 0, 0, 0, 0], state: [0, 0, 0, 0, 0, 0, 0]}
    @keycodes = [87, 65, 83, 68, 16, 32, 27] # 87 = w, 65 = a, 83 = s, 68 = d, 16 = shift, 32 = space, 27 = esc

  input: (event) =>
    for i in [0..6]
      @keys.poll[i] = if event.keyCode is @keycodes[i] then event.data else 0
      @keys.state[i] = 1 if @keys.poll[i] is 1
      @keys.state[i] = 0 if @keys.poll[i] is -1
    for rend in @rends then if rend.input @keys then break

  step: =>
    @screen.blit @buffer
    @buffer.clear no
    for rend in @rends then if rend.render @buffer then break
    @buffer.clear yes
