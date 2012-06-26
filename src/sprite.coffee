class sprite
  constructor: (args) ->
    def =
      sheet    : 0
      area     : new rect 0, 0, 0, 0
      callback : 0
      aiscript : 0
      len      : []
      speed    : []
      collide  : false
      trigger  : false
      interact : false
      passive  : false
      vector   : new angle "spr", 0
      mode     : 0
      frame    : 0
    @[prop] = args[prop] ? def[prop] for prop of def

  step: (buff, offset) ->
    if @sheet isnt 0
      @frame = 0 if @frame >= @len[@mode]
      coords = new vect (Math.floor @frame) + (Math.abs @len[@mode]*(@vector.get "spr")), @mode
      if (@vector.get "spr") < 0
        buff.ctx.scale -1, 1
        buff.map @sheet, coords.x, coords.y, @area.s.x, @area.s.y, offset.x - @area.p.x - @area.s.x, @area.p.y - offset.y, 1, 1
        buff.ctx.scale -1, 1
      else buff.map @sheet, coords.x, coords.y, @area.s.x, @area.s.y, @area.p.x - offset.x, @area.p.y - offset.y, 1, 1
      @area.p.l => @area.p.i() + @speed[@mode]*(@vector.get "vlc").i()
      @frame += 0.3

  docollide: (spr) ->
    off1 = spr.area.p.x + spr.area.s.x - @area.p.x
    off2 = spr.area.p.y + spr.area.s.y - @area.p.y
    off3 = @area.p.x + @area.s.x - spr.area.p.x
    off4 = @area.p.y + @area.s.y - spr.area.p.y
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
        spr.area.p.x -= offset if offx is 1
        spr.area.p.y -= offset if offx is 2
        spr.area.p.x += offset if offx is 3
        spr.area.p.y += offset if offx is 4
      if @trigger
        spr.mode = 0
        @callback this, spr

  dointeract: (spr) ->
    offx = new rect spr.area.p.x, spr.area.p.y, spr.area.s.x, spr.area.s.y
    offx.p.l -> offx.p.i() + (spr.vector.get "kbd").i()*offx.s.i()/2
    off1 = (new vect).l => offx.p.i() + offx.s.i() - @area.p.i()
    off2 = (new vect).l => @area.p.i() + @area.s.i() - offx.p.i()
    if off1.x > 0 and off1.y > 0 and off2.x > 0 and off2.y > 0
      spr.mode = 0
      @callback this, spr

  savestate: -> {px: @area.p.x, py: @area.p.y, md: @mode, fr: @frame, vx: @vector.get "spr"}

  loadstate: (state) ->
    @area.p.x = state.px
    @area.p.y = state.py
    @mode = state.md
    @frame = state.fr
    @vector.set "spr", state.vx
