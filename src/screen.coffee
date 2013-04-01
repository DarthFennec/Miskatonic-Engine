# **An interface for the screen, on a document level.**
#
# Abstract useful data and methods concerning the document, such as messaging,
# sizing and altering the screen, and getting compatibility data.
class screenhandler
  constructor: (elems) ->
    @elem = {}
    @elem[e] = document.getElementById e for e in elems

  # Replace an element with the element inside it.
  unwrap: (i) -> @elem[i].parentNode.replaceChild @elem[i].firstChild, @elem[i]

  # Set a new size for an element via CSS.
  resize: (i, s) ->
    @elem[i].style.width = s.x + "px"
    @elem[i].style.height = s.y + "px"

  # Simulate a fullscreen mode via a CSS class.
  fullscreen: (i, k) -> @elem[i].className = if k then "fullscreen" else ""

  # Display a message as a child of an element, which disappears in time.
  message: (i, string, time) ->
    msg = document.createElement "div"
    msg.innerText = string
    @elem[i].appendChild msg
    window.setTimeout (-> @elem[i].removeChild msg), 1000*time

  # Gather and format data about the client system,
  # and the extent of HTML5 support on the client browser, including:
  #
  # - Basic support for canvases.
  # - WebGL support.
  # - LocalStorage support for savestates.
  # - Audio format support.
  #
  # Use Modernizr to test for support because it is simple and well-tested.
  getsysteminfo: ->
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
