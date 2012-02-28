class scenehandler
  constructor: (@text) ->
    @buffer = document.createElement "canvas"
    @bufferctx = @buffer.getContext "2d"
    @keybindings = [[-3, 4, 3], [-2, -4, 2], [-1, 0, 1]]
    @collision = new collisionhandler
    @spritehandler = new spritehandler
    @currscene = 0

  initialize: (newscene) ->
    @currscene = newscene
    @buffer.width = newscene.w
    @buffer.height = newscene.h

  render: (buffer) ->
    if @currscene isnt 0
      @bufferctx.clearRect 0, 0, @buffer.width, @buffer.height
      for scene in @currscene.list
        @collision.collide @currscene.list[0], scene if scene.collide
        @collision.trigger @currscene.list[0], scene if scene.trigger
        @spritehandler.step @bufferctx, scene
      sx = @currscene.list[0].area.x + @currscene.list[0].area.w / 2
      sy = @currscene.list[0].area.y + @currscene.list[0].area.h / 2
      @text.render buffer
      buffer.blit @buffer, sx, sy
      true
    else false

  input: (keys) ->
    vector = @keybindings[1 + keys.state[0] - keys.state[2]][1 + keys.state[3] - keys.state[1]]
    if not @text.input keys
      if vector is -4 then @currscene.list[0].mode = 0 else
        @currscene.list[0].mode = if keys.state[4] is 1 then 3 else 1
        @currscene.list[0].vector = vector
      if keys.poll[5] is 1 then for scene in @currscene.list
        @collision.interact @currscene.list[0], scene if scene.interact
    if @currscene != 0 then true else false

class scene
  constructor: (@w, @h, @list) ->
