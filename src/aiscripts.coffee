class aiscripts
  constructor: ->

  watch: (radius) ->
    (scenegraph) ->
      distance = Math.pow((@area.x - scenegraph[0].area.x), 2) + Math.pow((@area.y - scenegraph[0].area.y), 2)
      @lookhere scenegraph[0], no if distance < radius * radius

  random: (stability) ->
    (scenegraph) ->
      if Math.random() > stability
        @mode = Math.floor Math.random() * 4
        @vector = -3 + Math.floor Math.random() * 8

  follow: (bumprad, inrad, outrad) ->
    translate = [[-1, 0, 1], [-2, -4, 2], [-3, 4, 3]]
    graph = 0
    path = 0
    oldpos = new vect -1, -1
    (scenegraph) ->
      mapsrc = scenegraph[scenegraph.length - 1]
      if graph is 0 then graph = new Graph mapsrc.grid.map (x) -> x.map (y) -> (if y < 0 then 1 else 0)
      if Math.abs(@area.x - scenegraph[0].area.x) > Math.abs(@area.y - scenegraph[0].area.y)
        distance = Math.abs(@area.x - scenegraph[0].area.x)
      else
        distance = Math.abs(@area.y - scenegraph[0].area.y)
      srcpos = new vect Math.floor(@area.x / mapsrc.tilesize.x), Math.floor(@area.y / mapsrc.tilesize.y)
      destpos = new vect Math.floor(scenegraph[0].area.x / mapsrc.tilesize.x), Math.floor(scenegraph[0].area.y / mapsrc.tilesize.y)
      if oldpos.x isnt destpos.x or oldpos.y isnt destpos.y
        oldpos.x = destpos.x
        oldpos.y = destpos.y
        path = astar.search graph.nodes, graph.nodes[srcpos.x][srcpos.y], graph.nodes[destpos.x][destpos.y]
        path = path.filter (e, i, a) -> if a[i - 1]? and a[i + 1]? then (a[i - 1].x is a[i + 1].x or a[i - 1].y is a[i + 1].y) else yes
      if distance <= bumprad
        dirp = 0
        dirn = 0
        if Math.abs(@area.x - scenegraph[0].area.x) < Math.abs(@area.y - scenegraph[0].area.y)
          if scenegraph[0].vector isnt 2 and scenegraph[0].vector isnt -2
            dirp += 1 until destpos.x + dirp is graph.input.length or graph.input[destpos.x + dirp][destpos.y] is 1
            dirn += 1 until destpos.x - dirn is 0 or graph.input[destpos.x - dirn][destpos.y] is 1
            @vector = if dirp > dirn then 2 else -2
            @mode = 3
        else
          if scenegraph[0].vector isnt 4 and scenegraph[0].vector isnt 0
            dirp += 1 until destpos.y + dirp is graph.input[0].length or graph.input[destpos.x][destpos.y + dirp] is 1
            dirn += 1 until destpos.y - dirn is 0 or graph.input[destpos.x][destpos.y - dirn] is 1
            @vector = if dirp > dirn then 4 else 0
            @mode = 3
      if bumprad < distance <= inrad
        @lookhere scenegraph[0], no
        @mode = 0
      if inrad < distance and path.length > 0
        path.shift() if path[0].x is srcpos.x and path[0].y is srcpos.y
        vectdirx = if path[0].x > srcpos.x then 2 else if path[0].x < srcpos.x then 0 else 1
        vectdiry = if path[0].y > srcpos.y then 2 else if path[0].y < srcpos.y then 0 else 1
        if vectdirx is 1 and @area.x + @area.w > mapsrc.tilesize.x * (srcpos.x + 1) and graph.input[srcpos.x + 1][srcpos.y + vectdiry - 1] is 1
          vectdirx = 0
        if vectdiry is 1 and @area.y + @area.h > mapsrc.tilesize.y * (srcpos.y + 1) and graph.input[srcpos.x + vectdirx - 1][srcpos.y + 1] is 1
          vectdiry = 0
        @vector = translate[vectdiry][vectdirx]
        @mode = if outrad < distance then 3 else 1
