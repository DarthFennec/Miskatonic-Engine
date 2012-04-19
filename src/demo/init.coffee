$(document).ready ->
  screen = new surface $("#miskatonic").get(0)
  global = new Object
  global.load = new loader new filehandler
  global.engine = new miskatonic [global.load], screen
  $(document).keydown 1, global.engine.input
  $(document).keyup -1, global.engine.input
  window.setInterval global.engine.step, 33
  global.load.loadctx.loadandrun ["img/load.png", "img/text.png", "img/pause.png"], init, global

init = (images, global) ->
  txtbkgrnd = new surface new vect 656, 208
  drawtextbackground txtbkgrnd
  global.textmgr = new texthandler images[1], txtbkgrnd, new vect(38, 4), new rect(-16, 16, 32, 32)
  global.scenemgr = new scenehandler global.textmgr
  global.cutscenemgr = new cutscenehandler global.textmgr
  global.fademgr = new fader
  global.pausemgr = new pauser images[2], global.engine.screen
  global.getai = new aiscripts
  global.load.loadsprite = new sprite 
    sheet  : images[0]
    area   : new rect 350, 300, 100, 100
    vector : 0
    mode   : 0
    len    : [8]
    speed  : [0]
  global.engine.rends.push global.pausemgr
  global.engine.rends.push global.fademgr
  global.engine.rends.push global.cutscenemgr
  global.engine.rends.push global.scenemgr
  global.load.loadctx.loadandrun ["img/title.png", "snd/title.ogg"], titlescreen, global

drawtextbackground = (surf) ->
  surf.ctx.fillStyle = "#000000"
  surf.ctx.globalAlpha = 0.7
  surf.clear no
  surf.ctx.beginPath()
  surf.ctx.arc 16, 64, 16, 3 * Math.PI / 2, Math.PI, yes
  surf.ctx.arc 16, 192, 16, Math.PI, Math.PI / 2, yes
  surf.ctx.arc 640, 192, 16, Math.PI / 2, 0, yes
  surf.ctx.arc 640, 64, 16, 0, 3 * Math.PI / 2, yes
  surf.ctx.fill()
  surf.ctx.globalAlpha = 1.0
