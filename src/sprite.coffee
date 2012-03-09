class sprite
  constructor: (args) ->
    def = 
      sheet    : 0
      area     : new rect 0, 0, 0, 0
      callback : 0
      len      : new Array
      speed    : new Array
      collide  : false
      trigger  : false
      interact : false
      vector   : 0
      mode     : 0
      frame    : 0
    @[prop] = args[prop] ? def[prop] for prop of def
    @xmove = [-0.707, -1, -0.707, 0, 0.707, 1, 0.707, 0]
    @ymove = [0.707, 0, -0.707, -1, -0.707, 0, 0.707, 1]

  step: (buff) ->
    if @sheet isnt 0
      @frame = 0 if @frame >= @len[@mode]
      coords = new vect Math.floor(@frame) + Math.abs(@vector * @len[@mode]), @mode
      if @vector < 0
        buff.ctx.scale -1, 1
        buff.map @sheet, coords, new rect -@area.x - @area.w, @area.y, @area.w, @area.h
        buff.ctx.scale -1, 1
      else buff.map @sheet, coords, @area
      @area.x += @xmove[@vector + 3] * @speed[@mode]
      @area.y += @ymove[@vector + 3] * @speed[@mode]
      @frame += 0.3

  docollide: (wall) ->
    off1 = @area.y + @area.h - wall.area.y
    off2 = wall.area.x + wall.area.w - @area.x
    off3 = wall.area.y + wall.area.h - @area.y
    off4 = @area.x + @area.w - wall.area.x
    offx = 1
    offset = off1
    if off1 > 0 and off2 > 0 and off3 > 0 and off4 > 0
      if wall.collide
        if offset > off2
          offset = off2
          offx = 2
        if offset > off3
          offset = off3
          offx = 3
        if offset > off4
          offset = off4
          offx = 4
        @area.y -= offset if offx is 1
        @area.x += offset if offx is 2
        @area.y += offset if offx is 3
        @area.x -= offset if offx is 4
      if wall.trigger
        @mode = 0
        wall.callback()
  
  dointeract: (wall) ->
    offx = new rect @area.x, @area.y, @area.w, @area.h
    offx.x -= offx.w / 2 if @vector < 0
    offx.x += offx.w / 2 if 0 < @vector < 4
    offx.y -= offx.h / 2 if -2 < @vector < 2
    offx.y += offx.h / 2 if @vector < -2 or @vector > 2
    off1 = offx.y + offx.h - wall.area.y
    off2 = wall.area.x + wall.area.w - offx.x
    off3 = wall.area.y + wall.area.h - offx.y
    off4 = offx.x + offx.w - wall.area.x
    if off1 > 0 and off2 > 0 and off3 > 0 and off4 > 0
      @mode = 0
      wall.callback()
