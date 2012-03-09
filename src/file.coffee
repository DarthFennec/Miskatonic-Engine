class filehandler
  constructor: -> @loadcount = 0

  loadimg: (imgurl) ->
    @loadcount = 0 if @loadcount < 0
    @loadcount += 1
    newimg = new surface new Image
    newimg.buf.onload = =>
      newimg.size new vect newimg.buf.width, newimg.buf.height
      @loadcount -= 1
      @loadcount = 0 if @loadcount < 0
    newimg.buf.src = imgurl
    newimg
