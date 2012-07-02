class systeminformation
  constructor: ->
    @basicsupport = Modernizr.canvas
    @rendershoggoth = Modernizr.webgl
    @cansaveload = Modernizr.localstorage
    if Modernizr.audio is no or (Modernizr.audio.mp3 is "" and Modernizr.audio.ogg is "")
      @soundext = 0
    else
      if Modernizr.audio.ogg is "probably" then @soundext = ".ogg"
      else if Modernizr.audio.mp3 is "probably" then @soundext = ".mp3"
      else if Modernizr.audio.ogg is "maybe" then @soundext = ".ogg"
      else @soundext = ".mp3"
