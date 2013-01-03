# **A wrapper for the HTML5 Audio element.**
#
# - Support background music looping via _window.setInterval_.
# - Support self-overlap via a redundant audio object.
class audio
  constructor: (sndurl) -> if sndurl[sndurl.length - 1] is "0" then @data = -1 else
    @mode = stop: 0, play: 1, pause: 2
    @ii = 0
    @oldset = no
    @newset = no
    @sndmode = @mode.stop
    @datamode = @mode.stop
    @data = new Audio
    @data.src = sndurl
    @data.addEventListener "ended", =>
      @datamode = @mode.stop
      @sndmode = @altdatamode if @ii is 0
    @altdatamode = @mode.stop
    @altdata = new Audio
    @altdata.src = sndurl
    @altdata.addEventListener "ended", =>
      @altdatamode = @mode.stop
      @sndmode = @datamode if @ii is 0
    @fade()

  # Play the sound, if it is new or stopped.  
  # Set up the background loop if the loop duration has been initialized.
  play: -> if @data isnt -1 and (@sndmode isnt @mode.pause or @ii isnt 0)
    @sndmode = @mode.play if @sndmode is @mode.stop
    @ii = window.setInterval (=> @play()), 1000*@loop if @loop? and @ii is 0
    if @datamode is @mode.stop
      @datamode = @mode.play
      @data.play()
    else if @altdatamode is @mode.stop
      @altdatamode = @mode.play
      @altdata.play()

  # Stop the sound playing.
  stop: -> if @data isnt -1
    @sndmode = @mode.stop
    window.clearInterval @ii if @ii isnt 0
    @ii = 0
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
  pause: -> if @data isnt -1 and @sndmode is @mode.play
    @sndmode = @mode.pause
    if @ii isnt 0 then @fade() else
      if @datamode is @mode.play
        @datamode = @mode.pause
        @data.pause()
      if @altdatamode is @mode.play
        @altdatamode = @mode.pause
        @altdata.pause()

  # Unpause (or unmute) the sound if it is paused.
  unpause: -> if @data isnt -1 and @sndmode is @mode.pause
    @sndmode = @mode.play
    if @ii isnt 0 then @fade() else
      if @datamode is @mode.pause
        @datamode = @mode.play
        @data.play()
      if @altdatamode is @mode.pause
        @altdatamode = @mode.play
        @altdata.play()

  # Set the volume of the sound.
  fade: -> if @data isnt -1
    volume = if serv.audio.muted or (@sndmode is @mode.pause and @ii isnt 0) then 0 else serv.audio.volume
    @data.volume = volume
    @altdata.volume = volume

  # If this is not called every frame, [the sound won't play](sound.html).
  step: -> @newset = yes
