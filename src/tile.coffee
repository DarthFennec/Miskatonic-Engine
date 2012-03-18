class tileset extends sprite
  constructor: (@tilesize, @tilesheet, @gridsize, @grid) ->
    newsheet = new surface new vect @tilesize.x * @gridsize.x, @tilesize.y * @gridsize.y
    width = @tilesheet.dims.x / @tilesize.x
    for i in [0...@gridsize.x] then for j in [0...@gridsize.y]
      srcy = Math.floor @grid[i + j * @gridsize.x] / width
      srcx = @grid[i + j * @gridsize.x] - srcy * width
      newsheet.map @tilesheet, srcx, srcy, i * @tilesize.x, j * @tilesize.y, @tilesize.x, @tilesize.y
    super { sheet : newsheet }

  step: (buff, offset) -> buff.layer @sheet, new vect(offset.x + buff.dims.x / 2, offset.y + buff.dims.y / 2)
