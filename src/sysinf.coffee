class systeminformation
  constructor: ->
    @basicsupport = Modernizr.canvas
    @rendershoggoth = Modernizr.webgl
    @cansaveload = Modernizr.localstorage
    if Modernizr.audio is no or (Modernizr.audio.mp3 is "" and (Modernizr.audio.ogg is "" or Modernizr.audio.wav is ""))
      @musicext = 0
      @soundext = 0
    else
      if Modernizr.audio.ogg is "probably" then @musicext = ".ogg"
      else if Modernizr.audio.mp3 is "probably" then @musicext = ".mp3"
      else if Modernizr.audio.ogg is "maybe" then @musicext = ".ogg"
      else @musicext = ".mp3"
      if Modernizr.audio.wav is "probably" then @soundext = ".wav"
      else if Modernizr.audio.mp3 is "probably" then @soundext = ".mp3"
      else if Modernizr.audio.wav is "maybe" then @soundext = ".wav"
      else @soundext = ".mp3"
