class filehandler
  constructor: -> @loadcount = 0

  loadimg: (imgurl) ->
    @loadcount = 0 if @loadcount < 0
    @loadcount += 1
    newimg = new Image
    newimg.onload = =>
      @loadcount -= 1
      @loadcount = 0 if @loadcount < 0
    newimg.src = imgurl
    newimg
