icutscene = (global) ->
  someparticles = [
    new particle "img/room.test0.png", (t) -> [0, 0, 1, 1]
    new particle "img/thumb.art1.png", (t) -> [350, 250, 1, global.gfx.fadeform(t, 30)]
    new particle "img/artifact.quest.png", (t) -> [Math.cos(Math.PI * t / 30) * 200 + 350, Math.sin(Math.PI * t / 30) * 200 + 250, 1, 1]
  ]
  cuttext = [
    (frame, choice) ->
      cuttext[3] = "You chose one!" if choice is 0
      cuttext[3] = "You chose two!" if choice is 1
    "This is some text during a cutscene."
    ":Choice One:Choice Two"
  ]
  acutscene = new cutscene new vect(800, 600), [
    new clip 150, cuttext, someparticles
    new clip 0, 0, [new particle "img/artifact.quest.png", (t) -> global.gfx.zoomform 64, 64, 400, 300, Math.cos(Math.PI * t / 30) + 1, 1]
    new clip 50, 0, [new particle "img/thumb.art1.png", (t) -> [50, 50, 1, 1]]
  ]
  acutscene
