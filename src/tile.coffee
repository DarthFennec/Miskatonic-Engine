# **The tilemap sprite.**
#
# A [sprite](sprite.html) that represents the map, or scenery image: floors, walls, things that
# don't move, etc. A map is made of rectangular tiles from a _tilesheet_, which are
# indexed starting from 1, increasing from left to right and then from top to bottom.
# The _grid_ is a 2D array of integers, each element representing the index on the _tilesheet_
# of the tile in that spot. These numbers are negative if they are solid walls, and
# positive otherwise. The tile map should be at the bottom of the sprite stack.
class tileset extends sprite
  constructor: (@tilesize, @tilesheet, @bgmusic, bgcolor, grid) ->
    @musicplaying = @bgmusic is 0
    serv.engine.bgcolor = bgcolor
    serv.engine.buffer.ctx.fillStyle = bgcolor
    super {solid: yes, bottom: yes, area: (new rect 0, 0, @tilesize.x, @tilesize.y), carea: (new rect 0, 0, @tilesize.x, @tilesize.y)}
    gridsize = new vect grid[0].length, grid.length
    @sheet = new surface new vect @tilesize.x*gridsize.x, @tilesize.y*gridsize.y
    width = @tilesheet.dims.x/@tilesize.x
    @grid = for i in [0...(gridsize.x + 2)] then for j in [0...(gridsize.y + 2)]
      if i is 0 or j is 0 or i is gridsize.x + 1 or j is gridsize.y + 1 then -1
      else grid[j - 1][i - 1]
    for i in [0...gridsize.x] then for j in [0...gridsize.y]
      srcy = Math.floor ((Math.abs @grid[1 + i][1 + j]) - 1)/width
      srcx = (Math.abs @grid[1 + i][1 + j]) - 1 - srcy*width
      @sheet.map @tilesheet, srcx, srcy, @tilesize.x, @tilesize.y, i, j

  # Play the background music if it's not already playing, and blit the map to the screen.
  step: (buff, offset) ->
    if not @musicplaying
      @musicplaying = yes
      serv.audio.maxvolume = yes
      @bgmusic.play()
    @bgmusic.step() if @bgmusic isnt 0
    buff.layer @sheet, new vect offset.x + buff.dims.x/2, offset.y + buff.dims.y/2

  # Check squares that are near the sprite. If any of them are negative,
  # and close enough to collide with, then run collision detection.
  collide: (spr) ->
    block = new vect (1 + Math.floor spr.area.p.x/@tilesize.x), 1 + Math.floor spr.area.p.y/@tilesize.y
    mid = new vect (1 + (Math.floor (spr.area.p.x + spr.area.s.x/2)/@tilesize.x) - block.x),
      1 + (Math.floor (spr.area.p.y + spr.area.s.y/2)/@tilesize.y) - block.y
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
