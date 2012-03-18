class scenehandler
  constructor: (@text) ->
    @currscene = 0

  initialize: (newscene) ->
    @currscene = newscene

  render: (buffer) ->
    if @currscene isnt 0
      scene.docollide @currscene[0] for scene in @currscene
      fx = @currscene[0].area.x + (@currscene[0].area.w - buffer.dims.x) / 2
      fy = @currscene[0].area.y + (@currscene[0].area.h - buffer.dims.y) / 2
      @text.render buffer
      scene.step buffer, new vect(fx, fy) for scene in @currscene
      yes
    else no

  input: (keys) ->
    keybindings = [[-3, 4, 3], [-2, -4, 2], [-1, 0, 1]]
    vector = keybindings[1 + keys.state[0] - keys.state[2]][1 + keys.state[3] - keys.state[1]]
    if not @text.input keys
      if vector is -4 then @currscene[0].mode = 0 else
        @currscene[0].mode = if keys.state[4] is 1 then 3 else 1
        @currscene[0].vector = vector
      if keys.poll[5] is 1 then for scene in @currscene
        scene.dointeract @currscene[0] if scene.interact
    if @currscene != 0 then yes else no
