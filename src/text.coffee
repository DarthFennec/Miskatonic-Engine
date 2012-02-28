class texthandler
  constructor: (@charsheet, @charsacross, @charsdown, @localarea, @chararea, @avatararea) ->
    @textbuff = document.createElement "canvas"
    @textbuff.width = @localarea.w
    @textbuff.height = @localarea.h
    @textctx = @textbuff.getContext "2d"
    @textctx.fillStyle = "#000000"
    @choicex = -1
    @choicey = -1
    @textbox = 0
    @currframe = 0

  initialize: (disp) ->
    @textbox = disp
    @currframe = 0
    @next()

  render: (buffer) ->
    buffer.blit @textbuff, "c", -100 if @textbox isnt 0
  
  input: (keys) ->
    if @textbox isnt 0
      if @choicex isnt -1 and @choicey isnt -1
        @choicey -= 1 if keys.poll[0] is 1
        @choicex -= 1 if keys.poll[1] is 1
        @choicey += 1 if keys.poll[2] is 1
        @choicex += 1 if keys.poll[3] is 1
        @choicex = 0 if @choicex < 0
        @choicex = 1 if @choicex > 1
        @choicey = 0 if @choicey < 0
        @choicey = 2 if @choicey > 2
        @drawchoice @textbox[@currframe]
      @next() if keys.poll[5] is 1
      true
    else false

  next: ->
    choice = @choicex + 2 * @choicey
    if @choicex isnt -1 and @choicey isnt -1
      @choicex = -1
      @choicey = -1
      @textbox[0] @currframe, choice
    if @textbox.length > @currframe + 1
      @currframe += 1
      if @textbox[@currframe][0] is ":"
        @choicex = 0
        @choicey = 0
        @drawchoice @textbox[@currframe]
      else @drawtext @textbox[@currframe]
    else @textbox = 0

  drawchoice: (texttodraw) ->
    finalstring = ""
    choices = texttodraw.substring(1).split ":", 6
    @choicey = -1 + Math.ceil choices.length / 2 if Math.ceil(choices.length / 2) <= @choicey
    choice = @choicex + 2 * @choicey
    if choice >= choices.length
      @choicex -= 1
      choice -= 1
    choices[choice] = "> " + choices[choice] + " <"
    for currchoice in choices
      j = Math.floor (Math.floor(@charsacross / 2) - currchoice.length) / 2
      currchoice = " " + currchoice + " " for [1..j]
      currchoice += " " if currchoice.length % 2 isnt @charsacross / 2 % 2
      finalstring += currchoice
    @drawtext finalstring

  drawtext: (texttodraw) ->
    currline = 0
    currchar = 0
    @textctx.clearRect 0, 0, @localarea.w, @localarea.h
    @textctx.globalAlpha = 0.7
    @textctx.fillRect 0, 0, @localarea.w, @localarea.h
    @textctx.globalAlpha = 1.0
    for chartodraw in texttodraw when currline < @charsdown
      sx = @chararea.w * (chartodraw.charCodeAt(0) - 16 * Math.floor chartodraw.charCodeAt(0) / 16)
      sy = @chararea.h * Math.floor chartodraw.charCodeAt(0) / 16
      dx = @localarea.x + currchar * (@chararea.x + @chararea.w)
      dy = @localarea.y + currline * (@chararea.y + @chararea.h)
      @textctx.drawImage @charsheet, sx, sy, @chararea.w, @chararea.h, dx, dy, @chararea.w, @chararea.h
      currchar += 1
      if currchar >= @charsacross
        currchar = 0
        currline += 1
