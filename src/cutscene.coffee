class cutscenehandler
  constructor: (@text) ->
    @buffer = document.createElement "canvas"
    @bufferctx = @buffer.getContext "2d"
    @currscene = 0
    @currclip = 0
    @currframe = 0

  initialize: (loader, newscene) ->
    @currclip = 0
    @currframe = 0
    @currscene = newscene
    @buffer.width = newscene.w
    @buffer.height = newscene.h
    shorten = @currscene.clip[@currclip].text
    @text.initialize shorten if shorten isnt -1 and shorten isnt 0
    for clip in @currscene.clip then for particle in clip.particle
      particle.image = loader.loadimg particle.imageurl if particle.image is 0

  render: (buffer) ->
    if @currscene isnt 0
      if @currframe > @currscene.clip[@currclip].duration > 0
        @currframe = 0
        @currclip += 1
        if @currclip < @currscene.clip.length
          if @currscene.clip[@currclip].text is -1 then @text.show = 0
          else if @currscene.clip[@currclip].text is 0 then @text.next()
          else @text.display @currscene.clip[@currclip].text
        else
          @text.next()
          @currscene = 0
          return
      @bufferctx.clearRect 0, 0, @buffer.width, @buffer.height
      for particle in @currscene.clip[@currclip].particle
        currsrc = particle.image
        info = particle.parametric @currframe
        @bufferctx.globalAlpha = info[3]
        @bufferctx.drawImage currsrc, info[0], info[1], info[2] * currsrc.width, info[2] * currsrc.height
      @bufferctx.globalAlpha = 1.0
      @currframe += 1
      @text.render buffer
      buffer.blit @buffer, "c", "c"
      true
    else false

  input: (keys) ->
    if @currscene isnt 0
      @text.input keys if keys.poll[5] isnt 1
      if @currscene.clip[@currclip].duration < 1 and keys.poll[5] is 1
        @currframe = 0
        @currclip += 1
        if @currclip < @currscene.clip.length
          if @currscene.clip[@currclip].text is -1 then @text.show = 0
          else if @currscene.clip[@currclip].text is 0 then @text.next()
          else @text.display @currscene.clip[@currclip].text
        else
          @text.next()
          @currscene = 0
      true
    else false

class cutscene
  constructor: (@w, @h, @clip) ->

class clip
  constructor: (@duration, @text, @particle) ->

class particle
  constructor: (@imageurl, @parametric) -> @image = 0
