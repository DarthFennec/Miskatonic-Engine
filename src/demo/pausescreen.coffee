pausescreen = (bkgd, img) -> [{
  elem: [new particle bkgd, (t) -> [0, 0, 1, 1, 0]]
  txt: ";;Continue;Options;Save Game;Quit Game"
  next: (k) -> switch k
    when 0 then -1
    when 2 then (if serv.save.cansaveload then serv.save.savestate 2 else 5)
    else k
}, {
  txt: ";;Audio;Controls;Video;Back"
  next: (k) -> switch k
    when 3 then 0
    when 0 then (if serv.audio.musicext is 0 or serv.audio.soundext is 0 then 6 else 7)
    else 7 + k
}, {
  txt: "    Your progress has been saved."
  next: -1
}, {
  txt: ";    Are you sure you want to quit?#;Yes;No"
  next: (k) -> if k is 0 then 4 else -1
}, {
  len: 50
  overlay: new gradient "#000000", 50, true
  txt: -1
  next: ->
    serv.pausemgr.display.clear yes
    serv.reset yes
    -1
}, {
  txt: "Your browser does not support savestates."
  next: 0
}, {
  txt: "Your browser does not support audio."
  next: 1
}, {
  txt: ";;Mute;Unmute"
  next: (k) ->
    serv.audio.mute k is 0
    -1
}, {
  elem: [
    new particle img[1], (t) -> [5, 72, 1,
      (if 0 <= t < 15 then t/15 else if 30 <= t < 45 then 1 - (t - 30)/15 else if 15 <= t < 30 then 1 else 0), (if t >= 119 then 0 else t + 1)]
    new particle img[2], (t) -> [5, 72, 1,
      (if 30 <= t < 45 then (t - 30)/15 else if 60 <= t < 75 then 1 - (t - 60)/15 else if 45 <= t < 60 then 1 else 0), (if t >= 119 then 0 else t + 1)]
    new particle img[3], (t) -> [5, 72, 1,
      (if 60 <= t < 75 then (t - 60)/15 else if 90 <= t < 105 then 1 - (t - 90)/15 else if 75 <= t < 90 then 1 else 0), (if t >= 119 then 0 else t + 1)]
    new particle img[4], (t) -> [5, 72, 1,
      (if 90 <= t < 105 then (t - 90)/15 else if 0 <= t < 15 then 1 - t/15 else if 105 <= t < 120 then 1 else 0), (if t >= 119 then 0 else t + 1)]
    new particle img[0], (t) -> [0, 85, 1, 1, 0]
    new particle bkgd, (t) -> [0, 0, 1, 1, 0]
  ]
  txt: ""
  next: -1
}, {
  txt: ";;Aspect Ratio;3D Effect;Fullscreen;Back"
  next: (k) -> switch k
    when 3 then 1
    else 10 + k
}, {
  txt: ";;4:3;16:10;5:3;16:9"
  next: (k) ->
    switch k
      when 0 then serv.engine.resize 800, 600
      when 1 then serv.engine.resize 960, 600
      when 2 then serv.engine.resize 1000, 600
      when 3 then serv.engine.resize 1066, 600
    -1
}, {
  txt: "This has not been implemented yet."
  next: -1
}, {
  txt: ";;Full Mode;Normal Mode"
  next: (k) ->
    if k is 0 then serv.engine.fullscreen yes else serv.engine.fullscreen no
    13
}, {
  txt: "Please press the F11 key to enter#or leave true fullscreen mode."
  next: -1
}]
