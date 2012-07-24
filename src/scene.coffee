# **The conventional scene system.**
#
# This class is built to handle conventional "walking around" scenes.
# A scene is simply a list of [sprites](sprite.html), and/or sprite-like
# objects such as [tile maps](tile.html). Normally, there is one tilemap,
# which should be placed at the end of the list. Also, the first sprite in
# the list will be the scene focus, so should be the main sprite.
# Any other sprites in the scene should be placed between these two.
class scenehandler
  constructor: -> @currscene = 0

  # Initialize or reinitialize the scene, given a new sprite list. Pass 0 to remove the scene.
  initialize: (@currscene) ->

  # Render all the sprites, after solving all AI and collisions.
  render: (buffer) ->
    if @currscene isnt 0
      for sprite in @currscene
        if sprite.active then (scene.collide sprite for scene in @currscene when sprite isnt scene)
        sprite.aiscripts.frame? @currscene
      f = (new vect).l (k) => @currscene[0].area.p.i(k) + (@currscene[0].area.s.i(k) - buffer.dims.i(k))/2
      sprite.step buffer, f for sprite in @currscene
      yes
    else no

  # On keyboard input, change the state of sprite 0, and check for input events to be handled.
  input: (keys) ->
    if @currscene isnt 0
      sprite.aiscripts.input? @currscene, keys for sprite in @currscene
      yes
    else no

  # Gather and return data to be saved.
  savestate: -> if @currscene isnt 0 then (sprite.savestate() for sprite in @currscene)

  # Distribute saved data into the sprite list.
  loadstate: (state) -> if @currscene isnt 0 then (sprite.loadstate state[i] for sprite, i in @currscene)
