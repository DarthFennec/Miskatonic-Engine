class cutscenehandler
  constructor: (@charsheet, @background, @chars, @chararea) ->
    @text = new surface @background.size()
    @frames = 0
    @choice = -1

  initialize: (newscene) ->
    @frames = newscene
    @frame = {len: 0, elem: -1, txt: -1, overlay: -1, snd: -1, next: 0}
    @time = 0
    @next()

  render: (buffer) ->
    if @frames isnt 0
      if @time > @frame.len > 0 then @next()
      if @frame.snd isnt -1 then @frame.snd.step()
      if @frame.txt isnt -1 then buffer.drawImage @text, (buffer.dims.x - @text.dims.x)/2, buffer.dims.y - @text.dims.y - (buffer.dims.x - @text.dims.x)/2
      if @frame.overlay isnt -1 then if @frame.overlay.render buffer then @frame.overlay = -1
      if @frame.elem isnt -1 then for p in @frame.elem then p.render buffer
      if @frame.elem isnt -1 or @frame.overlay isnt -1 then buffer.ctx.globalAlpha = 1.0
      @time += 1
      @frame.elem isnt -1
    else no

  input: (keys) ->
    if @frames isnt 0
      if @frame.len is 0 and keys.act.poll is 1 then @next()
      if keys.act.poll isnt 1 and @choice isnt -1
        @choice += (if @choice < 2 then 2 else -2) if keys.up.poll is 1 or keys.down.poll is 1
        @choice += (if @choice % 2 is 0 then 1 else -1) if keys.left.poll is 1 or keys.right.poll is 1
        @drawchoice @frame.txt
      yes
    else no

  next: ->
    nxt = @frame.next
    nxt = nxt @choice if "function" is typeof nxt
    @choice = -1
    if nxt isnt -1
      @frame[n] = @frames[nxt][n] for n of @frames[nxt]
      @frame.next += 1 if @frame.next is nxt
      @time = 0
      if @frame.txt isnt -1
        if @frame.txt[0] is ";"
          @choice = 0
          @drawchoice @frame.txt
        else @drawtext @frame.txt
    else @frames = 0

  drawchoice: (texttodraw) ->
    choices = (texttodraw.substring 1).split ";", 5
    finalstring = choices.shift()
    @choice -= 2 if choices.length is 2 and @choice > 1
    @choice -= 1 if choices.length is 3 and @choice is 3
    choices[@choice] = "> " + choices[@choice] + " <"
    for currchoice in choices
      j = Math.floor ((Math.floor @chars.s.x/2) - currchoice.length)/2
      currchoice = " " + currchoice + " " for [1..j]
      currchoice += " " if currchoice.length%2 isnt (@chars.s.x/2)%2
      finalstring += currchoice
    @drawtext finalstring

  drawtext: (texttodraw) ->
    currline = 0
    currchar = 0
    @text.clear no
    @text.drawImage @background
    for chartodraw in texttodraw when currline < @chars.s.y
      if chartodraw isnt "#"
        sy = Math.floor (chartodraw.charCodeAt 0)/16
        sx = (chartodraw.charCodeAt 0) - 16*sy
        @text.map @charsheet, sx, sy, @chararea.s.x, @chararea.s.y, @chars.p.x + currchar, @chars.p.y + currline, @chararea.p.x, @chararea.p.y
        currchar += 1
      if currchar >= @chars.s.x or chartodraw is "#"
        currchar = 0
        currline += 1

class gradient
  constructor: (@color, @duration, @type) ->
    @time = 0

  render: (buffer) ->
    serv.audio.volume = if @type then 1 - @time/@duration else @time/@duration
    newalpha = if @type then @time/@duration else 1 - @time/@duration
    buffer.ctx.globalAlpha = newalpha
    buffer.ctx.fillStyle = @color
    buffer.clear yes
    buffer.ctx.globalAlpha = 1.0
    buffer.ctx.fillStyle = "#000000"
    @time += 1
    @time > @duration

class particle
  constructor: (@image, @callback) ->
    @time = 0

  render: (buffer) ->
    info = @callback @time
    buffer.ctx.globalAlpha = info[3]
    buffer.drawImage @image, info[0], info[1], info[2]*@image.dims.x, info[2]*@image.dims.y
    @time += 1

  fadeform: (t, cycle) -> 0.5 + 0.5*Math.cos t*Math.PI/cycle

  zoomform: (xzoom, yzoom, x, y, z, a) -> [x - xzoom*z, y - yzoom*z, z, a]

class sound
  constructor: (@track) ->

  step: -> @track?.newset = yes

class music
  constructor: (@track, initvol, @loop) ->
    @track?.fade initvol
    @track?.play()
    @track?.ii = window.setInterval (=> @track.play()), 1000*@loop

  step: -> @track?.newset = yes
