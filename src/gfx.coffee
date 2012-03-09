class graphicshandler
  constructor: -> @opposite = [1, 2, 3, 4, -3, -2, -1]

  fadeform: (t, cycle) -> 0.5 + 0.5 * Math.cos t * Math.PI / cycle

  zoomform: (xzoom, yzoom, x, y, z, a) -> [x - xzoom * z, y - yzoom * z, z, a]

  lookhere: (object, subject) ->
    xdist = object.area.x - subject.area.x
    ydist = object.area.y - subject.area.y
    if xdist is 0
      direction = if ydist > 0 then 0 else 4
    else slope = ydist / xdist
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
    object.vector = direction
    subject.vector = @opposite[direction + 3]
