# **The conventional scene system.**
#
# This class is built to handle conventional "walking around" scenes.
# A scene is simply a list of [sprites](sprite.html), and/or sprite-like
# objects such as [tile maps](tile.html).
class scenehandler
  constructor: -> @currscene = 0

  # Initialize or reinitialize the scene, given a new sprite list. Pass 0 to remove the scene.
  initialize: (@currscene) ->
    if @currscene isnt 0
      @currscene.focus = @currscene[0]
      for sprite in @currscene then if sprite.focus
        @currscene.focus = sprite
        break

  # Render all the sprites, after solving all AI and collisions.
  render: (buffer) ->
    if @currscene isnt 0
      @currscene.sort (a, b) -> if a.bottom then 1 else if b.bottom then -1 else b.area.p.y - a.area.p.y
      for sprite in @currscene
        if sprite.active then (scene.collide sprite for scene in @currscene when sprite isnt scene)
        sprite.aiscripts.frame? @currscene
      f = (new vect).l (k) => @currscene.focus.area.p.i(k) + (@currscene.focus.area.s.i(k) - buffer.dims.i(k))/2
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
