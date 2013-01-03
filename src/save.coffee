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
  validate: ->
    try
      JSON.parse localStorage.savestate
      yes
    catch e then no

  # Gather state data from the game, stringify, and store in localStorage.
  savestate: (n) ->
    obj = global: serv.global
    obj.stack = serv.state.savestate()
    obj.local = for rend in serv.engine.rends when rend.savestate? then rend.savestate()
    localStorage.savestate = JSON.stringify obj
    n

  # Parse localStorage and distribute save data into the game.
  loadstate: (n) ->
    serv.reset()
    obj = JSON.parse localStorage.savestate
    serv.audio.mute obj.global.m
    serv.engine.resize new vect obj.global.s[0], obj.global.s[1]
    serv.scene.loadstate obj.stack
    waitforload = ->
      if obj.stack.length is 0 then serv.load.callbacks.push ->
        rend.loadstate obj.local.shift() for rend in serv.engine.rends when rend.loadstate?
      else serv.load.callbacks.push waitforload
    serv.load.callbacks.push waitforload
    n
