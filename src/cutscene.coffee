class cutscenehandler
  constructor: (@text) ->
    @currscene = 0
    @currclip = 0
    @currframe = 0

  initialize: (newscene) ->
    @currclip = 0
    @currframe = 0
    @currscene = newscene
    shorten = @currscene[@currclip].text
    @text.initialize shorten if shorten isnt -1 and shorten isnt 0

  render: (buffer) ->
    if @currscene isnt 0
      if @currframe > @currscene[@currclip].duration > 0
        @currframe = 0
        @currclip += 1
        if @currclip < @currscene.length
          if @currscene[@currclip].text is -1 then @text.show = 0
          else if @currscene[@currclip].text is 0 then @text.next()
          else @text.display @currscene[@currclip].text
        else
          @text.next()
          @currscene = 0
          @text.textbox = 0
          return
      @text.render buffer
      for particle in @currscene[@currclip].particle
        buffer.draw particle.image, particle.parametric @currframe
      buffer.ctx.globalAlpha = 1.0
      @currframe += 1
      yes
    else no

  input: (keys) ->
    if @currscene isnt 0
      @text.input keys if keys.poll[5] isnt 1
      if @currscene[@currclip].duration < 1 and keys.poll[5] is 1
        @currframe = 0
        @currclip += 1
        if @currclip < @currscene.length
          if @currscene[@currclip].text is -1 then @text.show = 0
          else if @currscene[@currclip].text is 0 then @text.next()
          else @text.display @currscene[@currclip].text
        else
          @text.next()
          @currscene = 0
          @text.textbox = 0
      yes
    else no

  fadeform: (t, cycle) -> 0.5 + 0.5 * Math.cos t * Math.PI / cycle

  zoomform: (xzoom, yzoom, x, y, z, a) -> [x - xzoom * z, y - yzoom * z, z, a]

class clip
  constructor: (@duration, @text, @particle) ->

class particle
  constructor: (@image, @parametric) ->
