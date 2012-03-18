class filehandler
  constructor: ->
    @loadcount = 0
    @callback = 0
    @arg = 0
    @retval = new Array

  loadimg: (imgurl) ->
    @loadcount = 0 if @loadcount < 0
    @loadcount += 1
    newimg = new surface new Image
    newimg.buf.onload = =>
      newimg.size new vect newimg.buf.width, newimg.buf.height
      @loadcount -= 1
      @loadcount = 0 if @loadcount < 0
      if @callback isnt 0 and @loadcount is 0
        @callback @retval, @arg
        @callback = 0
        @arg = 0
        @retval = new Array
    newimg.buf.src = imgurl
    newimg

  loadandrun: (imglist, callback, arg) ->
    @retval[i] = @loadimg img for img, i in imglist
    @callback = callback
    @arg = arg
