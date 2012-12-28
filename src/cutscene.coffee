# **The cutscene/dialogue/etc system.**
#
# This class is built to handle various kinds of cutscenes and cutscene-like
# scenes: particularly, this class works with sequential scenes. Cinematic
# cutscenes, dialogues, graphics effects, etc, are handled by this class.
#
# A cutscene is simply a list of objects, where each object represents a
# major change in the scene. The scene starts empty, and the first object
# in the list is applied. This frame object might contain various data about
# what the scene should look like: a new sound to play, new dialogue to display,
# or new elements to put in the scene. It might also contain a length (the number
# of frames to wait until the next frame object is applied, or 0 to wait for the
# action key to be pressed instead), and a _next_ value (the array index of
# the next frame object to be applied, or -1 to end the cutscene, or a function
# that returns said value).
#
# Only the changes specified in a frame object will be applied; the rest of
# the scene will remain the same (except in the case of the _next_ value,
# which will apply the succeeding frame if left unspecified). To remove
# something from the cutscene, -1 should be applied.
class cutscenehandler
  constructor: (@charsheet, @background, @chars, @chararea, @charpos, @nexttxtsnd, @lasttxtsnd) ->
    @text = new surface @background.size()
    @frames = 0
    @choice = -1

  # Set up a new cutscene, default the current frame, and run it.
  initialize: (@frames) ->
    @frame = {len: 0, elem: -1, txt: -1, overlay: -1, snd: -1, next: 0}
    @framestate = {len: -1, elem: -1, txt: -1, overlay: -1, snd: -1, next: -1}
    @time = 0
    @next()

  # Check through every element of the frame, and render it to the screen.
  # If the frame duration has been reached, apply the next frame.
  render: (buffer) ->
    @nexttxtsnd.step()
    @lasttxtsnd.step()
    if @frames isnt 0
      if @time > @frame.len > 0 then @next()
      if @frame.snd isnt -1 then @frame.snd.step()
      if @frame.txt isnt -1 then buffer.drawImage @text, @charpos.x + (buffer.dims.x - @text.dims.x)/2, @charpos.y + (buffer.dims.y - @text.dims.y)/2
      if @frame.overlay isnt -1 then if @frame.overlay.render buffer then @frame.overlay = -1
      if @frame.elem isnt -1 then for p in @frame.elem then p.render buffer
      if @frame.elem isnt -1 or @frame.overlay isnt -1 then buffer.ctx.globalAlpha = 1.0
      @time += 1 if @frame.len > 0
      @frame.elem isnt -1
    else no

  # If waiting for the action key, and it gets pressed, apply the next frame.
  # If displaying a choice box and an arrow key gets pressed, change the
  # current choice and prerender the new box.
  input: (keys) ->
    if @frames isnt 0
      if @frame.len is 0 and keys.act.poll is 1 then @next()
      if keys.act.poll isnt 1 and @choice isnt -1
        @choice += (if @choice < 2 then 2 else -2) if keys.up.poll is 1 or keys.down.poll is 1
        @choice += (if @choice%2 is 0 then 1 else -1) if keys.left.poll is 1 or keys.right.poll is 1
        @drawchoice @frame.txt
      yes
    else no

  # Advance to the next frame. Decide which frame to use, make the appropriate
  # changes from the current frame, restart the clock, tell any sounds to play,
  # and tell any textboxes to prerender themselves.
  next: ->
    nxt = @frame.next
    nxt = nxt @choice if "function" is typeof nxt
    @choice = -1
    if nxt isnt -1
      if @frame.txt isnt @frames[nxt].txt
        if @frames[nxt].txt is -1 then @lasttxtsnd.play()
        else if @frame.txt isnt -1 then @nexttxtsnd.play()
      @frames[nxt].snd?.play?() if @frame.snd isnt @frames[nxt].snd
      for n of @frames[nxt]
        @frame[n] = @frames[nxt][n]
        @framestate[n] = nxt
      @frame.next += 1 if @frame.next is nxt
      @time = 0
      if @frame.txt isnt -1
        if @frame.txt[0] is "\t"
          @choice = 0
          @drawchoice @frame.txt
        else @drawtext @frame.txt
    else
      @lasttxtsnd.play() if @frame.txt isnt -1
      @frames = 0

  # Build a text string to draw, given a tab-delimited choice string.
  # A choicebox is in the form `;t;c1;c2[;c3[;c4]]`, where _cX_ are the choices,
  # and _t_ is the text that comes before them. Add a marker around the current
  # choice, and space the choices evenly.
  drawchoice: (texttodraw) ->
    choices = (texttodraw.substring 1).split "\t", 5
    finalstring = choices.shift()
    finalstring += "\n" if finalstring isnt ""
    @choice -= 2 if choices.length is 2 and @choice > 1
    @choice -= 1 if choices.length is 3 and @choice is 3
    choices[@choice] = "> " + choices[@choice] + " <"
    for currchoice in choices
      j = Math.floor ((Math.floor @chars.s.x/2) - currchoice.length)/2
      currchoice = " " + currchoice + " " for [1..j]
      currchoice += " " if currchoice.length%2 isnt (@chars.s.x/2)%2
      finalstring += currchoice
    @drawtext finalstring

  # Draw the textbox. Copy over the background, go through the string,
  # and copy over each character from the font sheet.
  drawtext: (texttodraw) ->
    currline = 0
    currchar = 0
    @text.clear no
    @text.drawImage @background
    for chartodraw in texttodraw when currline < @chars.s.y
      if chartodraw isnt "\n" and chartodraw isnt " "
        sy = Math.floor (chartodraw.charCodeAt 0)/16
        sx = (chartodraw.charCodeAt 0) - 16*sy
        @text.map @charsheet, sx, sy, @chararea.s.x, @chararea.s.y, @chars.p.x + currchar, @chars.p.y + currline, @chararea.p.x, @chararea.p.y
      currchar += 1
      if currchar >= @chars.s.x or chartodraw is "\n"
        currchar = 0
        currline += 1

  # Gather and return data to be saved.
  savestate: -> if @frames isnt 0
    choice: @choice
    time: @time
    frame: @framestate
    state: do =>
      ret = {}
      for n of @frame
        if @frame[n] instanceof Array then ret[n] = (k.savestate?() for k in @frame[n])
        else ret[n] = @frame[n].savestate?()
      ret

  # Distribute saved data into the sprite list.
  loadstate: (state) -> if @frames isnt 0 and state?
    @choice = state.choice
    @time = state.time
    @framestate = state.frame
    @frame[n] = @frames[@framestate[n]][n] for n of @frame when @framestate[n] isnt -1
    for n of @frame
      if @frame[n] instanceof Array then for k, i in @frame[n] then k.loadstate? state.state[n][i]
      else @frame[n].loadstate? state.state[n]

# **A color fade overlay element.**
#
# The simplest overlay element. Fade to or from a certain color over a given time.
class gradient
  constructor: (@color, @duration, @type) -> @time = 0

  # Come up with a fade amount, set the audio volume, and render to the screen.
  render: (buffer) ->
    serv.audio.volume = if @type then 1 - @time/@duration else @time/@duration
    newalpha = if @type then @time/@duration else 1 - @time/@duration
    buffer.ctx.globalAlpha = newalpha
    buffer.ctx.fillStyle = @color
    buffer.clear yes
    buffer.ctx.globalAlpha = 1.0
    buffer.ctx.fillStyle = serv.engine.bgcolor
    @time += 1
    @time > @duration

  # Gather and return data to be saved.
  savestate: -> @time

  # Distribute saved data.
  loadstate: (state) -> @time = state

# **An image cutscene element.**
#
# The most common cutscene element type, this is a simple still image. It can
# be controlled per-frame by a callback function, which can determine the
# position, size, and alpha of the particle.
class particle
  constructor: (@image, @callback) -> @time = 0

  # Run the callback, draw the results, and increment the frame counter.
  render: (buffer) ->
    info = @callback @time
    buffer.ctx.globalAlpha = info[3]
    dx = info[0] + (buffer.dims.x - @image.dims.x*info[2])/2
    dy = info[1] + (buffer.dims.y - @image.dims.y*info[2])/2
    buffer.drawImage @image, dx, dy, info[2]*@image.dims.x, info[2]*@image.dims.y
    @time = info[4]

  # Gather and return data to be saved.
  savestate: -> @time

  # Distribute saved data.
  loadstate: (state) -> @time = state

  # Helper function for sinusoidal fades.
  fadeform: (t, cycle) -> 0.5 + 0.5*Math.cos t*Math.PI/cycle
