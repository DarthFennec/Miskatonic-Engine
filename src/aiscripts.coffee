# **Some common aiscript implementations.**
#
# Sprites can optionally have ai callback scripts. This class
# contains factory methods to generate some of the more common ones.
class aiscripts

  # Turn to face the main sprite, if it is within a given radius.
  watch: (radius) ->
    (scenegraph) ->
      distance = (Math.pow @sprite.area.p.x - scenegraph.focus.area.p.x, 2) + (Math.pow @sprite.area.p.y - scenegraph.focus.area.p.y, 2)
      @sprite.vector.set "pts", @sprite.area.p, scenegraph.focus.area.p if distance < radius*radius

  # Move and change direction randomly, given some stability of motion.
  random: (stability) ->
    (scenegraph) ->
      if Math.random() > stability
        @sprite.mode = Math.floor Math.random()*3
        @sprite.vector.set "spr", -3 + Math.floor Math.random()*8

  # Follow the main sprite:
  #
  # - Run or walk after the main sprite, avoiding obstactles.
  # - Watch the main sprite without moving, if it is within a given radius.
  # - If the main sprite is too close, move out of the way.
  follow: (bumprad, inrad, outrad) ->
    graph = 0
    path = 0
    oldpos = new vect -1, -1
    (scenegraph) ->
      mapsrc = scenegraph[scenegraph.length - 1]
      dist = new vect (Math.abs @sprite.area.p.x - scenegraph.focus.area.p.x), Math.abs @sprite.area.p.y - scenegraph.focus.area.p.y
      if graph is 0 then graph = new Graph mapsrc.grid.map (x) -> x.map (y) -> (if y < 0 then 1 else 0)
      distance = Math.max dist.x, dist.y
      srcpos = new vect (1 + Math.floor (@sprite.area.p.x + @sprite.carea.p.x)/mapsrc.tilesize.x),
        1 + Math.floor (@sprite.area.p.y + @sprite.carea.p.y)/mapsrc.tilesize.y
      destpos = new vect (1 + Math.floor (scenegraph.focus.area.p.x + scenegraph.focus.carea.p.x)/mapsrc.tilesize.x),
        1 + Math.floor (scenegraph.focus.area.p.y + scenegraph.focus.carea.p.y)/mapsrc.tilesize.y
      if oldpos.x isnt destpos.x or oldpos.y isnt destpos.y
        oldpos = new vect destpos.x, destpos.y
        path = astar.search graph.nodes, graph.nodes[srcpos.x][srcpos.y], graph.nodes[destpos.x][destpos.y]
        path = path.filter (e, i, a) -> if a[i - 1]? and a[i + 1]? then (a[i - 1].x is a[i + 1].x or a[i - 1].y is a[i + 1].y) else yes
      if distance <= bumprad
        dirp = 0
        dirn = 0
        vctr = scenegraph.focus.vector.get "kbd"
        if dist.x < dist.y
          if vctr.y isnt 0
            if vctr.x isnt 0 then @sprite.vector.set "kbd", new vect -vctr.x, 0 else
              dirp += 1 until graph.input[destpos.x + dirp][destpos.y] is 1
              dirn += 1 until graph.input[destpos.x - dirn][destpos.y] is 1
              dirp += 1 if dirp is dirn and scenegraph.focus.area.p.x + scenegraph.focus.area.s.x/2 - (destpos.x - 1)*mapsrc.tilesize.x < mapsrc.tilesize.x/2
              @sprite.vector.set "kbd", new vect (if dirp > dirn then 1 else -1), 0
            @sprite.mode = 2
        else
          if vctr.x isnt 0
            if vctr.y isnt 0 then @sprite.vector.set "kbd", new vect 0, -vctr.y else
              dirp += 1 until graph.input[destpos.x][destpos.y + dirp] is 1
              dirn += 1 until graph.input[destpos.x][destpos.y - dirn] is 1
              dirp += 1 if dirp is dirn and scenegraph.focus.area.p.y + scenegraph.focus.area.s.y/2 - (destpos.y - 1)*mapsrc.tilesize.y < mapsrc.tilesize.y/2
              @sprite.vector.set "kbd", new vect 0, if dirp > dirn then 1 else -1
            @sprite.mode = 2
      if bumprad < distance <= inrad
        @sprite.vector.set "pts", @sprite.area.p, scenegraph.focus.area.p
        @sprite.mode = 0
      if inrad < distance and path.length > 0
        vectdir = new vect
        path.shift() if path[0].x is srcpos.x and path[0].y is srcpos.y
        vectdir.x = if path[0].x > srcpos.x then 1 else if path[0].x < srcpos.x then -1 else 0
        vectdir.y = if path[0].y > srcpos.y then 1 else if path[0].y < srcpos.y then -1 else 0
        vectdir.x = -1 if vectdir.x is 0 and @sprite.area.p.x + 2*@sprite.area.s.x > mapsrc.tilesize.x*(srcpos.x + 1) and graph.input[srcpos.x + 1][srcpos.y + vectdir.y] is 1
        vectdir.y = -1 if vectdir.y is 0 and @sprite.area.p.y + 2*@sprite.area.s.y > mapsrc.tilesize.y*(srcpos.y + 1) and graph.input[srcpos.x + vectdir.x][srcpos.y + 1] is 1
        @sprite.vector.set "kbd", vectdir
        @sprite.mode = if outrad < distance then 2 else 1

  # Move around when the player uses the keyboard.
  keyboard: ->
    (scenegraph, keys) ->
      if keys.right.state is keys.left.state and keys.down.state is keys.up.state then @sprite.mode = 0 else
        @sprite.vector.set "kbd", new vect keys.right.state - keys.left.state, keys.down.state - keys.up.state
        @sprite.mode = if keys.run.state is 1 then 2 else 1
      if keys.act.poll is 1 then for scene in scenegraph when scene.aiscripts.interact? then scene.interact @sprite
