# **The scene node system.**
#
# A scene node represents any particular part of a game. Scenes, cutscenes,
# dialogues, sections, the title screen, even the game itself is a big scene
# node. All the scene nodes in a game are connected together as a single
# tree structure, with the game node as the root.
class scenenode
  constructor: (@child, @filelist, @init, @callback) -> @canreeval = yes

  # Tell a particular child node to initialize itself.
  initchild: (idx, callback) ->
    if typeof @child[idx] is "string"
      json = serv.load.load @child[idx]
      serv.load.callbacks.push =>
        child = serv.extern.setscene json.txt
        child.initialize this, idx
        callback? child
    else
      @child[idx].initialize this, idx
      callback? @child[idx]

  # Initialize this node, load resources, and run it.
  initialize: (@parent, @idx) ->
    if @canreeval
      @file = []
      serv.audio.push()
      serv.state = this
      if @filelist.length is 0
        if serv.load.callbacks.length is 0 then @init()
        else serv.load.callbacks.push => @init()
      else
        @file = for file in @filelist then serv.load.load file
        serv.load.callbacks.push => @init()

  # Exit the current scene node, and return control back to the parent node.
  exitscene: (n) ->
    serv.audio.clear()
    serv.state = @parent
    @parent.callback? @idx
    n

  # Crawl through the tree to find the branch to the currently running node, and return it.
  savestate: ->
    if this is serv.scene then []
    else
      rtn = @parent.savestate()
      rtn.push @idx
      rtn

  # Crawl down the saved branch and initialize all in-use nodes.
  loadstate: (stack) -> if stack.length > 0
    idx = stack.shift()
    @initchild idx, (n) -> n.loadstate stack
