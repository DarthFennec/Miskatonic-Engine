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
      @sprites = {}
      @currscene.focus = @currscene[0]
      for sprite, index in @currscene
        @sprites[sprite.id] = sprite
        @currscene.focus = sprite if sprite.focus
        sprite.index = index

  # Render all the sprites, after solving all AI and collisions.
  render: (buffer) ->
    if @currscene isnt 0
      @currscene.sort (a, b) -> if a.bottom then 1 else if b.bottom then -1 else b.area.p.y - a.area.p.y
      for sprite in @currscene
        if sprite.active then (scene.collide sprite for scene in @currscene when sprite isnt scene)
        sprite.aiscripts.frame? @currscene
      f = new vect @currscene.focus.area.p.x + (@currscene.focus.area.s.x - buffer.dims.x)/2,
        @currscene.focus.area.p.y + (@currscene.focus.area.s.y - buffer.dims.y)/2
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
  savestate: -> if @currscene isnt 0
    ret = []
    ret[sprite.index] = sprite.savestate() for sprite in @currscene
    ret

  # Distribute saved data into the sprite list.
  loadstate: (state) ->
    if @currscene isnt 0 and state?
      sprite.loadstate state[sprite.index] for sprite in @currscene
    no
