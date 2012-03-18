$(document).ready -> iscene init()

init = ->
  screen = new surface $("#miskatonic").get(0)
  global = new Object
  global.fileloader = new filehandler
  global.textmgr = new texthandler(global.fileloader.loadimg("img/text.png"), new vect(38, 3), new rect(16, 16, 656, 160), new rect(-16, 16, 32, 32), new rect(0, 0, 100, 100))
  global.scenemgr = new scenehandler global.textmgr
  global.cutscenemgr = new cutscenehandler global.textmgr
  global.fademgr = new fader
  global.engine = new miskatonic [
    new loader global.fileloader, new sprite 
      sheet  : global.fileloader.loadimg "img/load.png"
      area   : new rect 350, 300, 100, 100
      vector : 0
      mode   : 0
      len    : [8]
      speed  : [0]
    new pauser global.fileloader.loadimg("img/pause.png"), screen
    global.fademgr
    global.cutscenemgr
    global.scenemgr
  ], screen
  $(document).keydown 1, global.engine.input
  $(document).keyup -1, global.engine.input
  window.setInterval global.engine.step, 33
  global
