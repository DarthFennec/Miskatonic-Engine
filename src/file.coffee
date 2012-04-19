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
        callback = @callback
        retval = @retval
        arg = @arg
        @callback = 0
        @arg = 0
        @retval = new Array
        callback retval, arg
    newimg.buf.src = imgurl
    newimg

  loadsnd: (sndurl) ->
    @loadcount = 0 if @loadcount < 0
    @loadcount += 1
    newsnd = new audio sndurl
    newsnd.data.addEventListener "canplaythrough", =>
      @loadcount -= 1
      @loadcount = 0 if @loadcount < 0
      if @callback isnt 0 and @loadcount is 0
        callback = @callback
        retval = @retval
        arg = @arg
        @callback = 0
        @arg = 0
        @retval = new Array
        callback retval, arg
    newsnd

  loadandrun: (filelist, callback, arg) ->
    @callback = callback
    @arg = arg
    for file, i in filelist
      @retval[i] = @loadimg file if "img/" is file.substr 0, 4
      @retval[i] = @loadsnd file if "snd/" is file.substr 0, 4
