class soundhandler
  constructor: (@musicext, @soundext) ->
    @volume = 1
    @volnew = 1
    @list = []
    serv.formats.filetype.push
      head: "trk/"
      call: (url) -> if serv.audio.musicext isnt 0
        newf = serv.audio.add url + serv.audio.musicext
        serv.load.loadcount.push newf
        newf.data.addEventListener "canplaythrough", => serv.formats.finish newf
        newf
    serv.formats.filetype.push
      head: "snd/"
      call: (url) -> if serv.audio.soundext isnt 0
        newf = serv.audio.add url + serv.audio.soundext
        serv.load.loadcount.push newf
        newf.data.addEventListener "canplaythrough", => serv.formats.finish newf
        newf

  add: (sndurl, type) ->
    newsound = new audio sndurl
    @list[0].push newsound
    newsound

  push: -> @list.unshift []

  erase: -> @clear() for i in @list

  clear: ->
    for sound in @list.shift()
      window.clearInterval sound.ii if sound.ii isnt 0
      sound.stop()

  render: (buffer) ->
    @volume = 0 if @volume < 0
    @volume = 1 if @volume > 1
    for j in @list then for i in j
      if i.oldset and not i.newset
        if i.ii is 0 then i.pause()
        else i.fade 0
      if i.newset and not i.oldset
        if i.ii is 0 then i.unpause()
        else i.fade @volume
      i.oldset = i.newset
      i.newset = no
      if @volnew isnt @volume
        @volnew = @volume
        i.fade @volume
    no

  input: (keys) -> no
