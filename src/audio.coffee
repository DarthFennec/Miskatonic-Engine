class audio
  constructor: (sndurl) ->
    @ii = 0
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

  play: ->
    if @datamode is 0
      @datamode = 1
      @data.play()
    else if @altdatamode is 0
      @altdatamode = 1
      @altdata.play()

  stop: ->
    if @datamode isnt 0
      @datamode = 0
      @data.pause()
      @data.currentTime = 0
    if @altdatamode isnt 0
      @altdatamode = 0
      @altdata.pause()
      @altdata.currentTime = 0

  pause: ->
    if @datamode is 1
      @datamode = 2
      @data.pause()
    if @altdatamode is 1
      @altdatamode = 2
      @altdata.pause()

  unpause: ->
    if @datamode is 2
      @datamode = 1
      @data.play()
    if @altdatamode is 2
      @altdatamode = 1
      @altdata.play()

  fade: (volume) ->
    @data.volume = volume
    @altdata.volume = volume
