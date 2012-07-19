# **Helper class for loading resources.**
#
# TODO: Combine this class with the loading screen class.  
# Keep track of a list of callback functions to run after any given collection
# of resources has finished loading. Keep track of a list of filetypes, so
# the engine can always figure out how to load any particular file. Also,
# provide helper functions to make resource loading easier.
class format
  constructor: ->
    @callbacks = []
    @filetype = []
    @filetype.push
      head: "img/"
      call: (url) ->
        newf = new surface new Image
        serv.load.loadcount.push newf
        newf.buf.onerror = -> serv.formats.err newf, url + ".png"
        newf.buf.onload = ->
          newf.dims.x = newf.buf.width
          newf.dims.y = newf.buf.height
          serv.formats.finish newf
        newf.buf.src = url + ".png"
        newf

  # Find the correct filetype and load the file from the server.
  # Optionally, specify a range of files to load.
  load: (file) ->
    type = file.substr 0, 4
    obrack = file.indexOf "["
    dash = file.indexOf "-", obrack
    cbrack = file.indexOf "]", dash
    if obrack isnt -1 and dash isnt -1 and cbrack isnt -1
      prefile = file.substring 0, obrack
      orange = parseInt (file.substring 1 + obrack, dash), 10
      crange = parseInt (file.substring 1 + dash, cbrack), 10
      postfile = file.substring 1 + cbrack
      ret = for i in [orange..crange] then @load prefile + i + postfile
    else for l in @filetype when l.head is type then ret = l.call file
    ret

  # Call when there is an error in loading a file.
  err: (newf, fname) ->
    window.alert "Error: failed to load " + fname.substring 1 + fname.lastIndexOf "/"
    @finish newf

  # Call when a file is finished loading. Removes itself from the list,
  # checks if it's the last one, and if it is, run all the callbacks.
  finish: (newf) ->
    t = serv.load.loadcount.indexOf newf
    serv.load.loadcount.splice t, 1 if t isnt -1
    if serv.load.loadcount.length is 0
      tmp = @callbacks
      @callbacks = []
      ctx() for ctx in tmp
