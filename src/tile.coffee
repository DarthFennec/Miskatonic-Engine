# **The tilemap sprite.**
#
# A [sprite](sprite.html) that represents the map, or scenery image: floors,
# walls, things that don't move, etc. A map is made of rectangular tiles from a
# _tilesheet_, which are indexed starting from 0, increasing from left to right
# and then from top to bottom. The _grid_ is a 2D array of integers, each
# element representing the index on the _tilesheet_ of the tile in that spot.
# The _coll_ is an array of collision indices, each representing the type of
# collision used for the tile of the same index: 0 for no collision, 1 for full
# rectangular collision, 2 for diagonal collision with a rising-sloped wall,
# and 3 for diagonal collision with a falling-sloped wall.
class tileset extends sprite
  constructor: (@tilesize, @tilesheet, @coll, @bgmusic, bgcolor, grid) ->
    @bgmusic.play() if @bgmusic isnt 0
    serv.engine.bgcolor = bgcolor
    serv.engine.buffer.ctx.fillStyle = bgcolor
    @coll.push 1
    super
      solid: yes
      bottom: yes
      area: (new rect 0, 0, @tilesize.x, @tilesize.y)
      carea: (new rect 0, 0, @tilesize.x, @tilesize.y)
    gridsize = new vect grid[0].length, grid.length
    @sheet = new surface new vect @tilesize.x*gridsize.x, @tilesize.y*gridsize.y
    width = @tilesheet.dims.x/@tilesize.x
    @grid = for i in [0...(gridsize.x + 2)] then for j in [0...(gridsize.y + 2)]
      if i is 0 or j is 0 or i is gridsize.x + 1 or j is gridsize.y + 1
        @coll.length - 1
      else grid[j - 1][i - 1]
    for i in [0...gridsize.x] then for j in [0...gridsize.y]
      srcy = Math.floor @grid[1 + i][1 + j]/width
      srcx = @grid[1 + i][1 + j] - srcy*width
      @sheet.map @tilesheet, srcx, srcy, @tilesize.x, @tilesize.y, i, j
    solve = (y, m, x, b, i) ->
      t = 1/(m*m + 1)
      (out, cx, px, dx) ->
        if cx[y] > m*cx[x] + b
          k = if i then new vect dx.x, px.y else px
          return if k[y] > m*k[x] + b
        else
          k = if i then new vect px.x, dx.y else dx
          return if k[y] <= m*k[x] + b
        tx = (k[x] + m*k[y] - m*b)*t
        ty = m*tx + b
        out[x] += tx - k[x]
        out[y] += ty - k[y]
    @solve = [
      solve "y", @tilesize.y/@tilesize.x, "x", -@tilesize.y, yes
      solve "y", -@tilesize.y/@tilesize.x, "x", @tilesize.y, no
      solve "y", @tilesize.y/@tilesize.x, "x", @tilesize.y, yes
      solve "y", -@tilesize.y/@tilesize.x, "x", 3*@tilesize.y, no
      solve "y", -@tilesize.y/@tilesize.x, "x", 2*@tilesize.y, no
      solve "y", @tilesize.y/@tilesize.x, "x", 0, yes
      solve "y", 0, "x", @tilesize.y, no
      solve "x", 0, "y", @tilesize.x, no ]

  # We don't need a step function, so do nothing.
  step: ->

  # Step the background music, and blit the map to the screen.
  render: (buff, offset) ->
    @bgmusic.step() if @bgmusic isnt 0
    buff.layer @sheet, new vect offset.x + buff.dims.x/2, offset.y + buff.dims.y/2

  # Check if the given sprite collides with its surrounding tiles.  
  # Find the four tiles that surround the sprite, and check their collision
  # types. Filter out the collisions that are too far away, and solve the rest.
  collide: (spr) -> loop
    walls = [no, no, no, no, no, no, no, no, no, no, no, no, no]
    pixel = new vect (spr.area.p.x + spr.carea.p.x)%@tilesize.x,
      (spr.area.p.y + spr.carea.p.y)%@tilesize.y
    dixel = new vect pixel.x - spr.carea.p.x + spr.carea.s.x,
      pixel.y - spr.carea.p.y + spr.carea.s.y
    center = new vect (pixel.x + dixel.x)/2, (pixel.y + dixel.y)/2
    block = new vect (1 + Math.floor (spr.area.p.x + spr.carea.p.x)/@tilesize.x),
      1 + Math.floor (spr.area.p.y + spr.carea.p.y)/@tilesize.y
    for n, i in [[1, 0], [0, 0], [0, 1], [1, 1]]
      switch @coll[@grid[block.x + n[0]][block.y + n[1]]]
        when 1
          walls[3*i] = not walls[3*i]
          walls[3*i + 3] = not walls[3*i + 3]
        when 2 then walls[3*i + 1] = yes
        when 3 then walls[3*i + 2] = yes
    walls[0] = walls[0] isnt walls.pop()
    if @tilesize.x < dixel.x and @tilesize.y < dixel.y
      best = val: 0, idx: -1
      dist = [dixel.x - @tilesize.x, @tilesize.y - pixel.y,
        @tilesize.x - pixel.x, dixel.y - @tilesize.y, dixel.x - @tilesize.x]
      for i in [0..3]
        diag = val: (Math.min dist[i], dist[i + 1]), idx: 3*i + i%2 + 1
        best = val: dist[i], idx: 3*i if walls[3*i] and dist[i] > best.val
        best = diag if walls[diag.idx] and diag.val > best.val
        walls[3*i] = walls[diag.idx] = no
      walls[best.idx] = yes
    else
      walls[0] = walls[9] = walls[10] = walls[11] = no
      walls[1] = walls[2] = walls[3] = no if @tilesize.x >= dixel.x
      walls[6] = walls[7] = walls[8] = no if @tilesize.y >= dixel.y
    collisions = [walls[2], walls[4], walls[8], walls[10],
      walls[1] or walls[7], walls[5] or walls[11],
      walls[0] or walls[6], walls[3] or walls[9]]
    offset = new vect 0, 0
    @solve[i] offset, center, pixel, dixel for i in [0..7] when collisions[i]
    spr.area.p.x += offset.x
    spr.area.p.y += offset.y
    return if offset.x is 0 and offset.y is 0
