# **A wrapper for the HTML5 Audio element.**
#
# - Support background music looping via _window.setInterval_.
# - Support self-overlap via a redundant audio object.
class audio
  constructor: (sndurl) -> if sndurl[sndurl.length - 1] is "0" then @data = -1 else
    @ii = 0
    @paused = no
    @oldset = no
    @newset = no
    @mode = {stop: 0, play: 1, pause: 2}
    @datamode = @mode.stop
    @data = new Audio
    @data.src = sndurl
    @data.addEventListener "ended", => @datamode = @mode.stop
    @altdatamode = @mode.stop
    @altdata = new Audio
    @altdata.src = sndurl
    @altdata.addEventListener "ended", => @altdatamode = @mode.stop

  # Set an initial volume and a loop duration, assuming
  # the sound is background music or some other audio loop.
  init: (initvol, @loop) ->
    @fade initvol
    this

  # Play the sound, if it is new or stopped.  
  # Set up the background loop if the loop duration has been initialized.
  play: (oldplay) -> if @data isnt -1
    @ii = window.setInterval (=> @play 0), 1000*@loop if @loop? and not oldplay?
    if @datamode is @mode.stop
      @datamode = @mode.play
      @data.play()
    else if @altdatamode is @mode.stop
      @altdatamode = @mode.play
      @altdata.play()

  # Stop the sound playing.
  stop: -> if @data isnt -1
    if @datamode isnt @mode.stop
      @datamode = @mode.stop
      @data.pause()
      @data.currentTime = 0
    if @altdatamode isnt @mode.stop
      @altdatamode = @mode.stop
      @altdata.pause()
      @altdata.currentTime = 0

  # Pause (or mute) the sound if it is playing.  
  # Muting in place of pausing occurs in background music
  # and audio loops: since it is impossible to pause a
  # _window.setInterval_ countdown, attempting to actually
  # pause looping audio will result in unwanted behavior.
  pause: -> if @data isnt -1
    if not @paused
      if @ii isnt 0 then @fade 0 else
        if @datamode is @mode.play
          @datamode = @mode.pause
          @data.pause()
        if @altdatamode is @mode.play
          @altdatamode = @mode.pause
          @altdata.pause()
      @paused = yes

  # Unpause (or unmute) the sound if it is paused.
  unpause: (vol) -> if @data isnt -1
    if @paused
      if @ii isnt 0 then @fade vol else
        if @datamode is @mode.pause
          @datamode = @mode.play
          @data.play()
        if @altdatamode is @mode.pause
          @altdatamode = @mode.play
          @altdata.play()
      @paused = no

  # Set the volume of the sound.
  fade: (volume) -> if @data isnt -1
    volume = 0 if serv.audio.muted
    @data.volume = volume
    @altdata.volume = volume

  # If this is not called every frame, [the sound won't play](sound.html).
  step: -> @newset = yes
