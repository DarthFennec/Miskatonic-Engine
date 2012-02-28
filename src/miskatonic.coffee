class miskatonic
  constructor: (buffer, @rends) ->
    @screen = buffer.getContext "2d"
    @buffer = document.createElement "canvas"
    @buffer.width = buffer.width
    @buffer.height = buffer.height
    @context = @buffer.getContext "2d"
    @context.globalCompositeOperation = "destination-over"
    @viewport = new camera @context, @buffer.width, @buffer.height
    @keys = new Object
    @keys.poll = [0, 0, 0, 0, 0, 0, 0]
    @keys.state = [0, 0, 0, 0, 0, 0, 0]
    @keycodes = [87, 65, 83, 68, 16, 32, 27] # 87 = w, 65 = a, 83 = s, 68 = d, 16 = shift, 32 = space, 27 = esc

  input: (event) =>
    for i in [0..6]
      @keys.poll[i] = if event.keyCode is @keycodes[i] then event.data else 0
      @keys.state[i] = 1 if @keys.poll[i] is 1
      @keys.state[i] = 0 if @keys.poll[i] is -1
    for rend in @rends then if rend.input @keys then break

  step: =>
    @screen.clearRect 0, 0, @buffer.width, @buffer.height
    @screen.drawImage @buffer, 0, 0
    @context.clearRect 0, 0, @buffer.width, @buffer.height
    for rend in @rends then if rend.render @viewport then break
