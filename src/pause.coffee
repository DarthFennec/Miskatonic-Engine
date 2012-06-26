class pauser
  constructor: (@underlay, @menu, @obj) ->
    @display = new surface @underlay.size()
    @menu[0].elem = [new particle @display, (t) -> [0, 0, 1, 1]]
    @pressed = 0

  render: (buffer) ->
    if @pressed > 0 then @obj.frames = 0
    if @pressed < 0
      @display.clear no
      @display.drawImage @underlay
      for clip in @menu then for i of clip when clip[i].time? then clip[i].time = 0
      @obj.initialize @menu
    @pressed = 0
    @obj.render buffer

  input: (keys) ->
    a = if @obj.frames is 0 then -1 else 1
    ret = @obj.input keys
    b = if @obj.frames is 0 then -1 else 1
    @pressed = if keys.pause.poll is 1 or (a is 1 and b is -1) then a else 0
    ret
