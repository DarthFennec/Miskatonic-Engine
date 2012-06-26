class savehandler
  constructor: (@cansaveload) ->

  validate: -> localStorage.savestate?

  savestate: (n) ->
    obj = {}
    obj.stack = serv.scene.savestate serv.state
    obj.stack.shift()
    obj.local = (rend.savestate() for rend in serv.engine.rends when rend.savestate?)
    localStorage.savestate = JSON.stringify obj
    n

  loadstate: (n) ->
    serv.reset no
    obj = JSON.parse localStorage.savestate
    serv.scene.loadstate obj.stack
    serv.formats.callbacks.push -> rend.loadstate obj.local.shift() for rend in serv.engine.rends when rend.loadstate?
    n
