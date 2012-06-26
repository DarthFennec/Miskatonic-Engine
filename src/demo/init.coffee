serv = {}

window.addEventListener "load", ->
  screen = new surface document.getElementById "miskatonic"
  sysinf = new systeminformation
  if not sysinf.basicsupport then screen.buf.parentNode.replaceChild screen.buf.firstChild, screen.buf else
    scenetree = {n: init, c: [
      {n: titlescreen, c: []}
      {n: iscene, c: [
        {n: iconvo, c: []}
        {n: icutscene, c: []}
      ]}
    ]}
    keymap = {up: [38, 87, 90, 188], left: [37, 65, 81], down: [40, 79, 83], right: [39, 68, 69], run: [16, 17, 18], act: [13, 32], pause: [8, 9, 27, 80]}
    serv.scene = scenetree.n
    serv.load = new loader
    serv.formats = new format
    serv.save = new savehandler sysinf.cansaveload
    serv.audio = new soundhandler sysinf.musicext, sysinf.soundext
    serv.reset = (runfirstscene) ->
      serv.audio.erase()
      serv.state = serv.scene
      serv.scene.child[0].initialize() if runfirstscene
    serv.engine = new engine [serv.audio, serv.load], scenetree, screen, keymap
    document.addEventListener "keydown", (e) -> serv.engine.input e.keyCode, 1
    document.addEventListener "keyup", (e) -> serv.engine.input e.keyCode, -1
    window.setInterval (-> serv.engine.step()), 33

init = new scenenode ["img/load", "img/text", "img/pause"],
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
    serv.inscenemgr = new scenehandler
    serv.outscenemgr = new scenehandler
    serv.cutscenemgr = new cutscenehandler @file[1], surf, (new rect 1, 1/3, 38, 4), (new rect 16, 48, 32, 32)
    pausescene = new cutscenehandler @file[1], @file[2], (new rect 5.5, 5, 38, 4), (new rect 16, 48, 32, 32)
    serv.pausemgr = new pauser serv.engine.screen, pausescreen, pausescene
    serv.getai = new aiscripts
    serv.load.loadsprite = new sprite
      sheet  : @file[0]
      area   : new rect 350, 300, 100, 100
      len    : [8]
      speed  : [0]
    serv.engine.rends.push serv.pausemgr, serv.cutscenemgr, serv.inscenemgr, serv.outscenemgr
  (idx) -> @child[if idx + 1 is @child.length then 0 else idx + 1].initialize()
