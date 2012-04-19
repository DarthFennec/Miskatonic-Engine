class soundhandler
  constructor: ->
    @list = new Array

  add: (newsound) ->
    @list.push newsound

  remove: (oldsound) ->
    idx = @list.indexOf oldsound
    if idx isnt -1
      @list[idx].stop()
      @list.splice idx, 1

  all: (command, arg) ->
    sound[command] arg for sound in @list

class audio
  constructor: (sndurl) ->
    # for @datamode and @altdatamode -> 0 = stopped, 1 = playing, 2 = paused
    @iid = 0
    @datamode = 0
    @altdatamode = 0
    @data = new Audio
    @data.src = sndurl
    @data.addEventListener "ended", => @datamode = 0
    @altdata = new Audio
    @altdata.src = sndurl
    @altdata.addEventListener "ended", => @altdatamode = 0

  play: (repeatoverlap) ->
    @fade 1.0
    if repeatoverlap?
      @stop()
      @iid = window.setInterval =>
        if @datamode is 0
          @datamode = 1
          @data.play()
        else if @altdatamode is 0
          @altdatamode = 1
          @altdata.play()
      , repeatoverlap
    if @datamode isnt 1 and @altdatamode isnt 1
      @datamode = 1
      @data.play()

  pause: ->
    if @datamode is 1 and @iid is 0
      @datamode = 2
      @data.pause()
    if @datamode is 1 and @iid isnt 0
      @fade 0.3

  stop: ->
    if @datamode isnt 0
      @datamode = 0
      @data.pause()
      @data.currentTime = 0
    if @altdatamode isnt 0
      @altdatamode = 0
      @altdata.pause()
      @altdata.currentTime = 0
    if @iid isnt 0
      window.clearInterval @iid
      @iid = 0

  fade: (volume) ->
    @data.volume = volume
    @altdata.volume = volume
