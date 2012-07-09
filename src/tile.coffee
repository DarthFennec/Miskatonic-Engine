class tileset extends sprite
  constructor: (@tilesize, @tilesheet, @bgmusic, bgcolor, grid) ->
    @musicplaying = @bgmusic is 0
    serv.engine.bgcolor = bgcolor
    serv.engine.buffer.ctx.fillStyle = bgcolor
    super {collide: true, passive: true, area: new rect 0, 0, @tilesize.x, @tilesize.y}
    gridsize = new vect grid[0].length, grid.length
    @sheet = new surface (new vect).l (k) => @tilesize.i(k)*gridsize.i(k)
    width = @tilesheet.dims.x/@tilesize.x
    @grid = for i in [0...(gridsize.x + 2)] then for j in [0...(gridsize.y + 2)]
      if i is 0 or j is 0 or i is gridsize.x + 1 or j is gridsize.y + 1 then -1
      else grid[j - 1][i - 1]
    for i in [0...gridsize.x] then for j in [0...gridsize.y]
      srcy = Math.floor ((Math.abs @grid[1 + i][1 + j]) - 1)/width
      srcx = (Math.abs @grid[1 + i][1 + j]) - 1 - srcy*width
      @sheet.map @tilesheet, srcx, srcy, @tilesize.x, @tilesize.y, i, j

  step: (buff, offset) ->
    if not @musicplaying
      @musicplaying = yes
      serv.audio.maxvolume = yes
      @bgmusic.play()
    @bgmusic.step() if @bgmusic isnt 0
    buff.layer @sheet, (new vect).l (k) => offset.i(k) + buff.dims.i(k)/2

  docollide: (spr) ->
    block = (new vect).l (k) => 1 + Math.floor spr.area.p.i(k)/@tilesize.i(k)
    mid = (new vect).l (k) => 1 + (Math.floor (spr.area.p.i(k) + spr.area.s.i(k)/2)/@tilesize.i(k)) - block.i(k)
    central = 1 + mid.x + mid.y*2
    if @grid[block.x][block.y] < 0 and (central isnt 4 or (@grid[block.x][block.y + 1] > 0 and @grid[block.x + 1][block.y] > 0))
      @area.p.x = (block.x - 1)*@area.s.x
      @area.p.y = (block.y - 1)*@area.s.y
      super spr
    if @grid[block.x + 1][block.y] < 0 and (central isnt 3 or (@grid[block.x][block.y] > 0 and @grid[block.x + 1][block.y + 1] > 0))
      @area.p.x = block.x*@area.s.x
      @area.p.y = (block.y - 1)*@area.s.y
      super spr
    if @grid[block.x][block.y + 1] < 0 and (central isnt 2 or (@grid[block.x][block.y] > 0 and @grid[block.x + 1][block.y + 1] > 0))
      @area.p.x = (block.x - 1)*@area.s.x
      @area.p.y = block.y*@area.s.y
      super spr
    if @grid[block.x + 1][block.y + 1] < 0 and (central isnt 1 or (@grid[block.x][block.y + 1] > 0 and @grid[block.x + 1][block.y] > 0))
      @area.p.x = block.x*@area.s.x
      @area.p.y = block.y*@area.s.y
      super spr
