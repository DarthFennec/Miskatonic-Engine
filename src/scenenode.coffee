class scenenode
  constructor: (@filelist, @init, @callback) ->
    @canreeval = yes

  buildtree: (tree, @parent, @idx) ->
    @child = []
    for child, idx in tree
      @child[idx] = child.n
      child.n.buildtree child.c, this, idx

  initialize: ->
    if @canreeval
      @file = []
      serv.audio.push()
      serv.state = this
      if @filelist.length is 0
        if serv.formats.callbacks.length is 0 then @init()
        else serv.formats.callbacks.push => @init()
      else
        serv.formats.callbacks.push => @init()
        @file = for file in @filelist then serv.formats.load file

  exitscene: (n) ->
    serv.audio.clear()
    serv.state = @parent
    @parent.callback? @idx
    n

  savestate: (state) ->
    ret = 0
    if state is this then ret = [@idx]
    else for c in @child when (l = c.savestate state) instanceof Array
      ret = l
      ret.unshift @idx
    ret

  loadstate: (stack) ->
    @initialize()
    if stack.length > 0
      idx = stack.shift()
      @child[idx].loadstate stack
