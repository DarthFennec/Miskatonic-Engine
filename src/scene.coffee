# **The conventional scene system.**
#
# This class is built to handle conventional "walking around" scenes.
# A scene is simply a list of [sprites](sprite.html), and/or sprite-like
# objects such as [tile maps](tile.html). Normally, there is one tilemap,
# which should be placed at the end of the list. Also, the first sprite in
# the list will be the scene focus, and can be controlled with the keyboard.
# Any other sprites in the scene should be placed between these two.
class scenehandler
  constructor: -> @currscene = 0

  # Initialize or reinitialize the scene, given a new sprite list. Pass 0 to remove the scene.
  initialize: (@currscene) ->

  # Render all the sprites, after solving all AI and collisions.
  render: (buffer) ->
    if @currscene isnt 0
      for sprite in @currscene when not sprite.passive
        scene.docollide sprite for scene in @currscene when sprite isnt scene
        sprite.aiscript @currscene if sprite.aiscript isnt 0
      f = (new vect).l (k) => @currscene[0].area.p.i(k) + (@currscene[0].area.s.i(k) - buffer.dims.i(k))/2
      sprite.step buffer, f for sprite in @currscene
      yes
    else no

  # On keyboard input, change the state of sprite 0, and check for action events to be handled.
  input: (keys) ->
    if @currscene isnt 0
      if keys.right.state is keys.left.state and keys.down.state is keys.up.state then @currscene[0].mode = 0 else
        @currscene[0].mode = if keys.run.state is 1 then 2 else 1
        @currscene[0].vector.set "kbd", new vect keys.right.state - keys.left.state, keys.down.state - keys.up.state
      if keys.act.poll is 1 then for scene in @currscene when scene.interact then scene.dointeract @currscene[0]
      yes
    else no

  # Gather and return data to be saved.
  savestate: -> if @currscene isnt 0 then (sprite.savestate() for sprite in @currscene)

  # Distribute saved data into the sprite list.
  loadstate: (state) -> if @currscene isnt 0 then (sprite.loadstate state[i] for sprite, i in @currscene)
