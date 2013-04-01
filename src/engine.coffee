# **The central engine structure.**
#
# - Contain the render stack, which is a stack of renderable layers, organized by z order.
# - Pass i/o (keyboard and render) events to each layer in the stack, in order.
# - Any renderable layer can "block" all layers below it, by returning _true_.
# - Keep track of key binding data and the screen and renderbuffer surfaces.
class engine
  constructor: (@rends, @screen, keymap) ->
    @keys = {}
    for key of keymap then @keys[key] = val: keymap[key], poll: 0, state: 0
    @bgcolor = "#000000"
    @buffer = new surface new vect 0, 0
    @resize @screen.size()
    serv.scene.initialize 0, 0
    serv.reset()
    serv.scene.initchild 0

  # Change the size of the _screen_ and _buffer_ canvases.  
  # Used during construction and when the aspect ratio is changed in the settings menu.
  # Since setting the _width_ of a canvas resets its state machine, the state must be reinitialized here:
  #
  # - _bgcolor_ is the color beyond the edge of the map.
  # - The _line_ and _stroke_ values are for drawing the loading bar.
  # - Frames are rendered from the top down to support stack blocking.
  resize: (s) ->
    serv.global.s = [s.x, s.y]
    t = @buffer.size()
    if s.x isnt t.x or s.y isnt t.y
      serv.screen.resize "display", s
      @screen.size s
      @buffer.size s
      @buffer.ctx.fillStyle = @bgcolor
      @buffer.ctx.strokeStyle = "#ffffff"
      @buffer.ctx.lineWidth = 25
      @buffer.ctx.lineCap = "round"
      @buffer.ctx.globalCompositeOperation = "destination-over"

  # Intercept keyboard events and pass them down the stack.  
  # Bind to the _keyUp_ and _keyDown_ events. Find the keycode in the list,
  # update that key's poll and state values, and inform the stack.
  # The stack is called from the top down, and any layer has the option to
  # block the remainder of the stack from receiving the event.  
  # _Poll_ represents the keyboard state change that threw the event,
  # and _state_ represents the current state of any given key.
  input: (block, code, data) ->
    importantkey = no
    for k of @keys
      @keys[k].poll = 0
      for keycode in @keys[k].val when code is keycode
        importantkey = yes
        @keys[k].poll = data
      @keys[k].state = 1 if @keys[k].poll is 1
      @keys[k].state = 0 if @keys[k].poll is -1
    if importantkey
      for rend in @rends when rend.input @keys then break
      block()
    no

  # Step and rerender the stack at regular intervals.  
  # Bind with _setInterval_ or _requestAnimationFrame_, should run once per frame.
  # Blit the buffer to the screen, clear the buffer, and draw the render stack.
  # The stack is drawn from the top down, and any layer has the option to
  # block the remainder of the stack from rendering.
  step: ->
    @screen.drawImage @buffer
    @buffer.clear no
    for rend in @rends when rend.render @buffer then break
    @buffer.clear yes
    no
