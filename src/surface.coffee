class surface
  constructor: (arg) ->
    if arg instanceof HTMLImageElement or arg instanceof HTMLCanvasElement
      @buf = arg
      @dims = new vect arg.width, arg.height
    else
      @buf = document.createElement "canvas"
      @size arg
    @ctx = @buf.getContext? "2d"

  size: (newsize) ->
    if newsize?
      @dims = newsize
      @buf.width = newsize.x
      @buf.height = newsize.y
    @dims

  clear: (color) ->
    if color then @ctx.fillRect 0, 0, @dims.x, @dims.y
    else @ctx.clearRect 0, 0, @dims.x, @dims.y

  blit: (src, dx, dy) -> @ctx.drawImage src.buf, dx, dy

  map: (src, sx, sy, dx, dy, w, h) -> @ctx.drawImage src.buf, sx * w, sy * h, w, h, Math.round(dx), Math.round(dy), w, h

  draw: (src, info) ->
    @ctx.globalAlpha = info[3]
    @ctx.drawImage src.buf, Math.round(info[0]), Math.round(info[1]), Math.round(info[2] * src.dims.x), Math.round(info[2] * src.dims.y)

  layer: (src, pos) ->
    x = @dims.x / 2 - pos.x
    y = @dims.y / 2 - pos.y
    w = x + src.dims.x
    h = y + src.dims.y
    sx = if x > 0 then 0 else -x
    dx = if x < 0 then 0 else x
    sy = if y > 0 then 0 else -y
    dy = if y < 0 then 0 else y
    fw = (if w > @dims.x then @dims.x else w) - dx
    fh = (if h > @dims.y then @dims.y else h) - dy
    @ctx.drawImage src.buf, Math.round(sx), Math.round(sy), Math.round(fw), Math.round(fh), Math.round(dx), Math.round(dy), Math.round(fw), Math.round(fh)
