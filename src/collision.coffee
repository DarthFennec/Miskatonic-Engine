class collisionhandler
  constructor: ->

  collide: (obj, wall) ->
    off1 = obj.area.y + obj.area.h - wall.area.y
    off2 = wall.area.x + wall.area.w - obj.area.x
    off3 = wall.area.y + wall.area.h - obj.area.y
    off4 = obj.area.x + obj.area.w - wall.area.x
    offx = 1
    offset = off1
    if off1 > 0 and off2 > 0 and off3 > 0 and off4 > 0
      if offset > off2
        offset = off2
        offx = 2
      if offset > off3
        offset = off3
        offx = 3
      if offset > off4
        offset = off4
        offx = 4
      obj.area.y -= offset if offx is 1
      obj.area.x += offset if offx is 2
      obj.area.y += offset if offx is 3
      obj.area.x -= offset if offx is 4

  trigger: (obj, wall) ->
    off1 = obj.area.y + obj.area.h - wall.area.y
    off2 = wall.area.x + wall.area.w - obj.area.x
    off3 = wall.area.y + wall.area.h - obj.area.y
    off4 = obj.area.x + obj.area.w - wall.area.x
    if off1 > 0 and off2 > 0 and off3 > 0 and off4 > 0
      obj.mode = 0
      wall.callback()
  
  interact: (obj, wall) ->
    offx = new sprite {"area":new rect obj.area.x, obj.area.y, obj.area.w, obj.area.h}
    offx.area.x -= offx.area.w / 2 if obj.vector < 0
    offx.area.x += offx.area.w / 2 if obj.vector > 0 and obj.vector < 4
    offx.area.y -= offx.area.h / 2 if obj.vector > -2 and obj.vector < 2
    offx.area.y += offx.area.h / 2 if obj.vector < -2 or obj.vector > 2
    off1 = offx.area.y + offx.area.h - wall.area.y
    off2 = wall.area.x + wall.area.w - offx.area.x
    off3 = wall.area.y + wall.area.h - offx.area.y
    off4 = offx.area.x + offx.area.w - wall.area.x
    if off1 > 0 and off2 > 0 and off3 > 0 and off4 > 0
      obj.mode = 0
      wall.callback()
