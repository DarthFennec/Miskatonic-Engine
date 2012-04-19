class sprite
  constructor: (args) ->
    def = 
      sheet    : 0
      area     : new rect 0, 0, 0, 0
      callback : 0
      aiscript : 0
      len      : new Array
      speed    : new Array
      collide  : false
      trigger  : false
      interact : false
      aienable : true
      vector   : 0
      mode     : 0
      frame    : 0
    @[prop] = args[prop] ? def[prop] for prop of def

  step: (buff, offset) ->
    if @sheet isnt 0
      xmove = [-0.707, -1, -0.707, 0, 0.707, 1, 0.707, 0]
      ymove = [0.707, 0, -0.707, -1, -0.707, 0, 0.707, 1]
      @frame = 0 if @frame >= @len[@mode]
      coords = new vect Math.floor(@frame) + Math.abs(@vector * @len[@mode]), @mode
      if @vector < 0
        buff.ctx.scale -1, 1
        buff.map @sheet, coords.x, coords.y, offset.x - @area.x - @area.w, @area.y - offset.y, @area.w, @area.h
        buff.ctx.scale -1, 1
      else buff.map @sheet, coords.x, coords.y, @area.x - offset.x, @area.y - offset.y, @area.w, @area.h
      @area.x += xmove[@vector + 3] * @speed[@mode]
      @area.y += ymove[@vector + 3] * @speed[@mode]
      @frame += 0.3

  docollide: (spr) ->
    off1 = spr.area.y + spr.area.h - @area.y
    off2 = @area.x + @area.w - spr.area.x
    off3 = @area.y + @area.h - spr.area.y
    off4 = spr.area.x + spr.area.w - @area.x
    offx = 1
    offset = off1
    if off1 > 0 and off2 > 0 and off3 > 0 and off4 > 0
      if @collide
        if offset > off2
          offset = off2
          offx = 2
        if offset > off3
          offset = off3
          offx = 3
        if offset > off4
          offset = off4
          offx = 4
        spr.area.y -= offset if offx is 1
        spr.area.x += offset if offx is 2
        spr.area.y += offset if offx is 3
        spr.area.x -= offset if offx is 4
      if @trigger
        spr.mode = 0
        @callback this, spr

  dointeract: (spr) ->
    offx = new rect spr.area.x, spr.area.y, spr.area.w, spr.area.h
    offx.x -= offx.w / 2 if spr.vector < 0
    offx.x += offx.w / 2 if 0 < spr.vector < 4
    offx.y -= offx.h / 2 if -2 < spr.vector < 2
    offx.y += offx.h / 2 if spr.vector < -2 or spr.vector > 2
    off1 = offx.y + offx.h - @area.y
    off2 = @area.x + @area.w - offx.x
    off3 = @area.y + @area.h - offx.y
    off4 = offx.x + offx.w - @area.x
    if off1 > 0 and off2 > 0 and off3 > 0 and off4 > 0
      spr.mode = 0
      @callback this, spr

  lookhere: (object, bothlook) ->
    opposite = [1, 2, 3, 4, -3, -2, -1, 0]
    xdist = object.area.x - @area.x
    ydist = object.area.y - @area.y
    if xdist is 0
      direction = if ydist > 0 then 0 else 4
    else slope = ydist / xdist
    if xdist < 0
      direction = 4 if slope > 2.41421356
      direction = 3 if 0.414213562 < slope <= 2.41421356
      direction = 2 if -0.414213562 < slope <= 0.414213562
      direction = 1 if -2.41421356 < slope <= -0.414213562
      direction = 0 if slope <= -2.41421356
    if xdist > 0
      direction = 0 if slope > 2.41421356
      direction = -1 if 0.414213562 < slope <= 2.41421356
      direction = -2 if -0.414213562 < slope <= 0.414213562
      direction = -3 if -2.41421356 < slope <= -0.414213562
      direction = 4 if slope <= -2.41421356
    object.vector = direction if bothlook
    @vector = opposite[direction + 3]
