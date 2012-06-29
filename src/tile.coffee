class tileset extends sprite
  constructor: (@tilesize, @tilesheet, @bgmusic, bgcolor, grid) ->
    @musicplaying = no
    serv.engine.bgcolor = bgcolor
    serv.engine.buffer.ctx.fillStyle = bgcolor
    @gridsize = new vect grid[0].length, grid.length
    @grid = for i in [0...@gridsize.x] then for j in [0...@gridsize.y] then grid[j][i]
    newsheet = new surface (new vect).l (k) => @tilesize.i(k)*@gridsize.i(k)
    width = @tilesheet.dims.x/@tilesize.x
    for i in [0...@gridsize.x] then for j in [0...@gridsize.y]
      srcy = Math.floor ((Math.abs @grid[i][j]) - 1)/width
      srcx = (Math.abs @grid[i][j]) - 1 - srcy*width
      newsheet.map @tilesheet, srcx, srcy, @tilesize.x, @tilesize.y, i, j
    super {sheet: newsheet, collide: true, passive: true, area: new rect 0, 0, @tilesize.x, @tilesize.y}

  step: (buff, offset) ->
    if not @musicplaying
      @musicplaying = yes
      serv.audio.maxvolume = yes
      @bgmusic.play()
    @bgmusic.step()
    buff.layer @sheet, (new vect).l (k) -> offset.i(k) + buff.dims.i(k)/2

  docollide: (spr) ->
    block = (new vect).l (k) => Math.floor spr.area.p.i(k)/@tilesize.i(k)
    mid = (new vect).l (k) => (Math.floor (spr.area.p.i(k) + spr.area.s.i(k)/2)/@tilesize.i(k)) - block.i(k)
    central = 1 + mid.x + mid.y*2
    if block.x < 0
      @area.p.x = -@area.s.x
      @area.p.y = spr.area.p.y
      super spr
    if block.x > @gridsize.x - 2
      @area.p.y = spr.area.p.y
      @area.p.x = @gridsize.x*@area.s.x
      super spr
    if block.y < 0
      @area.p.y = -@area.s.y
      @area.p.x = spr.area.p.x
      super spr
    if block.y > @gridsize.y - 2
      @area.p.x = spr.area.p.x
      @area.p.y = @gridsize.y*@area.s.y
      super spr
    if block.x > 0 and block.x < @gridsize.x - 2
      if @grid[block.x][block.y] < 0 and (central isnt 4 or (@grid[block.x][block.y + 1] > 0 and @grid[block.x + 1][block.y] > 0))
        @area.p.x = block.x*@area.s.x
        @area.p.y = block.y*@area.s.y
        super spr
      if @grid[block.x + 1][block.y] < 0 and (central isnt 3 or (@grid[block.x][block.y] > 0 and @grid[block.x + 1][block.y + 1] > 0))
        @area.p.x = (block.x + 1)*@area.s.x
        @area.p.y = block.y*@area.s.y
        super spr
      if @grid[block.x][block.y + 1] < 0 and (central isnt 2 or (@grid[block.x][block.y] > 0 and @grid[block.x + 1][block.y + 1] > 0))
        @area.p.x = block.x*@area.s.x
        @area.p.y = (block.y + 1)*@area.s.y
        super spr
      if @grid[block.x + 1][block.y + 1] < 0 and (central isnt 1 or (@grid[block.x][block.y + 1] > 0 and @grid[block.x + 1][block.y] > 0))
        @area.p.x = (block.x + 1)*@area.s.x
        @area.p.y = (block.y + 1)*@area.s.y
        super spr
