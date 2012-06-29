icutscene = new scenenode ["img/room.test0", "img/thumb.art1", "img/artifact.quest"],
  -> serv.cutscenemgr.initialize [{
    len: 150
    elem: [
      new particle @file[2], (t) -> [(Math.cos Math.PI*t/30)*200, (Math.sin Math.PI*t/30)*200, 1, 1, (if t >= 60 then 0 else t + 1)]
      new particle @file[1], (t) -> [0, 0, 1, (@fadeform t, 30), (if t >= 60 then 0 else t + 1)]
      new particle @file[0], (t) -> [0, 0, 1, 1, 0]
    ]
    txt: "#This is some text during a cutscene."
  }, {
    len: 0
    elem: [
      new particle @file[2], (t) -> [0, 0, (Math.cos Math.PI*t/30) + 1, 1, (if t >= 60 then 0 else t + 1)]
      new particle @file[0], (t) -> [0, 0, 1, 1, 0]
    ]
    txt: ";#Make your choice:#;Choice One;Choice Two"
    next: (k) -> 2 + k
  }, {
    len: 50
    txt: "#You chose one!"
    next: => @exitscene -1
  }, {
    len: 50
    txt: "#You chose two!"
    next: => @exitscene -1
  }]
