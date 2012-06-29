class format
  constructor: ->
    @callbacks = []
    @filetype = []
    @filetype.push
      head: "img/"
      call: (url) ->
        newf = new surface new Image
        serv.load.loadcount.push newf
        newf.buf.onload = =>
          newf.dims.x = newf.buf.width
          newf.dims.y = newf.buf.height
          serv.formats.finish newf
        newf.buf.src = url + ".png"
        newf

  load: (file) ->
    type = file.substr 0, 4
    obrack = file.indexOf "["
    dash = file.indexOf "-", obrack
    cbrack = file.indexOf "]", dash
    if obrack isnt -1 and cbrack isnt -1 and dash isnt -1
      prefile = file.substring 0, obrack
      orange = parseInt (file.substring obrack + 1, dash), 10
      crange = parseInt (file.substring dash + 1, cbrack), 10
      postfile = file.substring cbrack + 1
      ret = for i in [orange..crange] then @load prefile + i + postfile
    else for l in @filetype when l.head is type then ret = l.call file
    ret

  finish: (newf) ->
    t = serv.load.loadcount.indexOf newf
    serv.load.loadcount.splice t, 1 if t isnt -1
    if serv.load.loadcount.length is 0
      tmp = @callbacks
      @callbacks = []
      ctx() for ctx in tmp
