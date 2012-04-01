class texthandler
  constructor: (@charsheet, @background, @chars, @chararea) ->
    @text = new surface @background.size()
    @choice = -1
    @textbox = 0
    @currframe = 0

  initialize: (disp) ->
    @textbox = disp
    @currframe = 0
    @next()

  render: (buffer) ->
    buffer.blit @text, (buffer.dims.x - @text.dims.x) / 2, buffer.dims.y - @text.dims.y - (buffer.dims.x - @text.dims.x) / 2 if @textbox isnt 0

  input: (keys) ->
    if @textbox isnt 0
      if @choice isnt -1
        if keys.poll[0] is 1 or keys.poll[2] is 1
          @choice += if @choice < 2 then 2 else -2
        if keys.poll[1] is 1 or keys.poll[3] is 1
          @choice += if @choice % 2 is 0 then 1 else -1
        @drawchoice @textbox[@currframe]
      @next() if keys.poll[5] is 1
      yes
    else no

  next: ->
    if @choice isnt -1
      @textbox[0] @textbox, @currframe, @choice
      @choice = -1
    if @textbox.length > @currframe + 1
      @currframe += 1
      if @textbox[@currframe][0] is ";"
        @choice = 0
        @drawchoice @textbox[@currframe]
      else @drawtext @textbox[@currframe]
    else @textbox = 0

  drawchoice: (texttodraw) ->
    choices = texttodraw.substring(1).split ";", 5
    finalstring = choices.shift()
    @choice -= 2 if choices.length is 2 and @choice > 1
    @choice -= 1 if choices.length is 3 and @choice is 3
    choices[@choice] = "> " + choices[@choice] + " <"
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
    @text.blit @background, 0, 0
    for chartodraw in texttodraw when currline < @chars.y
      if chartodraw isnt "#"
        sy = Math.floor chartodraw.charCodeAt(0) / 16
        sx = chartodraw.charCodeAt(0) - 16 * sy
        dy = @chararea.y + currline * (@chararea.y + @chararea.h)
        dx = @chararea.y + currchar * (@chararea.x + @chararea.w)
        @text.map @charsheet, sx, sy, dx, dy, @chararea.w, @chararea.h
        currchar += 1
      if currchar >= @chars.x or chartodraw is "#"
        currchar = 0
        currline += 1
