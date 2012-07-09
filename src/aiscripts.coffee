class aiscripts
  constructor: ->

  watch: (radius) ->
    (scenegraph) ->
      distance = (Math.pow @area.p.x - scenegraph[0].area.p.x, 2) + (Math.pow @area.p.y - scenegraph[0].area.p.y, 2)
      @vector.set "pts", @area.p, scenegraph[0].area.p if distance < radius*radius

  random: (stability) ->
    (scenegraph) ->
      if Math.random() > stability
        @mode = Math.floor Math.random()*3
        @vector.set "spr", -3 + Math.floor Math.random()*8

  follow: (bumprad, inrad, outrad) ->
    graph = 0
    path = 0
    oldpos = new vect -1, -1
    (scenegraph) ->
      mapsrc = scenegraph[scenegraph.length - 1]
      dist = new vect (Math.abs @area.p.x - scenegraph[0].area.p.x), (Math.abs @area.p.y - scenegraph[0].area.p.y)
      if graph is 0 then graph = new Graph mapsrc.grid.map (x) -> x.map (y) -> (if y < 0 then 1 else 0)
      distance = if dist.x > dist.y then dist.x else dist.y
      srcpos = (new vect).l (k) => 1 + Math.floor @area.p.i(k)/mapsrc.tilesize.i(k)
      destpos = (new vect).l (k) => 1 + Math.floor scenegraph[0].area.p.i(k)/mapsrc.tilesize.i(k)
      if oldpos.x isnt destpos.x or oldpos.y isnt destpos.y
        oldpos = new vect destpos.x, destpos.y
        path = astar.search graph.nodes, graph.nodes[srcpos.x][srcpos.y], graph.nodes[destpos.x][destpos.y]
        path = path.filter (e, i, a) -> if a[i - 1]? and a[i + 1]? then (a[i - 1].x is a[i + 1].x or a[i - 1].y is a[i + 1].y) else yes
      if distance <= bumprad
        dirp = 0
        dirn = 0
        vctr = scenegraph[0].vector.get "kbd"
        if dist.x < dist.y
          if vctr.y isnt 0
            if vctr.x is -1 then @vector.set "spr", 2
            else if vctr.x is 1 then @vector.set "spr", -2
            else
              dirp += 1 until destpos.x + dirp is graph.input.length or graph.input[destpos.x + dirp][destpos.y] is 1
              dirn += 1 until destpos.x - dirn is 0 or graph.input[destpos.x - dirn][destpos.y] is 1
              @vector.set "spr", if dirp > dirn then 2 else -2
            @mode = 2
        else
          if vctr.x isnt 0
            if vctr.y is -1 then @vector.set "spr", 4
            else if vctr.y is 1 then @vector.set "spr", 0
            else
              dirp += 1 until destpos.y + dirp is graph.input[0].length or graph.input[destpos.x][destpos.y + dirp] is 1
              dirn += 1 until destpos.y - dirn is 0 or graph.input[destpos.x][destpos.y - dirn] is 1
              @vector.set "spr", if dirp > dirn then 4 else 0
            @mode = 2
      if bumprad < distance <= inrad
        @vector.set "pts", @area.p, scenegraph[0].area.p
        @mode = 0
      if inrad < distance and path.length > 0
        vectdir = new vect
        path.shift() if path[0].x is srcpos.x and path[0].y is srcpos.y
        vectdir.x = if path[0].x > srcpos.x then 1 else if path[0].x < srcpos.x then -1 else 0
        vectdir.y = if path[0].y > srcpos.y then 1 else if path[0].y < srcpos.y then -1 else 0
        vectdir.x = -1 if vectdir.x is 0 and @area.p.x + 2*@area.s.x > mapsrc.tilesize.x*(srcpos.x + 1) and graph.input[srcpos.x + 1][srcpos.y + vectdir.y] is 1
        vectdir.y = -1 if vectdir.y is 0 and @area.p.y + 2*@area.s.y > mapsrc.tilesize.y*(srcpos.y + 1) and graph.input[srcpos.x + vectdir.x][srcpos.y + 1] is 1
        @vector.set "kbd", vectdir
        @mode = if outrad < distance then 2 else 1
