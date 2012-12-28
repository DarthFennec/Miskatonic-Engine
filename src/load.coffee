# **The loading screen.**
#
# In a non-blocking loading environment such as a web browser, a resource
# might potentially be used before it's fully loaded. This class attempts
# to counteract this problem.  
# External resources should be added to the list, and should be set to remove
# themselves from the list once they finish loading. This layer blocks the
# stack while objects remain in the list, and displays a progress bar showing
# the number of resources already loaded out of the total number of resources.  
# Also, keep track of a list of callback functions to run after any given collection
# of resources has finished loading. Keep track of a list of filetypes, so
# the engine can always figure out how to load any particular file. Also,
# provide helper functions to make resource loading easier.
class loader
  constructor: ->
    @maxload = 0
    @loadcount = []
    @callbacks = []
    @filetype = []
    @filetype.push
      head: "img/"
      call: (url) ->
        newf = new surface new Image
        serv.load.loadcount.push newf
        newf.buf.onerror = -> serv.load.err newf, url + ".png"
        newf.buf.onload = ->
          newf.dims.x = newf.buf.width
          newf.dims.y = newf.buf.height
          serv.load.finish newf
        newf.buf.src = url + ".png"
        newf

  # Draw a loading bar on the screen.  
  # Block if something is being loaded.
  render: (buffer) ->
    if @loadcount.length isnt 0
      @maxload = @loadcount.length if @maxload < @loadcount.length
      loadwidth = (@maxload - @loadcount.length)*(buffer.dims.x - 60)/@maxload
      buffer.ctx.beginPath()
      buffer.ctx.moveTo 30, buffer.dims.y - 30
      buffer.ctx.lineTo loadwidth + 30, buffer.dims.y - 30
      buffer.ctx.stroke()
    else @maxload = 0
    @loadcount.length isnt 0

  # Block if something is being loaded.
  input: (keys) -> @loadcount.length isnt 0

  # Find the correct filetype and load the file from the server.
  # Optionally, specify a range of files to load.
  load: (file) ->
    type = file.substr 0, 4
    matched = file.match /(.*)(?:\[)([0-9]+)(?:-)([0-9]+)(?:])(.*)/
    if matched? then ret = for i in [(parseInt matched[2], 10)..(parseInt matched[3], 10)] then @load matched[1] + i + matched[4]
    else for l in @filetype when l.head is type then ret = l.call file
    ret

  # Call when there is an error in loading a file.
  err: (newf, fname) ->
    serv.screen.message 2, "Error: failed to load " + fname, 10
    @finish newf

  # Call when a file is finished loading. Removes itself from the list,
  # checks if it's the last one, and if it is, run all the callbacks.
  finish: (newf) ->
    t = @loadcount.indexOf newf
    @loadcount.splice t, 1 if t isnt -1
    if @loadcount.length is 0
      tmp = @callbacks
      @callbacks = []
      ctx() for ctx in tmp
