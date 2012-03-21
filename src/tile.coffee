class tileset extends sprite
  constructor: (@tilesize, @tilesheet, @gridsize, @grid) ->
    newsheet = new surface new vect @tilesize.x * @gridsize.x, @tilesize.y * @gridsize.y
    width = @tilesheet.dims.x / @tilesize.x
    for i in [0...@gridsize.x] then for j in [0...@gridsize.y]
      srcy = Math.floor (Math.abs(@grid[i + j * @gridsize.x]) - 1) / width
      srcx = Math.abs(@grid[i + j * @gridsize.x]) - 1 - srcy * width
      newsheet.map @tilesheet, srcx, srcy, i * @tilesize.x, j * @tilesize.y, @tilesize.x, @tilesize.y
    super { sheet : newsheet, collide : true, area : new rect(0, 0, @tilesize.x, @tilesize.y) }

  step: (buff, offset) -> buff.layer @sheet, new vect(offset.x + buff.dims.x / 2, offset.y + buff.dims.y / 2)

  docollide: (spr) ->
    xblock = Math.floor spr.area.x / @tilesize.x
    yblock = Math.floor spr.area.y / @tilesize.y
    xmid = (Math.floor (spr.area.x + spr.area.w / 2) / @tilesize.x) - xblock
    ymid = (Math.floor (spr.area.y + spr.area.h / 2) / @tilesize.y) - yblock
    central = 1 + xmid + ymid * 2
    if xblock < 0
      @area.x = -@area.w
      @area.y = spr.area.y
      super spr
    if yblock < 0
      @area.x = spr.area.x
      @area.y = -@area.h
      super spr
    if xblock > @gridsize.x - 2
      @area.x = @gridsize.x * @area.w
      @area.y = spr.area.y
      super spr
    if yblock > @gridsize.y - 2
      @area.x = spr.area.x
      @area.y = @gridsize.y * @area.h
      super spr
    if @grid[xblock + yblock * @gridsize.x] < 0 and (central != 4 or (@grid[xblock + (yblock + 1) * @gridsize.x] > 0 and @grid[(xblock + 1) + yblock * @gridsize.x] > 0))
      @area.x = xblock * @area.w
      @area.y = yblock * @area.h
      super spr
    if @grid[(xblock + 1) + yblock * @gridsize.x] < 0 and (central != 3 or (@grid[xblock + yblock * @gridsize.x] > 0 and @grid[(xblock + 1) + (yblock + 1) * @gridsize.x] > 0))
      @area.x = (xblock + 1) * @area.w
      @area.y = yblock * @area.h
      super spr
    if @grid[xblock + (yblock + 1) * @gridsize.x] < 0 and (central != 2 or (@grid[xblock + yblock * @gridsize.x] > 0 and @grid[(xblock + 1) + (yblock + 1) * @gridsize.x] > 0))
      @area.x = xblock * @area.w
      @area.y = (yblock + 1) * @area.h
      super spr
    if @grid[(xblock + 1) + (yblock + 1) * @gridsize.x] < 0 and (central != 1 or (@grid[xblock + (yblock + 1) * @gridsize.x] > 0 and @grid[(xblock + 1) + yblock * @gridsize.x] > 0))
      @area.x = (xblock + 1) * @area.w
      @area.y = (yblock + 1) * @area.h
      super spr
