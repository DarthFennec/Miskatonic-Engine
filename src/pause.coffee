class pauser
  constructor: (@underlay, @display, @menu, @obj, @pausesnd, @unpausesnd) -> @pressed = 0

  render: (buffer) ->
    @pausesnd.step()
    @unpausesnd.step()
    if @pressed > 0
      @unpausesnd.play() if @pressed is 2
      @obj.frames = 0
    if @pressed < 0
      @display.size @underlay.size()
      @display.drawImage @underlay
      @pausesnd.play()
      for clip in @menu then for i of clip when clip[i].time? then clip[i].time = 0
      @obj.initialize @menu
    @pressed = 0
    @obj.render buffer

  input: (keys) ->
    a = if @obj.frames is 0 then -1 else 1
    ret = @obj.input keys
    b = if @obj.frames is 0 then -1 else 1
    @pressed = if keys.pause.poll is 1 or (a is 1 and b is -1) then a else 0
    @pressed = 2 if keys.pause.poll is 1 and a is 1
    @pressed = 0 if keys.pause.poll is 1 and @obj.frame? and @obj.frame.overlay isnt -1
    ret
