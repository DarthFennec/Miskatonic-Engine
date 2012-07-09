class scenehandler
  constructor: ->
    @currscene = 0

  initialize: (@currscene) ->

  render: (buffer) ->
    if @currscene isnt 0
      for sprite in @currscene when not sprite.passive
        scene.docollide sprite for scene in @currscene when sprite isnt scene
        sprite.aiscript @currscene if sprite.aiscript isnt 0
      fx = @currscene[0].area.p.x + (@currscene[0].area.s.x - buffer.dims.x)/2
      fy = @currscene[0].area.p.y + (@currscene[0].area.s.y - buffer.dims.y)/2
      sprite.step buffer, new vect(fx, fy) for sprite in @currscene
      yes
    else no

  input: (keys) ->
    if @currscene isnt 0
      if keys.right.state is keys.left.state and keys.down.state is keys.up.state then @currscene[0].mode = 0 else
        @currscene[0].mode = if keys.run.state is 1 then 2 else 1
        @currscene[0].vector.set "kbd", new vect keys.right.state - keys.left.state, keys.down.state - keys.up.state
      if keys.act.poll is 1 then for scene in @currscene when scene.interact then scene.dointeract @currscene[0]
      yes
    else no

  savestate: -> if @currscene isnt 0 then (sprite.savestate() for sprite in @currscene)

  loadstate: (state) -> if @currscene isnt 0 then (sprite.loadstate state[i] for sprite, i in @currscene)
