# **The scene node system.**
#
# A scene node represents any particular part of a game. Scenes, cutscenes,
# dialogues, sections, the title screen, even the game itself is a big scene
# node. All the scene nodes in a game are connected together as a single
# tree structure, with the game node as the root.
class scenenode
  constructor: (@filelist, @init, @callback) -> @canreeval = yes

  # Build the scene tree from a simplified representation _tree_.  
  # _tree_ should be an object with a member _n_ (the _scenenode_ object)
  # and a member _c_ (an array of child _tree_s).
  buildtree: (tree, @parent, @idx) ->
    @child = []
    for child, idx in tree
      @child[idx] = child.n
      child.n.buildtree child.c, this, idx

  # Initialize this child node, load resources, and run it.
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

  # Exit the current scene node, and return control back to the parent node.
  exitscene: (n) ->
    serv.audio.clear()
    serv.state = @parent
    @parent.callback? @idx
    n

  # Crawl through the tree to find the branch to the currently running node, and return it.
  savestate: (state) ->
    ret = 0
    if state is this then ret = [@idx]
    else for c in @child when (l = c.savestate state) instanceof Array
      ret = l
      ret.unshift @idx
    ret

  # Crawl down the saved branch and initialize all in-use nodes.
  loadstate: (stack) ->
    @initialize()
    if stack.length > 0
      idx = stack.shift()
      @child[idx].loadstate stack
