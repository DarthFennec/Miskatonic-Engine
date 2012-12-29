# **The audio server system.**
#
# - Keep track of all sounds being currently used. Organize them in a stack
#   of lists. Each list in the stack represents a scene node in the tree,
#   and the collection of sounds loaded with that scene node. This makes
#   it easy to automatically unload sounds, without unloading the wrong ones.
# - Most of the engine depends on stack blocking: to pause the game or wait
#   for things to load, the render functions are simply ignored, because the
#   default behavior of graphics is to do nothing. However, the default behavior
#   of audio is to continue to play, so stack blocking doesn't work.  
#   This class helps to abstract stack blocking into the audio system.
#   Each [audio object](audio.html) is required to run _step_ each frame
#   to continue playing. When the stack is blocked, the _step_ functions
#   won't be run. This system automatically plays and pauses sounds as it
#   detects changes in how frequently the _step_ function is run.
# - Provide global volume and mute functions, which affect all loaded sounds.
#
# This layer will never block, and should never be blocked. Keep it at the
# top of the render stack.
class soundhandler
  constructor: (@soundext) ->
    @volume = 1
    @volnew = -1
    @maxvolume = no
    @muted = 0
    @list = []
    serv.load.filetype["snd/"] = (url) ->
      newf = serv.audio.add url + serv.audio.soundext
      if serv.audio.soundext isnt 0
        serv.load.loadcount.push newf
        newf.data.addEventListener "error", ->
          newf.data = -1
          serv.load.err newf, url + serv.audio.soundext
        newf.data.addEventListener "canplaythrough", -> serv.load.finish newf
      newf

  # Add a sound to the top list in the stack.
  add: (sndurl) ->
    newsound = new audio sndurl
    @list[0].push newsound
    newsound

  # Add an empty list to the top of the stack.
  push: -> @list.unshift []

  # Clear the entire stack, except the bottom list. Used when resetting.
  erase: -> @clear() for v, i in @list when i isnt 0

  # Stop and remove all sounds in the top list of the stack.
  clear: ->
    for sound in @list.shift()
      window.clearInterval sound.ii if sound.ii isnt 0
      sound.stop()

  # Set global mute, and set the flag for the change to take effect.
  mute: (newmute) -> if @muted isnt newmute
    @muted = newmute
    @maxvolume = yes
    @volnew = -1

  # Check whether each sound has started or stopped stepping, usually due
  # to a change in the stack blocking. Pause or play the sound accordingly. Change
  # the volume on all sounds, if the global volume or mute has been changed.  
  # Do not use or block visual output, ever.
  render: (buffer) ->
    @volume = 0 if @volume < 0
    @volume = 1 if @volume > 1
    for j in @list then for i in j
      i.pause() if i.oldset and not i.newset
      i.unpause @volume if i.newset and not i.oldset
      i.oldset = i.newset
      i.newset = no
      i.fade @volume if @volnew isnt @volume and not i.paused
    if @maxvolume
      @volume = 1
      @maxvolume = no
    else @volnew = @volume
    no

  # Do not use or block input, ever.
  input: (keys) -> no
