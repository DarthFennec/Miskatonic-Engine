# **The general sprite implementation.**
#
# - sheet: The spritesheet.
# - area: The position and size of the sprite.
# - len: Animation length for each mode.
# - speed: Movement speed for each mode.
# - solid: _true_ if the sprite is solid.
# - active: _true_ if the sprite can move and collide.
# - vector: The direction the sprite is pointing.
# - mode: The mode (standing, walking, running, etc).
# - frame: The animation frame index.
# - aiscripts: A list of callback functions to call under various circumstances.
#
# Sprites can represent anything from maps to player characters to NPCs
# to invisible trigger fields to interactive stationary objects, etc etc.
# Everything in the scene can be represented by a sprite.
class sprite
  constructor: (args) ->
    def =
      sheet     : 0
      area      : new rect 0, 0, 0, 0
      len       : []
      speed     : []
      solid     : false
      active    : false
      vector    : new angle "spr", 0
      mode      : 0
      frame     : 0
      aiscripts : {}
    @[prop] = args[prop] ? def[prop] for prop of def
    @aiscripts.sprite = this if @aiscripts isnt {}
    if @sheet isnt 0
      tmp = @sheet
      @sheet = new surface new vect 8*@area.s.x, tmp.dims.y
      @sheet.ctx.scale -1, 1
      @sheet.drawImage tmp, @area.s.x, 0, -3*@area.s.x, 0, 3*@area.s.x, tmp.dims.y
      @sheet.ctx.scale -1, 1
      @sheet.drawImage tmp, 0, 0, 3*@area.s.x, 0, 5*@area.s.x, tmp.dims.y

  # Select the correct tile from the spritesheet, based on _vector_, _mode_,
  # and _frame_, and draw it to the screen based on _area_. Then update _area_
  # and _frame_.
  step: (buff, offset) ->
    if @sheet isnt 0
      @frame = @len[@mode] if @frame < @len[@mode] or @frame >= @len[1 + @mode]
      buff.map @sheet, (3 + @vector.get "spr"), (Math.floor @frame), @area.s.x, @area.s.y, @area.p.x - offset.x, @area.p.y - offset.y, 1, 1
      @area.p.l (k) => @area.p.i(k) + @speed[@mode]*(@vector.get "vlc").i(k)
      @frame += 0.3

  # Detect collisions by calculating the distance from each edge of one
  # sprite to the alternate edge of the other. If every distance is positive,
  # there is an overlap, so determine the direction of least overlap and
  # push the sprite out in that direction (if the sprite is solid), and/or
  # trigger an event (if there is one to trigger).
  collide: (spr) ->
    off1 = spr.area.p.x + spr.area.s.x - @area.p.x
    off2 = spr.area.p.y + spr.area.s.y - @area.p.y
    off3 = @area.p.x + @area.s.x - spr.area.p.x
    off4 = @area.p.y + @area.s.y - spr.area.p.y
    offx = 1
    offset = off1
    if off1 > 0 and off2 > 0 and off3 > 0 and off4 > 0
      if @solid
        if offset > off2
          offset = off2
          offx = 2
        if offset > off3
          offset = off3
          offx = 3
        if offset > off4
          offset = off4
          offx = 4
        spr.area.p.x -= offset if offx is 1
        spr.area.p.y -= offset if offx is 2
        spr.area.p.x += offset if offx is 3
        spr.area.p.y += offset if offx is 4
      if @aiscripts.trigger?
        spr.mode = 0
        @aiscripts.trigger this, spr

  # When the action key is pressed, and a sprite is within the main sprite's
  # field of view (in this case, less than half a sprite away in the direction
  # the main sprite is facing), a sprite might "interact" via a callback.
  interact: (spr) ->
    offx = new rect spr.area.p.x, spr.area.p.y, spr.area.s.x, spr.area.s.y
    offx.p.l (k) -> offx.p.i(k) + (spr.vector.get "kbd").i(k)*offx.s.i(k)/2
    off1 = (new vect).l (k) => offx.p.i(k) + offx.s.i(k) - @area.p.i(k)
    off2 = (new vect).l (k) => @area.p.i(k) + @area.s.i(k) - offx.p.i(k)
    if off1.x > 0 and off1.y > 0 and off2.x > 0 and off2.y > 0
      spr.mode = 0
      @aiscripts.interact this, spr

  # Gather and return data to be saved.
  savestate: -> {px: @area.p.x, py: @area.p.y, md: @mode, fr: @frame, vx: @vector.get "spr"}

  # Distribute save data to be used.
  loadstate: (state) ->
    @area.p.x = state.px
    @area.p.y = state.py
    @mode = state.md
    @frame = state.fr
    @vector.set "spr", state.vx
