class camera
  constructor: (@dest, @width, @height) ->

  blit: (src, originx, originy) ->
    originx = src.width / 2 if originx is "c"
    originy = src.height / 2 if originy is "c"
    x = @width / 2 - originx
    y = @height / 2 - originy
    w = x + src.width
    h = y + src.height
    sx = if x > 0 then 0 else -x
    dx = if x < 0 then 0 else x
    sy = if y > 0 then 0 else -y
    dy = if y < 0 then 0 else y
    fw = (if w > @width then @width else w) - dx
    fh = (if h > @height then @height else h) - dy
    @dest.drawImage src, sx, sy, fw, fh, dx, dy, fw, fh
