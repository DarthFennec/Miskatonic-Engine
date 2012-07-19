# **The vector implementation.**
#
# - Support 2D vectors stored with x and y components.
# - Builtin support for component-wise vector math.
class vect
  constructor: (@x, @y) ->

  # Component-wise vector math. Example:  
  # `foo.l (k) -> bar.i(k) + baz.j(k)` is equivalent to  
  # `foo.x = bar.x + baz.y`  
  # `foo.y = bar.y + baz.x`
  l: (func) ->
    @x = func yes
    @y = func no
    this

  # Usually used from within the _l_ callback.  
  # _i_ is the primary component, and _j_ is the alternate component.
  i: (k) -> if k then @x else @y

  j: (k) -> if k then @y else @x

# **The rectangle implementation.**
#
# A rectangular area, given by position and size vectors.
class rect
  constructor: (x, y, w, h) ->
    @p = new vect x, y
    @s = new vect w, h

# **The wrapper for angle/direction variables.**
#
# There are multiple ways to express a cardinal direction,
# and more than one of them are used in this engine. This class
# helps to easily convert from one representation to another.
class angle
  constructor: (type, val) -> @set type, val

  # - "spr": An integer representing a position on a sprite sheet.
  #   Labeled from 0 (up) to 4 (down), counting positive around clockwise and
  #   negative counterclockwise. Central (neutral) direction is -4.
  # - "kbd": A vector, where each component is a direction: -1, 0, or 1.
  # - "vlc": Like "kbd", but normalized. Useful for finding velocity.
  # - "pts": Extract a cardinal direction from two points.
  get: (type) -> switch type
    when "spr" then @value
    when "kbd" then new vect ([0, -1, -1, -1, 0, 1, 1, 1, 0])[4 + @value], ([0, 1, 0, -1, -1, -1, 0, 1, 1])[4 + @value]
    when "vlc" then new vect ([0, -0.707, -1, -0.707, 0, 0.707, 1, 0.707, 0])[4 + @value], ([0, 0.707, 0, -0.707, -1, -0.707, 0, 0.707, 1])[4 + @value]

  set: (type, val, val2) -> switch type
    when "spr" then @value = val
    when "kbd" then @value = ([[-1, 0, 1], [-2, -4, 2], [-3, 4, 3]])[1 + val.y][1 + val.x]
    when "pts" then @value = @getpts val, val2

  # Given two points, find the closest cardinal direction from one to the other.
  getpts: (a, b) ->
    xdist = a.x - b.x
    ydist = a.y - b.y
    if xdist is 0
      direction = if ydist > 0 then 0 else 4
    else
      slope = ydist/xdist
      if xdist < 0
        direction = 4 if slope > 2.41421356
        direction = 3 if 0.414213562 < slope <= 2.41421356
        direction = 2 if -0.414213562 < slope <= 0.414213562
        direction = 1 if -2.41421356 < slope <= -0.414213562
        direction = 0 if slope <= -2.41421356
      if xdist > 0
        direction = 0 if slope > 2.41421356
        direction = -1 if 0.414213562 < slope <= 2.41421356
        direction = -2 if -0.414213562 < slope <= 0.414213562
        direction = -3 if -2.41421356 < slope <= -0.414213562
        direction = 4 if slope <= -2.41421356
    direction
