# Global singleton, to contain service objects and common global variables.
serv = {}

# Initial function. Create and set up a minimal working engine object,
# bind its IO to the DOM, and load the root scene.
window.onload = ->
  screen = new surface document.getElementById "miskatonic"
  sysinf = new systeminformation
  if not sysinf.basicsupport then screen.buf.parentNode.replaceChild screen.buf.firstChild, screen.buf else
    keymap = up: [38, 87, 90, 188], left: [37, 65, 81], down: [40, 79, 83], right: [39, 68, 69], run: [16], act: [13, 32], pause: [27, 80]
    serv.global = {}
    serv.load = new loader
    serv.save = new savehandler sysinf.cansaveload
    serv.audio = new soundhandler sysinf.soundext
    serv.extern = new extscene
    serv.reset = ->
      serv.audio.erase()
      serv.state = serv.scene
    serv.scene = new scenenode ["txt/title.json", "txt/scene.json"],
      ["img/text", "img/pause", "snd/next", "snd/last", "snd/omenu", "snd/cmenu", "txt/pause.json"]
      ->
        @canreeval = no
        surf = new surface new vect 656, 208
        surf.ctx.fillStyle = "#000000"
        surf.ctx.globalAlpha = 0.7
        surf.clear no
        surf.ctx.beginPath()
        surf.ctx.arc 16, 64, 16, 3*Math.PI/2, Math.PI, yes
        surf.ctx.arc 16, 192, 16, Math.PI, Math.PI/2, yes
        surf.ctx.arc 640, 192, 16, Math.PI/2, 0, yes
        surf.ctx.arc 640, 64, 16, 0, 3*Math.PI/2, yes
        surf.ctx.fill()
        surf.ctx.globalAlpha = 1.0
        serv.getai = new aiscripts
        serv.inscenemgr = new scenehandler
        serv.outscenemgr = new scenehandler
        serv.cutscenemgr = new cutscenehandler @file[0], surf, (new rect 1, 1/3, 38, 4), (new rect 16, 48, 32, 32), (new vect 0, 124), @file[2], @file[3]
        pausescene = new cutscenehandler @file[0], @file[1], (new rect 41/3, 5, 38, 4), (new rect 16, 48, 32, 32), (new vect 0, 0), @file[2], @file[5]
        serv.pausemgr = new pauser serv.engine.screen, @file[6].txt, pausescene, @file[4], @file[5]
        serv.engine.rends.push serv.pausemgr, serv.cutscenemgr, serv.inscenemgr, serv.outscenemgr
      (idx) -> if idx isnt -1 then @initchild (if idx + 1 is @child.length then 0 else idx + 1)
    serv.engine = new engine [serv.audio, serv.load], screen, keymap
    document.addEventListener "keydown", (e) -> serv.engine.input (-> e.preventDefault()), e.keyCode, 1
    document.addEventListener "keyup", (e) -> serv.engine.input (-> e.preventDefault()), e.keyCode, -1
    window.setInterval (-> serv.engine.step()), 33
