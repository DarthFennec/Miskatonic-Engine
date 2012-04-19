titlescreen = (images, global) ->
  global.engine.buffer.soundmgr.add images[1]
  images[1].play 225000
  global.cutscenemgr.initialize [
    new clip 0, [
      (text, frame, choice) ->
        global.fademgr.initialize "#000000", (frame) ->
          if frame is 30
            global.cutscenemgr.text.textbox = 0
            global.cutscenemgr.currscene = 0
            global.engine.buffer.soundmgr.remove images[1]
            global.load.loadctx.loadandrun ["img/pinkiepie.gif", "img/tent.png"], iscene, global
          if frame is 60 then -1
          else if frame <= 30 then frame / 30
          else if frame > 30 then (60 - frame) / 30
      ";#Welcome to the pointless title screen.;Play Demo;Play Demo;Play Demo;Play Demo"
      "#Have fun!"
    ], [
      new particle images[0], (t) -> [0, 0, 1, 1]
    ]
    new clip 0, 0, [new particle images[0], (t) -> [0, 0, 1, 1]]
  ]
