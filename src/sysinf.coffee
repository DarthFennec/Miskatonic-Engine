# **System compatibility information selector.**
#
# Gather and format data about the client system,
# and the extent of HTML5 support on the client browser, including:
#
# - Basic support for canvases.
# - WebGL support.
# - LocalStorage support for savestates.
# - Audio format support.
#
# Use Modernizr to test for support because it is simple and well-tested.
class systeminformation
  constructor: ->
    @basicsupport = Modernizr.canvas
    @render3D = Modernizr.webgl
    @cansaveload = Modernizr.localstorage
    if Modernizr.audio is no or (Modernizr.audio.mp3 is "" and Modernizr.audio.ogg is "")
      @soundext = 0
    else
      if Modernizr.audio.ogg is "probably" then @soundext = ".ogg"
      else if Modernizr.audio.mp3 is "probably" then @soundext = ".mp3"
      else if Modernizr.audio.ogg is "maybe" then @soundext = ".ogg"
      else @soundext = ".mp3"
