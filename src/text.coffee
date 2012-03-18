class texthandler
  constructor: (@charsheet, @chars, @localarea, @chararea, @avatararea) ->
    @text = new surface @localarea.size()
    @text.ctx.fillStyle = "#000000"
    @choice = new vect -1, -1
    @textbox = 0
    @currframe = 0

  initialize: (disp) ->
    @textbox = disp
    @currframe = 0
    @next()

  render: (buffer) ->
    buffer.layer @text, new vect "c", -100 if @textbox isnt 0
  
  input: (keys) ->
    if @textbox isnt 0
      if @choice.x isnt -1 and @choice.y isnt -1
        @choice.y -= 1 if keys.poll[0] is 1
        @choice.x -= 1 if keys.poll[1] is 1
        @choice.y += 1 if keys.poll[2] is 1
        @choice.x += 1 if keys.poll[3] is 1
        @choice.x = 0 if @choice.x < 0
        @choice.x = 1 if @choice.x > 1
        @choice.y = 0 if @choice.y < 0
        @choice.y = 2 if @choice.y > 2
        @drawchoice @textbox[@currframe]
      @next() if keys.poll[5] is 1
      yes
    else no

  next: ->
    choice = @choice.x + 2 * @choice.y
    if @choice.x isnt -1 and @choice.y isnt -1
      @choice.x = -1
      @choice.y = -1
      @textbox[0] @textbox, @currframe, choice
    if @textbox.length > @currframe + 1
      @currframe += 1
      if @textbox[@currframe][0] is ":"
        @choice.x = 0
        @choice.y = 0
        @drawchoice @textbox[@currframe]
      else @drawtext @textbox[@currframe]
    else @textbox = 0

  drawchoice: (texttodraw) ->
    finalstring = ""
    choices = texttodraw.substring(1).split ":", 6
    @choice.y = -1 + Math.ceil choices.length / 2 if Math.ceil(choices.length / 2) <= @choice.y
    choice = @choice.x + 2 * @choice.y
    if choice >= choices.length
      @choice.x -= 1
      choice -= 1
    choices[choice] = "> " + choices[choice] + " <"
    for currchoice in choices
      j = Math.floor (Math.floor(@chars.x / 2) - currchoice.length) / 2
      currchoice = " " + currchoice + " " for [1..j]
      currchoice += " " if currchoice.length % 2 isnt @chars.x / 2 % 2
      finalstring += currchoice
    @drawtext finalstring

  drawtext: (texttodraw) ->
    currline = 0
    currchar = 0
    @text.clear no
    @text.ctx.globalAlpha = 0.7
    @text.clear yes
    @text.ctx.globalAlpha = 1.0
    for chartodraw in texttodraw when currline < @chars.y
      sx = chartodraw.charCodeAt(0) - 16 * Math.floor chartodraw.charCodeAt(0) / 16
      sy = Math.floor chartodraw.charCodeAt(0) / 16
      dx = @localarea.x + currchar * (@chararea.x + @chararea.w)
      dy = @localarea.y + currline * (@chararea.y + @chararea.h)
      @text.map @charsheet, sx, sy, dx, dy, @chararea.w, @chararea.h
      currchar += 1
      if currchar >= @chars.x
        currchar = 0
        currline += 1
