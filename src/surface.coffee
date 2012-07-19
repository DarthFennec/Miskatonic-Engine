# **A wrapper for HTML drawable surfaces.**
#
# - Abstract the distinction between an Image and a Canvas element.
# - Abstract the distinction between a Canvas element and its 2D context, like so:  
#   `surfaceobj1.drawImage surfaceobj2, 0, 0`  
#   rather than:  
#   `drawingcontext.drawImage somecanvas, 0, 0`
class surface
  constructor: (arg) ->
    if arg instanceof HTMLImageElement or arg instanceof HTMLCanvasElement
      @buf = arg
      @dims = new vect arg.width, arg.height
    else
      @buf = document.createElement "canvas"
      @size arg
    @ctx = @buf.getContext? "2d"

  # Set and/or get the size of the surface.
  size: (newsize) ->
    if newsize?
      @dims = newsize
      @buf.width = newsize.x
      @buf.height = newsize.y
    @dims

  # Clear/fill the surface, with transparency/color.
  clear: (opaque) ->
    if opaque then @ctx.fillRect 0, 0, @dims.x, @dims.y
    else @ctx.clearRect 0, 0, @dims.x, @dims.y

  # Wrapper for ctx.drawImage, supporting a wider range of
  # placement options. Round all placement options to the
  # nearest pixel, to keep HTML from interpolating pixel colors
  # and making the images blurry.
  drawImage: (src, d...) ->
    d[i] = Math.round v for v, i in d
    switch d.length
      when 0 then @ctx.drawImage src.buf, 0, 0
      when 2 then @ctx.drawImage src.buf, d[0], d[1]
      when 4 then @ctx.drawImage src.buf, d[0], d[1], d[2], d[3]
      when 6 then @ctx.drawImage src.buf, d[0], d[1], d[4], d[5], d[2], d[3], d[4], d[5]
      when 8 then @ctx.drawImage src.buf, d[0], d[1], d[2], d[3], d[4], d[5], d[6], d[7]

  # Like drawImage, but for tiles. Copy a tile from _src_ with specified size
  # at specified tile position, and put it at specified destination position,
  # given a destination tile size. Note that the tile is not resized to match the
  # destination tile size. If no size is given, the source size is used.
  map: (src, sx, sy, sw, sh, dx, dy, dw, dh) ->
    if not dh?
      dw = sw
      dh = sh
    @drawImage src, sx*sw, sy*sh, dx*dw, dy*dh, sw, sh

  # Copy a destination-sized area out of _src_, at _pos_.  
  # Trying to copy any part of an image that lies outside of its bounds
  # results in failure, in HTML5. This function checks for that case,
  # and takes steps to avoid it.
  layer: (src, pos) ->
    x = @dims.x/2 - pos.x
    y = @dims.y/2 - pos.y
    w = x + src.dims.x
    h = y + src.dims.y
    sx = if x > 0 then 0 else -x
    dx = if x < 0 then 0 else x
    sy = if y > 0 then 0 else -y
    dy = if y < 0 then 0 else y
    fw = (if w > @dims.x then @dims.x else w) - dx
    fh = (if h > @dims.y then @dims.y else h) - dy
    @drawImage src, sx, sy, dx, dy, fw, fh
