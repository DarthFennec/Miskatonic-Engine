icutscene = (images, global) ->
  global.cutscenemgr.initialize [
    new clip 150, [
      (text, frame, choice) ->
        text[3] = "#You chose one!" if choice is 0
        text[3] = "#You chose two!" if choice is 1
      "#This is some text during a cutscene."
      ";#Make your choice:#;Choice One;Choice Two"
    ], [
      new particle images[2], (t) -> [Math.cos(Math.PI * t / 30) * 200 + 350, Math.sin(Math.PI * t / 30) * 200 + 250, 1, 1]
      new particle images[1], (t) -> [350, 250, 1, global.cutscenemgr.fadeform(t, 30)]
      new particle images[0], (t) -> [0, 0, 1, 1]
    ]
    new clip 0, 0, [new particle images[2], (t) -> global.cutscenemgr.zoomform 64, 64, 400, 300, Math.cos(Math.PI * t / 30) + 1, 1]
    new clip 50, 0, [new particle images[1], (t) -> [50, 50, 1, 1]]
  ]
