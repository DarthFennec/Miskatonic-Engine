class soundhandler
  constructor: (@soundext) ->
    @volume = 1
    @volnew = -1
    @maxvolume = no
    @muted = 0
    @list = []
    serv.formats.filetype.push
      head: "snd/"
      call: (url) ->
        newf = serv.audio.add url + serv.audio.soundext
        if serv.audio.soundext isnt 0
          serv.load.loadcount.push newf
          newf.data.addEventListener "error", ->
            newf.data = -1
            serv.formats.err newf, url + serv.audio.soundext
          newf.data.addEventListener "canplaythrough", -> serv.formats.finish newf
        newf

  add: (sndurl) ->
    newsound = new audio sndurl
    @list[0].push newsound
    newsound

  push: -> @list.unshift []

  erase: -> @clear() for v, i in @list when i isnt 0

  clear: ->
    for sound in @list.shift()
      window.clearInterval sound.ii if sound.ii isnt 0
      sound.stop()

  mute: (newmute) -> if @muted isnt newmute
    @muted = newmute
    @maxvolume = yes
    @volnew = -1

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

  input: (keys) -> no
