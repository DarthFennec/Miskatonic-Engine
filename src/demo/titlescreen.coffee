titlescreen = new scenenode ["img/title", "snd/title"],
  -> serv.cutscenemgr.initialize [{
    len: 50
    overlay: new gradient "#000000", 50, false
    elem: [new particle @file[0], (t) -> [0, 0, 1, 1, 0]]
  }, {
    len: 0
    txt: "\t\n\tNew Game\tLoad Game"
    snd: @file[1].init 0, 225
    next: (k) => if k is 0 then 2 else if not serv.save.cansaveload then 5 else if serv.save.validate() then 4 else 3
  }, {
    len: 30
    overlay: new gradient "#000000", 30, true
    txt: -1
    next: => @exitscene 6
  }, {
    txt: "\n\nThere is no save data avaliable."
    next: 1
  }, {
    len: 30
    overlay: new gradient "#000000", 30, true
    txt: -1
    next: -> serv.save.loadstate 6
  }, {
    txt: "\n\nYour browser does not support savestates."
    next: 1
  }, {
    overlay: new gradient "#000000", 30, false
    elem: -1
    snd: -1
    next: -1
  }]
