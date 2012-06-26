titlescreen = new scenenode ["img/title", "trk/title"],
  -> serv.cutscenemgr.initialize [{
    len: 50
    overlay: new gradient "#000000", 50, false
    snd: new music @file[1], 0, 225
    elem: [new particle @file[0], (t) -> [0, 0, 1, 1]]
  }, {
    len: 0
    txt: ";##;New Game;Load Game"
    next: (k) => if k is 0 then 2 else if not serv.save.cansaveload then 5 else if serv.save.validate() then 4 else 3
  }, {
    len: 30
    overlay: new gradient "#000000", 30, true
    txt: -1
    next: => @exitscene 6
  }, {
    txt: "##There is no save data avaliable."
    next: 1
  }, {
    len: 30
    overlay: new gradient "#000000", 30, true
    txt: -1
    next: -> serv.save.loadstate 6
  }, {
    txt: "##Your browser does not support this feature."
    next: 1
  }, {
    overlay: new gradient "#000000", 30, false
    elem: -1
    snd: -1
    next: -1
  }]
