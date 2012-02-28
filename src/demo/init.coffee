$(document).ready -> iscene new init

class init
  constructor: ->
    @fileloader = new filehandler
    loadsprite = new sprite 
      sheet  : @fileloader.loadimg "img/load.png"
      area   : new rect 350, 300, 100, 100
      vector : 0
      mode   : 0
      len    : [8]
      speed  : [0]
    pause = @fileloader.loadimg "img/pause.png"
    textmgr = new texthandler @fileloader.loadimg("img/text.png"), 38, 3,
      new rect(16, 16, 656, 160), new rect(-16, 16, 32, 32), new rect(0, 0, 100, 100)
    @cutscenemgr = new cutscenehandler textmgr
    @scenemgr = new scenehandler textmgr
    @fademgr = new fader
    @gfx = new graphicshandler
    rends = [
      new loader loadsprite, @fileloader, new rect(250, 425, 300, 50)
      new pauser pause, $("#miskatonic").get(0)
      @fademgr
      @cutscenemgr
      @scenemgr
    ]
    @engine = new miskatonic $("#miskatonic").get(0), rends
    $(document).keydown 1, @engine.input
    $(document).keyup -1, @engine.input
    window.setInterval @engine.step, 33
