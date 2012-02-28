class spritehandler
  constructor: ->
    @xmove = [-0.707, -1, -0.707, 0, 0.707, 1, 0.707, 0]
    @ymove = [0.707, 0, -0.707, -1, -0.707, 0, 0.707, 1]

  step: (buff, currsprite) ->
    if currsprite.sheet isnt 0
      currsprite.frame = 0 if currsprite.frame >= currsprite.len[currsprite.mode]
      sx = currsprite.area.w * (Math.floor(currsprite.frame) + Math.abs currsprite.vector * currsprite.len[currsprite.mode])
      sy = currsprite.area.h * currsprite.mode
      if currsprite.vector < 0
        buff.scale -1, 1
        buff.drawImage currsprite.sheet, sx, sy, currsprite.area.w, currsprite.area.h,
                       -(currsprite.area.x + currsprite.area.w), currsprite.area.y, currsprite.area.w, currsprite.area.h
        buff.scale -1, 1
      else buff.drawImage currsprite.sheet, sx, sy, currsprite.area.w, currsprite.area.h,
                          currsprite.area.x, currsprite.area.y, currsprite.area.w, currsprite.area.h
      currsprite.area.x += @xmove[currsprite.vector + 3] * currsprite.speed[currsprite.mode]
      currsprite.area.y += @ymove[currsprite.vector + 3] * currsprite.speed[currsprite.mode]
      currsprite.frame += 0.3

class sprite
  constructor: (args) ->
    def = 
      sheet    : 0
      area     : new rect 0, 0, 0, 0
      callback : 0
      len      : new Array
      speed    : new Array
      collide  : false
      trigger  : false
      interact : false
      vector   : 0
      mode     : 0
      frame    : 0
    @[prop] = args[prop] ? def[prop] for prop of def
