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

  clear: (opaque) ->
    if opaque then @ctx.fillRect 0, 0, @dims.x, @dims.y
    else @ctx.clearRect 0, 0, @dims.x, @dims.y

  drawImage: (src, d...) ->
    d[i] = Math.round v for v, i in d
    switch d.length
      when 0 then @ctx.drawImage src.buf, 0, 0
      when 2 then @ctx.drawImage src.buf, d[0], d[1]
      when 4 then @ctx.drawImage src.buf, d[0], d[1], d[2], d[3]
      when 6 then @ctx.drawImage src.buf, d[0], d[1], d[4], d[5], d[2], d[3], d[4], d[5]
      when 8 then @ctx.drawImage src.buf, d[0], d[1], d[2], d[3], d[4], d[5], d[6], d[7]

  map: (src, sx, sy, sw, sh, dx, dy, dw, dh) ->
    if dh? then @drawImage src, sx*sw, sy*sh, dx*dw, dy*dh, sw, sh
    else @drawImage src, sx*sw, sy*sh, dx*sw, dy*sh, sw, sh

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
    @drawImage src, sx, sy, dx, dy, fw, fh
