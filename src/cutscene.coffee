class cutscenehandler
  constructor: (@text) ->
    @buffer = new surface new vect 0, 0
    @currscene = 0
    @currclip = 0
    @currframe = 0

  initialize: (loader, newscene) ->
    @currclip = 0
    @currframe = 0
    @currscene = newscene
    @buffer.size newscene.size
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
      @buffer.clear no
      for particle in @currscene.clip[@currclip].particle
        @buffer.draw particle.image, particle.parametric @currframe
      @buffer.ctx.globalAlpha = 1.0
      @currframe += 1
      @text.render buffer
      buffer.layer @buffer, new vect "c", "c"
      yes
    else no

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
      yes
    else no

class cutscene
  constructor: (@size, @clip) ->

class clip
  constructor: (@duration, @text, @particle) ->

class particle
  constructor: (@imageurl, @parametric) -> @image = 0
