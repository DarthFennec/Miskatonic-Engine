# **Savestate management system.**
#
# Use localStorage to save and load a JSON string, representing the current
# state of the game. Used to save a player's progress between sessions.
#
# - Save global variables and states used to track a player's progress.
# - Save the location of the player within the scene node tree.
# - Save the position and behavior of all objects in each scene.
class savehandler
  constructor: (@cansaveload) ->

  # Check to see if a valid state exists in localStorage.
  validate: -> localStorage.savestate?

  # Gather state data from the game, stringify, and store in localStorage.
  savestate: (n) ->
    obj = {}
    obj.stack = serv.scene.savestate serv.state
    obj.stack.shift()
    obj.local = (rend.savestate() for rend in serv.engine.rends when rend.savestate?)
    localStorage.savestate = JSON.stringify obj
    n

  # Parse localStorage and distribute save data into the game.
  loadstate: (n) ->
    serv.reset no
    obj = JSON.parse localStorage.savestate
    serv.scene.loadstate obj.stack
    serv.load.callbacks.push -> rend.loadstate obj.local.shift() for rend in serv.engine.rends when rend.loadstate?
    n
