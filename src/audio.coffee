class audio
  constructor: (sndurl) -> if sndurl[sndurl.length - 1] is "0" then @data = -1 else
    @ii = 0
    @paused = no
    @oldset = no
    @newset = no
    # for @datamode and @altdatamode -> 0 = stopped, 1 = playing, 2 = paused
    @datamode = 0
    @data = new Audio
    @data.src = sndurl
    @data.addEventListener "ended", => @datamode = 0
    @altdatamode = 0
    @altdata = new Audio
    @altdata.src = sndurl
    @altdata.addEventListener "ended", => @altdatamode = 0

  init: (initvol, @loop) ->
    @fade initvol
    this

  play: (oldplay) -> if @data isnt -1
    @ii = window.setInterval (=> @play 0), 1000*@loop if @loop? and not oldplay?
    if @datamode is 0
      @datamode = 1
      @data.play()
    else if @altdatamode is 0
      @altdatamode = 1
      @altdata.play()

  stop: -> if @data isnt -1
    if @datamode isnt 0
      @datamode = 0
      @data.pause()
      @data.currentTime = 0
    if @altdatamode isnt 0
      @altdatamode = 0
      @altdata.pause()
      @altdata.currentTime = 0

  pause: -> if @data isnt -1
    if not @paused
      if @ii isnt 0 then @fade 0 else
        if @datamode is 1
          @datamode = 2
          @data.pause()
        if @altdatamode is 1
          @altdatamode = 2
          @altdata.pause()
      @paused = yes

  unpause: (vol) -> if @data isnt -1
    if @paused
      if @ii isnt 0 then @fade vol else
        if @datamode is 2
          @datamode = 1
          @data.play()
        if @altdatamode is 2
          @altdatamode = 1
          @altdata.play()
      @paused = no

  fade: (volume) -> if @data isnt -1
    volume = 0 if serv.audio.muted
    @data.volume = volume
    @altdata.volume = volume

  step: -> @newset = yes
