class scenehandler
  constructor: (@text) ->
    @buffer = new surface new vect 0, 0
    @keybindings = [[-3, 4, 3], [-2, -4, 2], [-1, 0, 1]]
    @currscene = 0

  initialize: (newscene) ->
    @currscene = newscene
    @buffer.size newscene.size

  render: (buffer) ->
    if @currscene isnt 0
      @buffer.clear no
      for scene in @currscene.list
        @currscene.list[0].docollide scene
        scene.step @buffer
      focus = new vect @currscene.list[0].area.x + @currscene.list[0].area.w / 2, @currscene.list[0].area.y + @currscene.list[0].area.h / 2
      @text.render buffer
      buffer.layer @buffer, focus
      yes
    else no

  input: (keys) ->
    vector = @keybindings[1 + keys.state[0] - keys.state[2]][1 + keys.state[3] - keys.state[1]]
    if not @text.input keys
      if vector is -4 then @currscene.list[0].mode = 0 else
        @currscene.list[0].mode = if keys.state[4] is 1 then 3 else 1
        @currscene.list[0].vector = vector
      if keys.poll[5] is 1 then for scene in @currscene.list
        @currscene.list[0].dointeract scene if scene.interact
    if @currscene != 0 then yes else no

class scene
  constructor: (@size, @list) ->
